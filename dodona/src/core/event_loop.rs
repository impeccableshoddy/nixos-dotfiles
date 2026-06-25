//! Event loop: drives calloop with the Wayland source, signal handling,
//! and the tokio-calloop bridge via calloop sync channels.

use std::sync::atomic::AtomicBool;
use std::sync::RwLock;
use std::time::Duration;

use anyhow::Context;
use smithay_client_toolkit::reexports::calloop::EventLoop;
#[cfg(target_os = "linux")]
use smithay_client_toolkit::reexports::calloop::signals::{Signal, Signals};
use smithay_client_toolkit::reexports::calloop_wayland_source::WaylandSource;
use wayland_client::{Connection, EventQueue};

use super::wayland::App;
use crate::data;

// --- Snapshot types ---

#[derive(Debug, Clone)]
pub struct CpuSnapshot {
    pub aggregate: f32,
    pub per_core: Vec<f32>,
}

#[derive(Debug, Clone)]
pub struct MemSnapshot {
    pub ram_pct: f32,
    pub swap_pct: f32,
}

#[derive(Debug, Clone)]
pub struct ClockSnapshot {
    pub time: String,
    pub date: String,
    pub unix_ms: u128,
}

#[derive(Debug, Clone, Default)]
pub struct TempSnapshot {
    pub sensors: Vec<(String, f32)>,
}

#[derive(Debug, Clone, Default)]
pub struct GpuSnapshot {
    pub busy_pct: u8,
}

#[derive(Debug, Clone, Default)]
pub struct DiskSnapshot {
    pub used_pct: f32,
}

#[derive(Debug, Clone, Default)]
pub struct PowerSnapshot {
    pub capacity_pct: u8,
    pub charging: bool,
}

#[derive(Debug, Clone, Default)]
pub struct NetSnapshot {
    pub rx_bps: u64,
    pub tx_bps: u64,
}

#[derive(Debug, Clone, Default)]
pub struct AudioSnapshot {
    pub sink_volume: f32,
    pub muted: bool,
}

// --- UiEvent ---

#[derive(Debug)]
pub enum UiEvent {
    Cpu(CpuSnapshot),
    Mem(MemSnapshot),
    Temp(TempSnapshot),
    Gpu(GpuSnapshot),
    Disk(DiskSnapshot),
    Power(PowerSnapshot),
    Clock(ClockSnapshot),
    Net(NetSnapshot),
    Audio(AudioSnapshot),
}

// --- AppState ---

pub struct AppState {
    pub cpu: RwLock<CpuSnapshot>,
    pub mem: RwLock<MemSnapshot>,
    pub temp: RwLock<TempSnapshot>,
    pub gpu: RwLock<GpuSnapshot>,
    pub disk: RwLock<DiskSnapshot>,
    pub power: RwLock<PowerSnapshot>,
    pub clock: RwLock<ClockSnapshot>,
    pub net: RwLock<NetSnapshot>,
    pub audio: RwLock<AudioSnapshot>,
    pub dnd: AtomicBool,
}

impl AppState {
    pub fn new() -> Self {
        Self {
            cpu: RwLock::new(CpuSnapshot { aggregate: 0.0, per_core: vec![0.0] }),
            mem: RwLock::new(MemSnapshot { ram_pct: 0.0, swap_pct: 0.0 }),
            temp: RwLock::new(TempSnapshot::default()),
            gpu: RwLock::new(GpuSnapshot::default()),
            disk: RwLock::new(DiskSnapshot::default()),
            power: RwLock::new(PowerSnapshot::default()),
            clock: RwLock::new(ClockSnapshot {
                time: "00:00:00.000".into(),
                date: "01-Jan-1970".into(),
                unix_ms: 0,
            }),
            net: RwLock::new(NetSnapshot::default()),
            audio: RwLock::new(AudioSnapshot::default()),
            dnd: AtomicBool::new(false),
        }
    }

