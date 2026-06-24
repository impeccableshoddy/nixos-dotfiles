//! Notifications — custom daemon (replaces mako).
//!
//! Listens on DBus `org.freedesktop.Notifications` and renders popups
//! in the top-right corner.
//!
//! Behavior:
//!   - Each notification has: app name, summary, body, urgency, timeout
//!   - Stack vertically, newest at the bottom (or top — TBD)
//!   - Auto-dismiss after timeout (5s default, 10s for critical)
//!   - Click to dismiss
//!   - Plays `ding` cue on arrival (per docs/SOUND_DESIGN.md §Sound catalog)
//!   - Honors DND mode (visual still shows, sound silenced)
//!
//! ## TODO (future commit: `dodona(widgets): implement notifications`)
//! - Define `Notification { app, summary, body, urgency, expires_at }`
//! - Define `NotificationStack { items: Vec<Notification>, geometry }`
//! - Implement DBus server for `org.freedesktop.Notifications.Notify`
//! - Implement `render(&self, pixmap)` drawing each popup
//! - Implement expiry task: sweep every 100ms, remove expired
//! - Implement click handling via wayland pointer events
