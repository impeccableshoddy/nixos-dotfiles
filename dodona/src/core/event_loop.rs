//! Event loop: drives calloop with the Wayland source + signal handling.
//!
//! Per docs/ARCHITECTURE.md §Process model:
//!   - Main thread owns the Wayland event loop (calloop)
//!   - Worker threads (tokio) will handle async data sources — not yet
//!     wired up, see future commit `dodona(core): wire tokio + wayland
//!     event merging`
//!
//! For this commit: calloop + WaylandSource + SIGINT/SIGTERM (Linux-only
//! via signalfd). The render path is a single solid-color fill on
//! configure; future commits add the real per-frame render pipeline
//! driven by frame callbacks.

use std::time::Duration;

use anyhow::Context;
use smithay_client_toolkit::reexports::calloop::EventLoop;
#[cfg(target_os = "linux")]
use smithay_client_toolkit::reexports::calloop::signals::{Signal, Signals};
use smithay_client_toolkit::reexports::calloop_wayland_source::WaylandSource;
use wayland_client::{Connection, EventQueue};

use super::wayland::App;

/// Run the main event loop. Blocks until exit (ESC, SIGINT, SIGTERM, or
/// compositor close).
///
/// `dispatch` timeout is 50ms — this is the max sleep if no events arrive.
/// For a UI app we want low-latency wakeups, but with calloop the Wayland
/// source wakes the loop immediately on Wayland events, so the timeout
/// only gates how often we'd wake up to do "idle" work. 50ms = 20Hz idle
/// wakeups, ~0% CPU. When we add the clock (100ms tick) and animations
/// (30fps), we'll likely lower this to 16ms or wire up a dedicated
/// timer source.
pub fn run(mut app: App, conn: Connection, event_queue: EventQueue<App>) -> anyhow::Result<()> {
    let mut event_loop: EventLoop<App> =
        EventLoop::try_new().context("failed to create calloop EventLoop")?;
    let loop_handle = event_loop.handle();

    // Insert the Wayland source. This moves `event_queue` into calloop;
    // from here on, all Wayland events are dispatched as calloop events
    // that mutate `app` via the trait impls in `core::wayland`.
    WaylandSource::new(conn, event_queue)
        .insert(loop_handle.clone())
        .context("failed to insert Wayland source into calloop")?;

    // SIGINT / SIGTERM via calloop's signalfd (Linux only).
    // On non-Linux, rely on ESC or compositor close to exit.
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
    #[cfg(not(target_os = "linux"))]
    {
        tracing::warn!(
            "signals source is Linux-only; rely on ESC or compositor close to exit"
        );
    }

    tracing::info!("entering event loop");
    while !app.exit {
        event_loop
            .dispatch(Some(Duration::from_millis(50)), &mut app)
            .context("error dispatching event loop")?;
    }
    tracing::info!("event loop exited cleanly");

    Ok(())
}
