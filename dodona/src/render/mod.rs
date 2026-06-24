//! Render: tiny-skia wrapper, text layout, drawing primitives, theme.
//!
//! All rendering is CPU-side via tiny-skia. Per frame:
//!   1. Receive frame callback from Wayland
//!   2. Snapshot widget states
//!   3. Determine dirty regions
//!   4. Re-render dirty regions to a tiny-skia pixmap
//!   5. Commit to Wayland buffer
//!
//! See docs/ARCHITECTURE.md §Render loop.

pub mod primitives;
pub mod skia;
pub mod text;
pub mod theme;
