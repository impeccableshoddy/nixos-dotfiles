//! tiny-skia wrapper: pixmap management, buffer commit.
//!
//! Owns the per-surface `tiny_skia::Pixmap` (CPU RGBA buffer). The render
//! loop writes into this pixmap, then `Surface::commit` blits it into the
//! Wayland shm buffer.
//!
//! tiny-skia gives us:
//!   - Anti-aliased paths, rects, arcs
//!   - Linear and radial gradients
//!   - Per-pixel alpha blending
//!   - Stroke and fill with dashing
//!
//! What it doesn't give us (and we don't need):
//!   - GPU acceleration (we're CPU-only by design — see docs/SCOPE.md)
//!   - Real-time blur (we approximate with stacked alpha layers)
//!
//! ## TODO (future commit: `dodona(render): wire tiny-skia pixmap commit to wayland buffer`)
//! - Implement `SkiaSurface` wrapping `tiny_skia::Pixmap`
//! - Implement `clear(color)` per docs/PALETTE.md background policy
//! - Implement `flush()` returning a slice suitable for shm copy
//! - Profile: ensure 3ms/frame budget for topbar (see docs/ARCHITECTURE.md
//!   §Performance budget)
