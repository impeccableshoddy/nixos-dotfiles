//! Theme: palette + font loading.
//!
//! Hardcoded compile-time palette per docs/PALETTE.md. No runtime config —
//! change the palette = recompile (see docs/SCOPE.md §Out of scope).
//!
//! ## Palette (from docs/PALETTE.md)
//!
//! ```ignore
//! BG          #222222    background, surfaces
//! ACCENT      #ffa133    all UI elements, text, glow
//! ```
//!
//! Derivation rules (mixing BG/ACCENT with black/white at varying alpha)
//! are computed at compile time via `const` functions.
//!
//! ## State colors
//!
//! Only `ALARM` (#ff2e66) introduces a new hue. WARN and CRIT use the
//! accent color with pulse/glow behavior — see docs/PALETTE.md §State colors.
//!
//! ## TODO (future commit: `dodona(render): palette + font loading`)
//! - Define `Theme` struct with all colors as `tiny_skia::Color`
//! - Define `const BG: Color` and `const ACCENT: Color` as the two source colors
//! - Implement derived shades as `const fn mix(color, other, alpha) -> Color`
//! - Load Departure Mono + Commit Mono from vendored assets at startup
//!   (assets/fonts/*.otf, embedded via `include_bytes!`)
//! - Expose `Theme::load() -> Arc<Theme>` for sharing across the render loop
