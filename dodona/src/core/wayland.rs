//! Wayland connection + layer-shell surface registration.
//!
//! ONE full-screen Background layer surface. Everything (top readouts,
//! side gauges, bottom status) is drawn as regions on this single canvas.
//! Windows tile freely over it. No separate surfaces, no exclusive zones.
//!
//! Design system (per docs/PALETTE.md, docs/SCOPE.md):
//!   - BG solid #222222, no wallpaper, no gradients
//!   - Single hue (ACCENT #ffa133), brightness/opacity for hierarchy
//!   - Persistent UI = flat, no glow. Glow only for active/alert.
//!   - Typography: Departure Mono everywhere
//!   - Data representation: graph for trends, gauge for single values,
//!     text for clock, dots for workspaces

use std::sync::Arc;

use anyhow::Context;
use smithay_client_toolkit::{
    compositor::{CompositorHandler, CompositorState},
    delegate_compositor, delegate_keyboard, delegate_layer, delegate_output,
    delegate_registry, delegate_seat, delegate_shm,
    output::{OutputHandler, OutputState},
    registry::{ProvidesRegistryState, RegistryState},
    registry_handlers,
    seat::{
        keyboard::{KeyEvent, KeyboardHandler, Keysym, Modifiers},
        Capability, SeatHandler, SeatState,
    },
    shell::{
        wlr_layer::{
            Anchor, KeyboardInteractivity, Layer, LayerShell, LayerShellHandler, LayerSurface,
            LayerSurfaceConfigure,
        },
        WaylandSurface,
    },
    shm::{slot::SlotPool, Shm, ShmHandler},
};
use wayland_client::{
    globals::registry_queue_init,
    protocol::{wl_keyboard, wl_output, wl_seat, wl_shm, wl_surface},
    Connection, EventQueue, QueueHandle,
};

use crate::core::event_loop::AppState;
use crate::render::{SkiaSurface, TextRenderer, Theme};

// --- Layout constants (8px grid per PALETTE.md spacing) ---
const M: f32 = 8.0;           // base margin
const TOPBAR_H: f32 = 24.0;   // top readout strip height (text fits at 12pt)
const RAIL_W: f32 = 48.0;     // rail width (3px gauge + 8px gap + ~37px for label+value text)
const GAUGE_W: f32 = 3.0;     // capillary gauge width
const FONT_SM: f32 = 10.0;    // small labels
const FONT_MD: f32 = 12.0;    // values and readouts
const FONT_LG: f32 = 14.0;    // clock

pub struct App {
    pub registry_state: RegistryState,
    pub seat_state: SeatState,
    pub output_state: OutputState,
    pub shm: Shm,

    pub layer: LayerSurface,
    pub pool: SlotPool,
    pub width: u32,
    pub height: u32,
    pub first_configure: bool,

    pub keyboard: Option<wl_keyboard::WlKeyboard>,
    pub exit: bool,

    pub app_state: Arc<AppState>,
    pub needs_redraw: bool,
    pub skia: SkiaSurface,
    pub text_renderer: TextRenderer,
    pub theme: Theme,
    pub qh: QueueHandle<Self>,
}

impl App {
    pub fn draw(&mut self, qh: &QueueHandle<Self>) {
        let width = self.width.max(1) as i32;
        let height = self.height.max(1) as i32;
        let stride = width * 4;

        self.skia.resize(self.width.max(1), self.height.max(1));

        // 1. Solid BG fill (#222222, no wallpaper, no gradients per PALETTE.md)
        self.skia.clear(self.theme.bg);

        // 2. Draw the instrument panel
        self.draw_top_bar();
        self.draw_left_rail();
        self.draw_right_rail();
        self.draw_bottom_strip();

        // 3. Commit to Wayland
        let (buffer, canvas) = match self
            .pool
            .create_buffer(width, height, stride, wl_shm::Format::Argb8888)
        {
            Ok(b) => b,
            Err(e) => {
                tracing::warn!("create_buffer failed: {e:?}");
                return;
            }
        };

        self.skia.commit_to_shm(canvas);

        let surface = self.layer.wl_surface();
        surface.damage_buffer(0, 0, width, height);
        surface.frame(qh, surface.clone());

        if let Err(e) = buffer.attach_to(surface) {
            tracing::warn!("buffer attach failed: {e:?}");
            return;
        }
        self.layer.commit();
    }