    pub fn apply(&self, event: UiEvent) {
        match event {
            UiEvent::Cpu(s) => { if let Ok(mut g) = self.cpu.write() { *g = s; } }
            UiEvent::Mem(s) => { if let Ok(mut g) = self.mem.write() { *g = s; } }
            UiEvent::Temp(s) => { if let Ok(mut g) = self.temp.write() { *g = s; } }
            UiEvent::Gpu(s) => { if let Ok(mut g) = self.gpu.write() { *g = s; } }
            UiEvent::Disk(s) => { if let Ok(mut g) = self.disk.write() { *g = s; } }
            UiEvent::Power(s) => { if let Ok(mut g) = self.power.write() { *g = s; } }
            UiEvent::Clock(s) => { if let Ok(mut g) = self.clock.write() { *g = s; } }
            UiEvent::Net(s) => { if let Ok(mut g) = self.net.write() { *g = s; } }
            UiEvent::Audio(s) => { if let Ok(mut g) = self.audio.write() { *g = s; } }
        }
    }
}

/// Run the main event loop. Blocks until exit.
pub fn run(mut app: App, conn: Connection, event_queue: EventQueue<App>) -> anyhow::Result<()> {
    let mut event_loop: EventLoop<App> =
        EventLoop::try_new().context("failed to create calloop EventLoop")?;
    let loop_handle = event_loop.handle();

    // --- Wayland source ---
    WaylandSource::new(conn, event_queue)
        .insert(loop_handle.clone())
        .context("failed to insert Wayland source into calloop")?;

    // --- Signals (Linux only) ---
    #[cfg(target_os = "linux")]
    {
        let signals = Signals::new(&[Signal::SIGINT, Signal::SIGTERM])
            .context("failed to create Signals source")?;
        loop_handle
            .insert_source(signals, |_signal, _metadata, app: &mut App| {
                tracing::info!("signal received, exiting");
                app.exit = true;
            })
            .context("failed to insert signal source into calloop")?;
    }

    // --- Tokio-calloop bridge ---
    let (ui_tx, ui_rx) = calloop::channel::sync_channel::<UiEvent>(32);

    loop_handle
        .insert_source(ui_rx, |event, _metadata, app: &mut App| {
            match event {
                calloop::channel::Event::Msg(ui_event) => {
                    app.app_state.apply(ui_event);
                    app.needs_redraw = true;
                }
                calloop::channel::Event::Closed => {
                    tracing::warn!("data source channel closed");
                }
            }
        })
        .map_err(|e| anyhow::anyhow!("failed to insert channel source: {e:?}"))?;

    // --- Spawn tokio runtime + data sources ---
    let rt = tokio::runtime::Builder::new_multi_thread()
        .worker_threads(2)
        .enable_all()
        .build()
        .context("failed to build tokio runtime")?;

    let _guard = rt.enter();

    data::time::spawn(ui_tx.clone());
    data::cpu::spawn(ui_tx.clone());
    data::mem::spawn(ui_tx.clone());

    drop(ui_tx);
    drop(_guard);

    loop_handle
        .insert_source(
            calloop::timer::Timer::from_duration(Duration::from_millis(33)),
            move |_instant, _metadata, app: &mut App| {
                if app.needs_redraw && app.width > 0 && app.height > 0 {
                    app.needs_redraw = false;
                    let qh = app.qh.clone();
                    app.draw(&qh);
                }
                calloop::timer::TimeoutAction::ToDuration(Duration::from_millis(33))
            },
        )
        .map_err(|e| anyhow::anyhow!("failed to insert timer source: {e:?}"))?;

    tracing::info!("entering event loop");

    while !app.exit {
        event_loop
            .dispatch(Some(Duration::from_millis(50)), &mut app)
            .context("error dispatching event loop")?;
    }

    rt.shutdown_background();

    tracing::info!("event loop exited cleanly");
    Ok(())
}
