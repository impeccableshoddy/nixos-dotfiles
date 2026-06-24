//! Media playback — MPRIS DBus via playerctl.
//!
//! Subscribes to MPRIS (`org.mpris.MediaPlayer2.*`) DBus signals.
//! playerctl is the canonical MPRIS proxy on NixOS — we call its DBus
//! interface rather than parsing MPRIS directly, because playerctl
//! already handles the multiplicity of players (Spotify, mpv, browsers).
//!
//! We expose:
//!   - Track title, artist, album
//!   - Playback status (Playing / Paused / Stopped)
//!   - Position (seconds, with periodic refresh while playing)
//!   - Length (seconds)
//!   - Player name (for display)
//!
//! ## Rate
//!
//! Event-driven via DBus signal `PropertiesChanged`. Position refreshes
//! on a 1s timer while playing (MPRIS doesn't emit position updates).
//!
//! ## TODO (future commit: `dodona(data): implement media source with MPRIS DBus`)
//! - Implement `MediaSnapshot { title, artist, album, status, position_s, length_s, player }`
//! - Implement DBus proxy for `org.mpris.MediaPlayer2.Player`
//! - Implement position refresh task (1s interval while status == Playing)
//! - Spawn async task with DBus signal listener + position timer