    // ── Top bar ──────────────────────────────────────────────────────
    // A single 1px accent-faint separator line at y=TOPBAR_H.
    // Readouts float above it in the clear space. No box, no panel fill.
    // Layout: [workspace dots] ← margin → [DODONA] ← spacer → [clock] ← spacer → [date]
    fn draw_top_bar(&mut self) {
        let w = self.skia.width() as f32;

        // Separator line at bottom of topbar zone (1px ACCENT_FAINT)
        self.skia.hline(M, w - M, TOPBAR_H, self.theme.accent_faint, 1.0);

        // Clock — centered, primary text (ACCENT_FULL per PALETTE.md)
        let clock_str = self.app_state.clock.read().map(|g| g.time.clone()).unwrap_or_default();
        let clock_w = self.text_renderer.draw_text(
            self.skia.pixmap_mut(),
            &clock_str,
            w / 2.0 - 50.0,
            4.0,
            FONT_LG,
            self.theme.accent_full,
        );

        // Date — right side, secondary text (ACCENT_DIM per PALETTE.md)
        let date_str = self.app_state.clock.read().map(|g| g.date.clone()).unwrap_or_default();
        self.text_renderer.draw_text(
            self.skia.pixmap_mut(),
            &date_str,
            w - M - 120.0,
            6.0,
            FONT_SM,
            self.theme.accent_dim,
        );

        // "DODONA" — left, after workspace dots area
        self.text_renderer.draw_text(
            self.skia.pixmap_mut(),
            "DODONA",
            M + 32.0,
            4.0,
            FONT_MD,
            self.theme.accent_mid,
        );

        // Workspace dots (9 dots, active = ACCENT_FULL, inactive = ACCENT_FAINT)
        let dot_r = 2.0;
        let dot_gap = 6.0;
        let dots_x = M + 4.0;
        let dots_y = TOPBAR_H / 2.0;
        for i in 0..9u32 {
            let cx = dots_x + i as f32 * dot_gap;
            let color = if i == 0 {
                // TODO: read actual workspace from app_state
                self.theme.accent_full
            } else {
                self.theme.accent_faint
            };
            // Draw dot as tiny filled rect (2x2 is close enough to a circle at this scale)
            self.skia.fill_rect(cx - dot_r, dots_y - dot_r, dot_r * 2.0, dot_r * 2.0, color);
        }
    }

    // ── Left rail ────────────────────────────────────────────────────
    // CPU (with sparkline), RAM, GPU — capillary gauges
    // Each gauge: 3px wide vertical fill line on the left, label + value
    // text to the right of it. Total rail width ~48px.
    fn draw_left_rail(&mut self) {
        let h = self.skia.height() as f32;
        let content_h = h - TOPBAR_H - M - 20.0; // leave room for bottom strip
        let y_start = TOPBAR_H + M;
        let gauge_h = (content_h - M * 2.0) / 3.0; // 3 gauges, 8px gap between

        let cpu_val = self.app_state.cpu.read().map(|g| g.aggregate).unwrap_or(0.0);
        self.draw_capillary_gauge(M, y_start, gauge_h, cpu_val, "CPU");

        let ram_val = self.app_state.mem.read().map(|g| g.ram_pct).unwrap_or(0.0);
        self.draw_capillary_gauge(M, y_start + gauge_h + M, gauge_h, ram_val, "RAM");

        let gpu_val = self.app_state.gpu.read().map(|g| g.busy_pct as f32).unwrap_or(0.0);
        self.draw_capillary_gauge(M, y_start + (gauge_h + M) * 2.0, gauge_h, gpu_val, "GPU");
    }

