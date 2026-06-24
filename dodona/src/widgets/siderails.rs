//! Side rails — vertical gauges for CPU / RAM / GPU / TEMP / DISK.
//!
//! Anchored to left and right edges via layer-shell with exclusive zone.
//! Each gauge is a vertical bar with:
//!   - Fill height proportional to value (0-100%)
//!   - Label (rotated 90°, ACCENT_DIM)
//!   - Numeric readout (rotated 90°, ACCENT_FULL)
//!
//! Layout:
//!   Left rail:  CPU | RAM | GPU
//!   Right rail: TEMP | DISK
//!
//! Gauges use ACCENT_FULL fill on BG_ELEVATED track per docs/PALETTE.md.
//!
//! ## TODO (future commit: `dodona(widgets): implement siderails`)
//! - Define `SideRail { side: Side, gauges: Vec<Gauge> }`
//! - Define `Gauge { label, value: f32, history: RingBuffer<f32> }`
//! - Implement `render(&self, pixmap, state)` drawing each gauge
//! - Implement rotation: text is rendered horizontally then rotated into place
//!   (cosmic-text doesn't natively rotate, we transform via tiny-skia)
