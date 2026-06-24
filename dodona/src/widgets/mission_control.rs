//! Mission control — fullscreen overlay dashboard (Super+0).
//!
//! Covers the entire screen when active. Layer-shell overlay, above all
//! other surfaces. Slides in from the top (per docs/SCOPE.md §Non-goals:
//! slide is one of the three allowed animations).
//!
//! Contents:
//!   - Large GeoIP globe (wireframe sphere + traffic arcs)
//!   - Scrolling graphs (CPU, RAM, GPU, NET, DISK over 60s)
//!   - Process tree (top 10 by CPU, top 10 by RAM)
//!   - Network connections list (active TCP connections with geo)
//!
//! Per docs/PALETTE.md: glow IS allowed here (on-demand, not persistent).
//!
//! ## TODO (future commit: `dodona(widgets): implement mission_control`)
//! - Define `MissionControl { visible: bool, slide_progress: f32 }`
//! - Implement `toggle()` triggering slide-in/out animation (200ms)
//! - Implement `render(&self, pixmap, state)` drawing all sub-panels
//! - Implement keyboard nav: tab between sections, esc to close
//! - Profile: this is the heaviest widget, budget 8ms/frame (still 30fps)
