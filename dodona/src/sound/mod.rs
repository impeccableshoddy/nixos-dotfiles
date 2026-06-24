//! Sound: event-driven audio cue system.
//!
//! Six cues total (see docs/SOUND_DESIGN.md §Sound catalog):
//!   ding, blip, fail, warn, alarm, alert
//!
//! Sounds are preloaded into memory at startup as `rodio::SoundBuffer`
//! shared via `Arc`. On event: `tokio::task::spawn_blocking` calls
//! `rodio::Sink::append` with the buffer, plays to completion, sink is
//! dropped. No persistent audio thread.
//!
//! Honors DND mode (see docs/SOUND_DESIGN.md §DND mode).

pub mod cues;
pub mod player;
