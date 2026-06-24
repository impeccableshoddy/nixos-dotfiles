// Sound cue WAV generation — stub.
//
// Per docs/SOUND_DESIGN.md, this build script will eventually generate
// 6 WAV files (ding, blip, fail, warn, alarm, alert) into
// assets/sounds/ using a small Rust synth:
//   - sine, square, sawtooth, triangle oscillators
//   - ADSR envelope
//   - fixed amplitudes per docs/SOUND_DESIGN.md (cue volumes in -dB)
//
// Not yet implemented — see future commit:
//   dodona(sound): generate WAV cues at build time

fn main() {
    // Intentionally empty for the scaffolding commit.
    // When implemented, this will write WAVs to ${OUT_DIR}/sounds/*.wav
    // and they'll be include_str!'d / loaded from the binary at runtime.
}
