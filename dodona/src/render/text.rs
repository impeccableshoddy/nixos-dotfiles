//! Text layout and rendering via `cosmic-text`.
//!
//! Cosmic-text handles:
//!   - Complex script shaping (we use it for Latin only, but it's there)
//!   - Ligatures (Commit Mono / Departure Mono have programming ligatures)
//!   - Font fallback (we vendor both fonts, but fallback covers missing glyphs)
//!   - Glyph rasterization to a tiny-skia-compatible alpha mask
//!
//! We use Departure Mono for all UI text, Commit Mono is loaded as a fallback
//! (per docs/PALETTE.md §Typography).
//!
//! ## TODO (future commit: `dodona(render): cosmic-text integration for ui text`)
//! - Implement `TextLayout` struct caching shaped runs per widget
//! - Implement `shape(text, font_size, weight) -> Vec<Glyph>`
//! - Implement `draw(pixmap, glyphs, x, y, color)` rasterizing into the pixmap
//! - Cache glyph atlases per font size (avoid re-rasterizing the same glyphs)
//! - Honor `ACCENT_FULL` / `ACCENT_DIM` / `ACCENT_FAINT` from render::theme