    // ── Right rail ───────────────────────────────────────────────────
    // TEMP, DISK — capillary gauges, mirrored (gauge on right edge)
    fn draw_right_rail(&mut self) {
        let w = self.skia.width() as f32;
        let h = self.skia.height() as f32;
        let content_h = h - TOPBAR_H - M - 20.0;
        let y_start = TOPBAR_H + M;
        let gauge_h = (content_h - M) / 2.0; // 2 gauges, 8px gap

        let temp_val = 0.0; // TODO: populate from temp data source
        self.draw_capillary_gauge_right(w - M - GAUGE_W, y_start, gauge_h, temp_val, "TMP");

        let disk_val = self.app_state.disk.read().map(|g| g.used_pct).unwrap_or(0.0);
        self.draw_capillary_gauge_right(w - M - GAUGE_W, y_start + gauge_h + M, gauge_h, disk_val, "DSK");
    }

    // ── Bottom strip ────────────────────────────────────────────────
    // 1px accent-faint line near bottom, media/git/notification ticker
    fn draw_bottom_strip(&mut self) {
        let w = self.skia.width() as f32;
        let h = self.skia.height() as f32;
        let y = h - 20.0;

        // Separator line
        self.skia.hline(M, w - M, y, self.theme.accent_faint, 1.0);

        // Bottom status text (placeholder)
        self.text_renderer.draw_text(
            self.skia.pixmap_mut(),
            "SYS NOMINAL",
            M + 4.0,
            y + 3.0,
            FONT_SM,
            self.theme.accent_faint,
        );
    }

    // ── Capillary gauge (left rail) ────────────────────────────────
    // A 3px wide vertical line that fills from bottom. Label above,
    // value below. Track in BG_ELEVATED, fill in ACCENT_FULL.
    // State colors per PALETTE.md: WARN = pulse (not implemented yet),
    // ALARM = #ff2e66 solid.
    fn draw_capillary_gauge(
        &mut self,
        x: f32,
        y: f32,
        h: f32,
        value: f32,
        label: &str,
    ) {
        // Track background (BG_ELEVATED per PALETTE.md)
        self.skia.fill_rect(x, y, GAUGE_W, h, self.theme.bg_elevated);

        // Fill from bottom proportional to value (0-100)
        let fill_pct = (value / 100.0).clamp(0.0, 1.0);
        let fill_h = h * fill_pct;
        let fill_y = y + h - fill_h;

        // Color per PALETTE.md state rules: default = ACCENT_FULL,
        // ALARM = #ff2e66 (the one exception hue)
        let fill_color = if value >= 90.0 {
            self.theme.alarm  // ALARM state — the one new hue
        } else {
            self.theme.accent_full  // OK / WARN (behavior diff, not color diff)
        };

        self.skia.fill_rect(x, fill_y, GAUGE_W, fill_h, fill_color);

        // Label above the gauge (ACCENT_DIM per PALETTE.md "secondary text")
        self.text_renderer.draw_text(
            self.skia.pixmap_mut(),
            label,
            x + GAUGE_W + 4.0,
            y,
            FONT_SM,
            self.theme.accent_dim,
        );

        // Value readout below label (ACCENT_FULL per PALETTE.md "primary text")
        let val_str = format!("{:.0}%", value);
        self.text_renderer.draw_text(
            self.skia.pixmap_mut(),
            &val_str,
            x + GAUGE_W + 4.0,
            y + 12.0,
            FONT_MD,
            self.theme.accent_full,
        );
    }

    // ── Capillary gauge (right rail, mirrored) ─────────────────────
    // Same as left but gauge line is on the right edge, text to its left
    fn draw_capillary_gauge_right(
        &mut self,
        gauge_x: f32,
        y: f32,
        h: f32,
        value: f32,
        label: &str,
    ) {
        // Track
        self.skia.fill_rect(gauge_x, y, GAUGE_W, h, self.theme.bg_elevated);

        // Fill from bottom
        let fill_pct = (value / 100.0).clamp(0.0, 1.0);
        let fill_h = h * fill_pct;
        let fill_y = y + h - fill_h;

        let fill_color = if value >= 90.0 {
            self.theme.alarm
        } else {
            self.theme.accent_full
        };

        self.skia.fill_rect(gauge_x, fill_y, GAUGE_W, fill_h, fill_color);

        // Label and value to the LEFT of the gauge
        let text_right_edge = gauge_x - 4.0;

        let val_str = format!("{:.0}%", value);
        // Value first (right-aligned approximation)
        self.text_renderer.draw_text(
            self.skia.pixmap_mut(),
            &val_str,
            text_right_edge - 36.0,
            y,
            FONT_MD,
            self.theme.accent_full,
        );

        self.text_renderer.draw_text(
            self.skia.pixmap_mut(),
            label,
            text_right_edge - 36.0,
            y + 14.0,
            FONT_SM,
            self.theme.accent_dim,
        );
    }
}

