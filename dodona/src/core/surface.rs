//! Surface lifecycle: create, resize, destroy layer-shell surfaces.
//!
//! Each surface has:
//!   - A wl_surface + zwlr_layer_surface_v1 pair
//!   - A wl_shm backing buffer (we render to CPU, share via shm)
//!   - A geometry (computed on output configure events)
//!   - A dirty flag (set by widget updates, cleared by render loop)
//!
//! ## TODO (future commit: `dodona(core): surface lifecycle and buffer management`)
//! - Implement `Surface` struct with anchor, size, exclusive_zone
//! - Implement `resize()` reallocating the shm buffer
//! - Implement `commit(pixmap)` blitting a tiny-skia pixmap into the shm buffer
//! - Implement `destroy()` cleanly releasing wayland resources
//! - Handle layer-shell exclusive zone negotiation with the compositor
