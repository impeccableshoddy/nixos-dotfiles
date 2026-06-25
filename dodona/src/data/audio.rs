//! Audio volume — WirePlumber DBus (primary), wpctl (fallback).
//!
//! Primary path: subscribe to WirePlumber's DBus signals for volume
//! changes. WirePlumber exposes:
//!   - `org.freedesktop.DBus.Properties.PropertiesChanged` on
//!     `org.gnome.Mutter.DisplayConfig` or WirePlumber's own interface
//!   - Volume as a float (0.0-1.0) per Sink/Source
//!
//! Fallback path: call `wpctl get-volume @DEFAULT_AUDIO_SINK@` on demand
//! when we need a fresh reading and DBus hasn't notified us of a change.
//!
//! We expose:
//!   - Master sink volume (0.0-1.0)
//!   - Mute state (bool)
//!   - Default sink display name (for the OSD)
//!
//! ## Rate
//!
//! Event-driven via DBus signal. No polling unless we miss an event
//! (handled by a 30s sanity-check timer).
//!
//! ## TODO (future commit: `dodona(data): implement audio source with WirePlumber DBus`)
//! - Implement `AudioSnapshot { sink_volume: f32, sink_muted: bool, sink_name: String }`
//! - Implement DBus proxy for WirePlumber's default sink
//! - Implement `wpctl` fallback via `tokio::process::Command`
//! - Spawn async task with DBus signal listener + 30s sanity timer

use crate::core::event_loop::UiEvent;
pub fn spawn(_tx: calloop::channel::SyncSender<UiEvent>) {}
