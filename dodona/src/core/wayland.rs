//! Wayland connection + layer-shell surface registration.
//!
//! Wraps `smithay-client-toolkit` 0.19 to:
//!   - Connect to the Wayland display
//!   - Bind wl_registry (via RegistryState), wl_compositor, wl_shm,
//!     wl_seat, wl_output
//!   - Bind zwlr_layer_shell_v1
//!   - Create the top bar layer surface (Top layer, anchored TOP|LEFT|RIGHT,
//!     exclusive zone = bar height, full width)
//!
//! ## Scope of this commit
//!
//! ONE surface (the topbar) as proof-of-life. Future commits add the side
//! rails, bottom status, mission control, launcher, and notification
//! surfaces. When we have multiple surfaces, the surface-state management
//! logic moves to `core::surface`.
//!
//! ## API verification
//!
//! All APIs verified against smithay-client-toolkit 0.19.2 docs.rs + the
//! v0.19.2 `simple_layer.rs` and `simple_window.rs` examples. Key
//! corrections from the initial stub (which guessed the API):
//!   - Module path is `shell::wlr_layer`, NOT `shell::layer`
//!   - The registry trait the App implements is `ProvidesRegistryState`,
//!     NOT `RegistryHandler` (that one is for SCTK's own state types)
//!   - The shm pool type is `shm::slot::SlotPool`, NOT `MemPool` (retired
//!     in 0.18)
//!   - `WaylandSource` is at `reexports::calloop_wayland_source::WaylandSource`

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

/// Bar height in pixels. Per docs/SCOPE.md the topbar is a single row of
/// compact readouts in Departure Mono. 30px fits ~14pt mono comfortably.
pub const BAR_HEIGHT: u32 = 30;

/// Background color per docs/PALETTE.md: solid #222222, opaque.
/// ARGB8888 little-endian => bytes are B,G,R,A => 0xFF222222.
const BG_COLOR: u32 = 0xFF222222;

/// The single state struct that implements all SCTK handler traits.
///
/// Wayland's `QueueHandle<State>` is parameterized by ONE state type, so
/// we need a single struct that implements every trait. This is the
/// standard SCTK pattern — see the v0.19.2 examples.
///
/// When we add tokio integration (future commit), shared data sources
/// will live in a separate `AppState` (per docs/ARCHITECTURE.md), and
/// this struct will hold an `Arc<AppState>` for the render loop to read.
pub struct App {
    // --- SCTK state (registry + bound globals) ---
    pub registry_state: RegistryState,
    pub seat_state: SeatState,
    pub output_state: OutputState,
    pub shm: Shm,

    // --- Top bar surface state ---
    pub layer: LayerSurface,
    pub pool: SlotPool,
    pub width: u32,
    pub height: u32,
    pub first_configure: bool,

    // --- Input ---
    pub keyboard: Option<wl_keyboard::WlKeyboard>,

    // --- Lifecycle ---
    pub exit: bool,
}

impl App {
    /// Draw the current frame.
    ///
    /// For this commit: solid #222222 fill. Future commits will replace
    /// this with a call into `render::skia` to draw the actual topbar
    /// widgets (clock, workspaces, network, volume, battery, brightness).
    pub fn draw(&mut self, qh: &QueueHandle<Self>) {
        let width = self.width.max(1) as i32;
        let height = self.height.max(1) as i32;
        let stride = width * 4;

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

        // Solid BG fill. ARGB8888 LE = bytes B,G,R,A.
        let color = BG_COLOR.to_le_bytes();
        for px in canvas.chunks_exact_mut(4) {
            px.copy_from_slice(&color);
        }

        let surface = self.layer.wl_surface();
        surface.damage_buffer(0, 0, width, height);
        // Request a frame callback so the compositor can ask us to redraw.
        // Not strictly needed for a static bar, but correct for future
        // animated content (clock ms, scrolling graphs, etc.).
        surface.frame(qh, surface.clone());

        if let Err(e) = buffer.attach_to(surface) {
            tracing::warn!("buffer attach failed: {e:?}");
            return;
        }
        self.layer.commit();
    }
}

