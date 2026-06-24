//! Wayland connection + layer-shell surface registration.
//!
//! Wraps `smithay-client-toolkit` to:
//!   - Connect to the Wayland display
//!   - Bind wl_registry, wl_compositor, wl_shm
//!   - Bind zwlr_layer_shell_v1 and create our surfaces:
//!       - top bar (top edge, exclusive zone)
//!       - side rails (left + right edges, exclusive zone)
//!       - bottom status (bottom edge, exclusive zone)
//!       - mission control overlay (fullscreen, on-demand)
//!       - launcher overlay (centered, on-demand)
//!       - notification popups (top-right, on-demand)
//!
//! ## TODO (future commit: `dodona(core): connect to wayland and create layer-shell surfaces`)
//! - Implement `WaylandState` struct holding the connection + registries
//! - Implement `connect()` returning a `WaylandState`
//! - Implement `create_layer_surface(anchor, size, exclusive_zone)` per surface type
//! - Handle registry add/remove events for output hotplug
