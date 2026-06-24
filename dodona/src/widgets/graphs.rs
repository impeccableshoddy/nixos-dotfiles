//! Reusable graph primitives — scrolling graph, bar, gauge.
//!
//! Used by other widgets (topbar sparkline, siderails gauges, mission
//! control full graphs).
//!
//! Three primitives:
//!
//!   - `ScrollingGraph` — line graph of a `RingBuffer<f32>` over time.
//!       Width = N samples, height = max value. Line in ACCENT_FULL,
//!       fill below in ACCENT_FULL @ 20% alpha.
//!   - `Bar` — horizontal or vertical bar with fill %.
//!       Fill in ACCENT_FULL, track in BG_ELEVATED, 1px border ACCENT_FAINT.
//!   - `Gauge` — radial arc gauge (used in mission control).
//!       Background arc in ACCENT_FAINT, value arc in ACCENT_FULL.
//!
//! ## TODO (future commit: `dodona(widgets): implement graphs`)
//! - Define `RingBuffer<T>` with fixed capacity, ring semantics
//! - Define `ScrollingGraph { data: RingBuffer<f32>, geometry }`
//! - Define `Bar { value: f32, orientation: Orientation, geometry }`
//! - Define `Gauge { value: f32, geometry }`
//! - Implement `render(pixmap)` for each, using `render::primitives`
//! - Optimize: scrolling graph reuses last frame's path shifted left 1px
//!   (avoid rebuilding the entire path each frame)
