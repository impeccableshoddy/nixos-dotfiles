//! Top bar widget — clock, workspaces, network, volume, battery, brightness.
//!
//! Anchored to the top edge of the screen via layer-shell with exclusive
//! zone. Single row of compact readouts in Departure Mono.
//!
//! Layout (left → right):
//!   [workspace dots] [active window title]   [time HH:MM:SS.mmm]   [net] [vol] [bat] [bright]
//!
//! Active workspace = ACCENT_FULL dot, inactive = ACCENT_FAINT dot.
//! Per docs/PALETTE.md §Application rules.
//!
//! ## TODO (future commit: `dodona(widgets): implement topbar`)
//! - Define `TopBar { geometry, dirty: bool }`
//! - Implement `layout(width) -> Geometry` computing widget positions
//! - Implement `render(&self, pixmap, state)` drawing all readouts
//! - Verify contrast: ACCENT_FULL on BG = 8.2:1 (AAA per docs/PALETTE.md)
