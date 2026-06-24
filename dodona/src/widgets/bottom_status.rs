//! Bottom status — media player, dotfiles git status, notification ticker.
//!
//! Anchored to the bottom edge via layer-shell with exclusive zone.
//! Single row split into three sections:
//!
//!   [media: title - artist ▶] [git: branch ✓ / dirty N] [notifications: latest]
//!
//! Each section scrolls if content overflows (horizontal marquee, 60px/s).
//!
//! ## TODO (future commit: `dodona(widgets): implement bottom_status`)
//! - Define `BottomStatus { geometry, sections: [Section; 3] }`
//! - Define `Section { content: String, scroll_offset: f32 }`
//! - Implement `render(&self, pixmap, state)` drawing all three sections
//! - Implement marquee scroll: only when content > section width
//! - Git status: read from `git status --porcelain` in the dotfiles repo,
//!   cached 5s (don't run git on every frame)
