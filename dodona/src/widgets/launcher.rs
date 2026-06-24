//! Launcher — custom app launcher (Super+Space, replaces fuzzel).
//!
//! Centered overlay, above all surfaces. Layer-shell overlay.
//!
//! Behavior:
//!   - Type to filter apps (fuzzy match on .desktop entries)
//!   - Arrow keys to navigate, Enter to launch, Esc to dismiss
//!   - Shows top 5 matches with their icons (we render icons as text
//!     glyphs from Departure Mono — no image loading)
//!
//! Apps source: parse `~/.local/share/applications/*.desktop` and
//! `/run/current-system/sw/share/applications/*.desktop` for `Type=Application`
//! entries. Cache the list at startup.
//!
//! ## TODO (future commit: `dodona(widgets): implement launcher`)
//! - Define `Launcher { visible: bool, query: String, matches: Vec<DesktopEntry>, selected: usize }`
//! - Implement `parse_desktop_files() -> Vec<DesktopEntry>` at startup
//! - Implement `filter(query: &str) -> Vec<&DesktopEntry>` fuzzy match
//! - Implement `render(&self, pixmap)` drawing the centered panel
//! - Implement keybind handling: typing, up/down, enter, esc
//! - Launch via `tokio::process::Command::spawn` (detached)