/// Connect to Wayland and create the full-screen Background layer surface.
pub fn connect() -> anyhow::Result<(App, Connection, EventQueue<App>)> {
    let conn = Connection::connect_to_env()
        .context("failed to connect to Wayland (is WAYLAND_DISPLAY set?)")?;
    let (globals, event_queue) =
        registry_queue_init(&conn).context("failed to initialize Wayland registry")?;
    let qh = event_queue.handle();

    let compositor = CompositorState::bind(&globals, &qh)
        .context("wl_compositor not available")?;
    let layer_shell = LayerShell::bind(&globals, &qh)
        .context("wlr_layer_shell_v1 not available")?;
    let shm = Shm::bind(&globals, &qh).context("wl_shm not available")?;

    let surface = compositor.create_surface(&qh);
    let layer = layer_shell.create_layer_surface(
        &qh,
        surface,
        Layer::Background,
        Some("dodona-background"),
        None,
    );

    layer.set_anchor(Anchor::TOP | Anchor::BOTTOM | Anchor::LEFT | Anchor::RIGHT);
    layer.set_size(0, 0);
    layer.set_exclusive_zone(0);
    layer.set_keyboard_interactivity(KeyboardInteractivity::OnDemand);
    layer.commit();

    let pool = SlotPool::new(3840 * 2160 * 4, &shm)
        .context("failed to create SlotPool")?;

    let theme = Theme::load().context("failed to load theme")?;
    let skia = SkiaSurface::new(1, 1).context("failed to create initial SkiaSurface")?;
    let text_renderer = TextRenderer::new(theme.departure_mono, theme.commit_mono);
    let app_state = Arc::new(AppState::new());

    let app = App {
        registry_state: RegistryState::new(&globals),
        seat_state: SeatState::new(&globals, &qh),
        output_state: OutputState::new(&globals, &qh),
        shm,
        layer,
        pool,
        width: 0,
        height: 0,
        first_configure: true,
        keyboard: None,
        exit: false,
        app_state,
        needs_redraw: false,
        skia,
        text_renderer,
        theme,
        qh: qh.clone(),
    };

    tracing::info!("connected to Wayland, created Background layer surface (full screen, exclusive_zone=0)");

    Ok((app, conn, event_queue))
}

// --- SCTK trait implementations ---

impl CompositorHandler for App {
    fn scale_factor_changed(&mut self, _conn: &Connection, _qh: &QueueHandle<Self>, _surface: &wl_surface::WlSurface, _new_factor: i32) {}
    fn transform_changed(&mut self, _conn: &Connection, _qh: &QueueHandle<Self>, _surface: &wl_surface::WlSurface, _new_transform: wl_output::Transform) {}
    fn frame(&mut self, _conn: &Connection, _qh: &QueueHandle<Self>, _surface: &wl_surface::WlSurface, _time: u32) {}
    fn surface_enter(&mut self, _conn: &Connection, _qh: &QueueHandle<Self>, _surface: &wl_surface::WlSurface, _output: &wl_output::WlOutput) {}
    fn surface_leave(&mut self, _conn: &Connection, _qh: &QueueHandle<Self>, _surface: &wl_surface::WlSurface, _output: &wl_output::WlOutput) {}
}

