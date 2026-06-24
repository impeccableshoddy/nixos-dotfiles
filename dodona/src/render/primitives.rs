//! Drawing primitives: line, rect, arc, glow.
//!
//! Thin wrappers over tiny-skia's path API, specialized for our needs:
//!
//!   - `hline(x1, x2, y, color, width)` — horizontal separator
//!   - `vline(x, y1, y2, color, width)` — vertical separator
//!   - `rect(x, y, w, h, fill, stroke)` — panel background + border
//!   - `arc(cx, cy, r, start, end, color, width)` — gauge arcs, globe wireframe
//!   - `glow(x, y, w, h, color, blur)` — 4px glow halo for active elements
//!
//! Per docs/PALETTE.md §Opacity / glow rules:
//!   - Persistent UI = flat, no glow
//!   - Active/hovered elements = 4px glow at 30% alpha
//!   - Glow is a tool for attention, not decoration
//!
//! ## TODO (future commit: `dodona(render): drawing primitives with glow support`)
//! - Implement the 5 primitives above
//! - For `glow`: approximate gaussian blur with 3-4 stacked semi-transparent
//!   rects at increasing radius (true blur is too expensive per frame)
//! - Verify glow budget: glow only fires on hovered/active elements, so
//!   at most 1-2 per frame