/// Connect to Wayland and create the top bar layer surface.
///
/// Returns the fully-initialized `App` plus the `Connection` and
/// `EventQueue` (the event loop in `core::event_loop` needs all three
/// to drive dispatch).
pub fn connect() -> anyhow::Result<(App, Connection, EventQueue<App>)> {
    let conn = Connection::connect_to_env()
        .context("failed to connect to Wayland (is WAYLAND_DISPLAY set?)")?;
    let (globals, event_queue) =
        registry_queue_init(&conn).context("failed to initialize Wayland registry")?;
    let qh = event_queue.handle();

    // Bind SCTK state.
    let compositor = CompositorState::bind(&globals, &qh)
        .context("wl_compositor not available")?;
    let layer_shell = LayerShell::bind(&globals, &qh)
        .context("wlr_layer_shell_v1 not available — compositor doesn't support layer-shell")?;
    let shm = Shm::bind(&globals, &qh).context("wl_shm not available")?;

    // Create the top bar layer surface.
    let surface = compositor.create_surface(&qh);
    let layer = layer_shell.create_layer_surface(
        &qh,
        surface,
        Layer::Top,
        Some("dodona-topbar"),
        None, // output: None → appears on all outputs
    );

    // Anchor TOP + LEFT + RIGHT = full-width strip at the top.
    // Width is determined by the compositor (anchored both sides); we set
    // height only. Exclusive zone = height so tiled windows don't overlap
    // the bar. Per docs/PALETTE.md §Application rules.
    layer.set_anchor(Anchor::TOP | Anchor::LEFT | Anchor::RIGHT);
    layer.set_size(0, BAR_HEIGHT);
    layer.set_exclusive_zone(BAR_HEIGHT as i32);
    layer.set_keyboard_interactivity(KeyboardInteractivity::OnDemand);

    // Initial commit with no buffer — required before the compositor sends
    // a configure event.
    layer.commit();

    // Pre-allocate an shm pool big enough for any reasonable laptop width.
    // 8K wide × 30 tall × 4 bytes = ~960KB. SlotPool manages slots within
    // this; if we ever need a wider surface we'll resize here.
    // TODO: resize pool dynamically if configure reports width > 8192.
    let pool =
        SlotPool::new(8192 * BAR_HEIGHT as usize * 4, &shm).context("failed to create SlotPool")?;

    let app = App {
        registry_state: RegistryState::new(&globals),
        seat_state: SeatState::new(&globals, &qh),
        output_state: OutputState::new(&globals, &qh),
        shm,
        layer,
        pool,
        width: 0,
        height: BAR_HEIGHT,
        first_configure: true,
        keyboard: None,
        exit: false,
    };

    tracing::info!("connected to Wayland, created topbar layer surface");

    Ok((app, conn, event_queue))
}

// --- SCTK trait implementations -------------------------------------------
//
// All trait method signatures verified against smithay-client-toolkit 0.19.2
// docs.rs. The delegate macros at the bottom of this file generate the
// wayland-client Dispatch impls that forward events to these handlers.

impl CompositorHandler for App {
    fn scale_factor_changed(
        &mut self,
        _conn: &Connection,
        _qh: &QueueHandle<Self>,
        _surface: &wl_surface::WlSurface,
        _new_factor: i32,
    ) {
        // TODO: re-render on scale change. For now we re-render on configure.
    }

    fn transform_changed(
        &mut self,
        _conn: &Connection,
        _qh: &QueueHandle<Self>,
        _surface: &wl_surface::WlSurface,
        _new_transform: wl_output::Transform,
    ) {
        // TODO: re-render on transform change.
    }

    fn frame(
        &mut self,
        _conn: &Connection,
        _qh: &QueueHandle<Self>,
        _surface: &wl_surface::WlSurface,
        _time: u32,
    ) {
        // Frame callback fired. For a static bar this is a no-op; future
        // commits use this to drive animations (clock ms, scrolling graphs,
        // pulse/glow on warnings, etc.).
    }

    fn surface_enter(
        &mut self,
        _conn: &Connection,
        _qh: &QueueHandle<Self>,
        _surface: &wl_surface::WlSurface,
        _output: &wl_output::WlOutput,
    ) {
    }

    fn surface_leave(
        &mut self,
        _conn: &Connection,
        _qh: &QueueHandle<Self>,
        _surface: &wl_surface::WlSurface,
        _output: &wl_output::WlOutput,
    ) {
    }
}