impl OutputHandler for App {
    fn output_state(&mut self) -> &mut OutputState { &mut self.output_state }
    fn new_output(&mut self, _conn: &Connection, _qh: &QueueHandle<Self>, _output: wl_output::WlOutput) {}
    fn update_output(&mut self, _conn: &Connection, _qh: &QueueHandle<Self>, _output: wl_output::WlOutput) {}
    fn output_destroyed(&mut self, _conn: &Connection, _qh: &QueueHandle<Self>, _output: wl_output::WlOutput) {}
}

impl LayerShellHandler for App {
    fn closed(&mut self, _conn: &Connection, _qh: &QueueHandle<Self>, _layer: &LayerSurface) {
        tracing::info!("layer surface closed by compositor");
        self.exit = true;
    }

    fn configure(
        &mut self,
        _conn: &Connection,
        qh: &QueueHandle<Self>,
        _layer: &LayerSurface,
        configure: LayerSurfaceConfigure,
        _serial: u32,
    ) {
        if configure.new_size.0 == 0 || configure.new_size.1 == 0 {
            self.width = 0;
            self.height = 0;
        } else {
            self.width = configure.new_size.0;
            self.height = configure.new_size.1;
        }
        tracing::info!("configure: {}x{}", self.width, self.height);

        if self.first_configure {
            self.first_configure = false;
            tracing::info!("first configure received, drawing initial frame");
        }
        self.draw(qh);
    }
}

impl SeatHandler for App {
    fn seat_state(&mut self) -> &mut SeatState { &mut self.seat_state }
    fn new_seat(&mut self, _: &Connection, _: &QueueHandle<Self>, _: wl_seat::WlSeat) {}
    fn new_capability(&mut self, _conn: &Connection, qh: &QueueHandle<Self>, seat: wl_seat::WlSeat, capability: Capability) {
        if capability == Capability::Keyboard && self.keyboard.is_none() {
            match self.seat_state.get_keyboard(qh, &seat, None) {
                Ok(kbd) => { self.keyboard = Some(kbd); tracing::debug!("keyboard bound"); }
                Err(e) => tracing::warn!("failed to bind keyboard: {e:?}"),
            }
        }
    }
    fn remove_capability(&mut self, _conn: &Connection, _qh: &QueueHandle<Self>, _seat: wl_seat::WlSeat, capability: Capability) {
        if capability == Capability::Keyboard {
            if let Some(kbd) = self.keyboard.take() { kbd.release(); }
        }
    }
    fn remove_seat(&mut self, _: &Connection, _: &QueueHandle<Self>, _: wl_seat::WlSeat) {}
}

impl KeyboardHandler for App {
    fn enter(&mut self, _: &Connection, _: &QueueHandle<Self>, _: &wl_keyboard::WlKeyboard, _surface: &wl_surface::WlSurface, _: u32, _: &[u32], _keysyms: &[Keysym]) {}
    fn leave(&mut self, _: &Connection, _: &QueueHandle<Self>, _: &wl_keyboard::WlKeyboard, _surface: &wl_surface::WlSurface, _: u32) {}
    fn press_key(&mut self, _conn: &Connection, _qh: &QueueHandle<Self>, _: &wl_keyboard::WlKeyboard, _: u32, event: KeyEvent) {
        if event.keysym == Keysym::Escape {
            tracing::info!("ESC pressed, exiting");
            self.exit = true;
        }
    }
    fn release_key(&mut self, _: &Connection, _: &QueueHandle<Self>, _: &wl_keyboard::WlKeyboard, _: u32, _event: KeyEvent) {}
    fn update_modifiers(&mut self, _: &Connection, _: &QueueHandle<Self>, _: &wl_keyboard::WlKeyboard, _serial: u32, _modifiers: Modifiers, _layout: u32) {}
}

impl ShmHandler for App {
    fn shm_state(&mut self) -> &mut Shm { &mut self.shm }
}

impl ProvidesRegistryState for App {
    fn registry(&mut self) -> &mut RegistryState { &mut self.registry_state }
    registry_handlers![OutputState, SeatState];
}

delegate_compositor!(App);
delegate_output!(App);
delegate_shm!(App);
delegate_seat!(App);
delegate_keyboard!(App);
delegate_layer!(App);
delegate_registry!(App);
