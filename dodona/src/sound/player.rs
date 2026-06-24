//! Audio playback via rodio.
//!
//! Sounds loaded into memory at startup as `rodio::SoundBuffer` shared
//! via `Arc`. On event:
//!   - `tokio::task::spawn_blocking` calls `rodio::Sink::append` with the buffer
//!   - Sink plays to completion
//!   - Sink is dropped (no persistent audio thread)
//!
//! Volume scaling:
//!   - At cue time, read master volume from WirePlumber (0.0–1.0)
//!   - cue_base_volume (from docs/SOUND_DESIGN.md) × master_volume = actual
//!   - If master muted: no sound (yes, even for alarms — see docs/SOUND_DESIGN.md
//!     §Volume scaling)
//!
//! ## Cue queue
//!
//! Multiple cues in quick succession: queue them, don't overlap. Each cue
//! plays to completion before the next starts. Exception: `alarm` is allowed
//! to interrupt anything except another `alarm`.
//!
//! ## TODO (future commit: `dodona(sound): implement player with rodio`)
//! - Define `Player { buffers: HashMap<Cue, Arc<SoundBuffer>>, queue: mpsc::Receiver<Cue> }`
//! - Implement `load() -> Player` reading WAVs from build.rs output via `include_bytes!`
//! - Implement `play(cue, master_volume)` spawning `spawn_blocking`
//! - Implement cue queue: single consumer of the mpsc::Receiver, plays sequentially
//! - Implement alarm interrupt: when `alarm` arrives, stop current sink before playing
//! - Graceful degradation: if rodio fails to init (no audio device), log WARN
//!   and disable sound for the session (don't crash)
