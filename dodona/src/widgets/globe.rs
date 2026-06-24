//! GeoIP globe — wireframe sphere with live traffic arcs.
//!
//! Rendered inside mission_control (not standalone). Wireframe sphere
//! built from latitude/longitude grid lines in ACCENT_FAINT.
//!
//! Traffic arcs:
//!   - Each active network connection (from `data::net`) gets an arc
//!     from the user's location to the destination's geo location
//!   - Arc color: ACCENT_FULL, fade-in over 200ms, fade-out over 500ms
//!   - Arc thickness proportional to bytes/s
//!
//! Per docs/PALETTE.md §Opacity / glow rules: glow IS allowed here
//! (mission control is on-demand).
//!
//! ## TODO (future commit: `dodona(widgets): implement globe`)
//! - Define `Globe { rotation: f32, arcs: Vec<Arc> }`
//! - Implement `project(lat, lon, rotation) -> (x, y)` spherical → screen
//! - Implement `render_wireframe(pixmap)` drawing lat/lon grid
//! - Implement `render_arcs(pixmap, arcs)` drawing great-circle paths
//! - Implement slow auto-rotation (1°/s) for ambient motion when visible
//! - Fallback: if geoip DB missing, show abstract topology (concentric rings
//!   with thickness = traffic volume)
