//! Sound cue catalog + trigger logic.
//!
//! Six cues total. See docs/SOUND_DESIGN.md §Sound catalog.
//!
//! | Cue    | Trigger                              | Description                          | Volume |
//! |--------|--------------------------------------|--------------------------------------|--------|
//! | `ding` | Notification arrives                 | 880Hz sine, 80ms, soft attack        | -20dB  |
//! | `blip` | Operation success                    | 1200Hz square, 40ms                  | -25dB  |
//! | `fail` | Operation failure                    | 400Hz→200Hz saw, 200ms descending    | -20dB  |
//! | `warn` | Threshold crossed (75°C, <25% bat)   | Two-tone 660Hz→880Hz, 150ms each     | -20dB  |
//! | `alarm`| Critical threshold (90°C, <10% bat)  | Repeating 880Hz square, 100ms on/off | -15dB  |
//! | `alert`| Silent failure (net drop, audio lost)| 1000Hz triangle, 200ms, sharp        | -15dB  |
//!
//! ## DND mode
//!
//! When DND is on (toggled via Super+Shift+d, in-memory only):
//!   - Only `alarm` and `alert` fire
//!   - `ding`, `blip`, `fail`, `warn` are silenced
//!   - Notifications still appear visually
//!
//! See docs/SOUND_DESIGN.md §DND mode.
//!
//! ## TODO (future commit: `dodona(sound): implement cue enum + trigger logic`)
//! - Define `enum Cue { Ding, Blip, Fail, Warn, Alarm, Alert }`
//! - Define `enum Trigger { Notification, OpSuccess, OpFailure, Threshold, CriticalThreshold, SilentFailure }`
//! - Implement `should_fire(trigger, dnd_active) -> Option<Cue>` per the matrix above
//! - Implement `Cue::wav_bytes() -> &'static [u8]` loading from build.rs output
//! - Wire to event sources: each `data::*` module emits triggers on threshold
//!   crossings; the sound module subscribes
