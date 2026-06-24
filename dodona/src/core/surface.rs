//! Surface lifecycle: create, resize, destroy layer-shell surfaces.
//!
//! ## Current state
//!
//! Not yet used. The single topbar surface is created directly in
//! `core::wayland::connect()` and managed inline on the `App` struct.
//!
//! ## When this module becomes useful
//!
//! When we add the second surface (side rails, bottom status, mission
//! control, launcher, or notifications), the per-surface state currently
//! inline on `App` (layer, pool, width, height, first_configure, dirty
//! flag) should be extracted into a `Surface` struct here, and `App`
//! will hold a `Vec<Surface>` or a struct of named surfaces:
//!
//! ```ignore
//! struct Surfaces {
//!     topbar: Surface,
//!     left_rail: Surface,
//!     right_rail: Surface,
//!     bottom_status: Surface,
//!     mission_control: Option<Surface>,  // created on demand
//!     launcher: Option<Surface>,         // created on demand
//! }
//! ```
//!
//! ## TODO (future commit: `dodona(core): surface lifecycle and buffer management`)
//! - Extract `Surface { layer, pool, width, height, dirty }` from `App`
//! - Implement `Surface::new(anchor, size, exclusive_zone, namespace)`
//! - Implement `Surface::resize()` reallocating the shm buffer
//! - Implement `Surface::commit(pixmap)` blitting a tiny-skia pixmap into shm
//! - Implement `Surface::destroy()` cleanly releasing wayland resources
//! - Handle layer-shell exclusive zone negotiation per surface