impl OutputHandler for App {
    fn output_state(&mut self) -> &mut OutputState {
        &mut self.output_state
    }
    fn new_output(
        &mut self,
        _conn: &Connection,
        _qh: &QueueHandle<Self>,
        _output: wl_output::WlOutput,
    ) {
    }
    fn update_output(
        &mut self,
        _conn: &Connection,
        _qh: &QueueHandle<Self>,
        _output: wl_output::WlOutput,
    ) {
    }
    fn output_destroyed(
        &mut self,
        _conn: &Connection,
        _qh: &QueueHandle<Self>,
        _output: wl_output::WlOutput,
    ) {
    }
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
        // When anchored LEFT|RIGHT the compositor picks the width; height
        // echoes our set_size hint (BAR_HEIGHT).
        if configure.new_size.0 == 0 || configure.new_size.1 == 0 {
            self.width = 0;
            self.height = BAR_HEIGHT;
        } else {
            self.width = configure.new_size.0;
            self.height = configure.new_size.1;
        }
        tracing::debug!("configure: {}x{}", self.width, self.height);

        if self.first_configure {
            self.first_configure = false;
            tracing::info!("first configure received, drawing initial frame");
        }
        self.draw(qh);
    }
}

impl SeatHandler for App {
    fn seat_state(&mut self) -> &mut SeatState {
        &mut self.seat_state
    }

    fn new_seat(&mut self, _: &Connection, _: &QueueHandle<Self>, _: wl_seat::WlSeat) {}

    fn new_capability(
        &mut self,
        _conn: &Connection,
        qh: &QueueHandle<Self>,
        seat: wl_seat::WlSeat,
        capability: Capability,
    ) {
        if capability == Capability::Keyboard && self.keyboard.is_none() {
            match self.seat_state.get_keyboard(qh, &seat, None) {
                Ok(kbd) => {
                    self.keyboard = Some(kbd);
                    tracing::debug!("keyboard bound");
                }
                Err(e) => tracing::warn!("failed to bind keyboard: {e:?}"),
            }
        }
    }

    fn remove_capability(
        &mut self,
        _conn: &Connection,
        _qh: &QueueHandle<Self>,
        _seat: wl_seat::WlSeat,
        capability: Capability,
    ) {
        if capability == Capability::Keyboard {
            if let Some(kbd) = self.keyboard.take() {
                kbd.release();
            }
        }
    }

    fn remove_seat(&mut self, _: &Connection, _: &QueueHandle<Self>, _: wl_seat::WlSeat) {}
}

impl KeyboardHandler for App {
    fn enter(
        &mut self,
        _: &Connection,
        _: &QueueHandle<Self>,
        _: &wl_keyboard::WlKeyboard,
        _surface: &wl_surface::WlSurface,
        _: u32,
        _: &[u32],
        _keysyms: &[Keysym],
    ) {
    }

    fn leave(
        &mut self,
        _: &Connection,
        _: &QueueHandle<Self>,
        _: &wl_keyboard::WlKeyboard,
        _surface: &wl_surface::WlSurface,
        _: u32,
    ) {
    }

    fn press_key(
        &mut self,
        _conn: &Connection,
        _qh: &QueueHandle<Self>,
        _: &wl_keyboard::WlKeyboard,
        _: u32,
        event: KeyEvent,
    ) {
        if event.keysym == Keysym::Escape {
            tracing::info!("ESC pressed, exiting");
            self.exit = true;
        }
    }

    fn release_key(
        &mut self,
        _: &Connection,
        _: &QueueHandle<Self>,
        _: &wl_keyboard::WlKeyboard,
        _: u32,
        _event: KeyEvent,
    ) {
    }

    fn update_modifiers(
        &mut self,
        _: &Connection,
        _: &QueueHandle<Self>,
        _: &wl_keyboard::WlKeyboard,
        _serial: u32,
        _modifiers: Modifiers,
        _layout: u32,
    ) {
    }
}

impl ShmHandler for App {
    fn shm_state(&mut self) -> &mut Shm {
        &mut self.shm
    }
}

impl ProvidesRegistryState for App {
    fn registry(&mut self) -> &mut RegistryState {
        &mut self.registry_state
    }
    registry_handlers![OutputState, SeatState];
}

// --- delegate macros (order does not matter) ------------------------------
// These generate the wayland-client `Dispatch` impls that forward protocol
// events to the trait impls above. Verified list from
// https://docs.rs/smithay-client-toolkit/0.19.2/smithay_client_toolkit/index.html#macros
delegate_compositor!(App);
delegate_output!(App);
delegate_shm!(App);
delegate_seat!(App);
delegate_keyboard!(App);
delegate_layer!(App);
delegate_registry!(App);
