# Sound Design — Dodona

## Philosophy

Sound is for information you'd otherwise miss. Never for confirmation of
things you can already see or hear.

This is the discipline. Every sound in the catalog must answer "yes" to:
"Would the user miss this if they were looking elsewhere?"

## When sound fires

Sound fires when:

- You're focused elsewhere (typing, fullscreen app, eyes off the panel)
- The event is time-sensitive and silent (battery low, network drop,
  build complete)
- The event indicates failure (operation error, alarm condition)

Sound never fires for:

- Things you can already see (volume change, brightness change, workspace
  switch, launcher open, notification dismiss)
- Things you can already hear (media playing, video audio)
- Routine state changes (window open/close, app launch, file save)
- Ambient / decorative purposes (no background music, no loops, no
  "atmosphere")

## Sound catalog

Six cues total. Adding a seventh requires amending this doc with
justification.

| Cue | Trigger | Description | Volume |
|---|---|---|---|
| `ding` | Notification arrives | 880Hz sine, 80ms, soft attack | -20dB |
| `blip` | Operation success (build OK, push OK, command OK) | 1200Hz square, 40ms | -25dB |
| `fail` | Operation failure (build error, command error) | 400Hz→200Hz sawtooth, 200ms descending | -20dB |
| `warn` | Warning threshold crossed (temp > 75°C, battery < 25%, disk > 85%) | Two-tone 660Hz→880Hz, 150ms each | -20dB |
| `alarm` | Critical threshold crossed (temp > 90°C, battery < 10%, disk > 95%) | Repeating 880Hz square, 100ms on/off, until acknowledged | -15dB |
| `alert` | Silent failure (network drop, audio device lost, Wayland disconnect) | 1000Hz triangle, 200ms, sharp | -15dB |

All sounds generated at build time by `build.rs` using a small Rust synth.
We vendor the generated WAVs (~5KB each) so there's no runtime generation
cost and no external assets.

## Implementation

- Sounds loaded into memory at startup as `rodio::SoundBuffer` shared via
  `Arc`
- On event: `tokio::task::spawn_blocking` calls `rodio::Sink::append`
  with the buffer, plays to completion, sink is dropped
- No persistent audio thread — spawned on demand, exits when done
- Honors DND mode (see below)
- Volume scales with system master volume (read from WirePlumber at cue
  time)

## DND mode

- Toggle: `Super+Shift+d` (Mango keybind)
- When DND on:
  - Only `alarm` and `alert` cues fire (silent failures + critical
    thresholds)
  - `ding`, `blip`, `fail`, `warn` are silenced
  - Notifications still appear visually (mako-style popups in dodona)
  - DND icon appears in topbar (`ACCENT_DIM`, hidden when off)
- DND state is in-memory only, not persisted across restarts

## Volume scaling

- At cue time, read master volume from WirePlumber (0.0–1.0)
- Cue base volume (from the table above) × master volume = actual output
- If master muted: no sound (obviously — and yes, this is correct
  behavior even for alarms; if you've muted your system you've chosen
  silence)

## What's deliberately NOT in the catalog

- Click sounds on launcher / buttons (you can see them)
- Boot chime (unnecessary, breaks the "ambient" rule)
- Shutdown sound (you can see the screen go black)
- Per-workspace-enter sound (you can see it)
- Per-window-open sound (you can see it)
- Notification dismissal sound (you initiated it, no need to confirm)
- "Connection established" sound (the absence of `alert` is the signal)
- Charging sound (the battery icon fills up — that's the signal)
- Keyboard typing sounds (we're not a typewriter sim)
- Error beep on invalid input (visual feedback is enough)

If you find yourself wanting to add a sound to this list, ask: "What
would I miss if I were looking at a different window?" If the answer is
"nothing", don't add the sound.

## Cue trigger matrix

| Event | Persistent visual? | Sound? | Why |
|---|---|---|---|
| Notification arrives | Yes (popup, 5s) | `ding` | You may be typing, eyes off panel |
| Build success | No (1.5s pulse) | `blip` | You may have switched windows |
| Build failure | Yes (banner, 3s) | `fail` | You need to know now |
| Temp crosses 75°C | Yes (warning badge) | `warn` | Silent escalation |
| Temp crosses 90°C | Yes (alarm banner) | `alarm` | Action required |
| Battery < 25% | Yes (warning badge) | `warn` | Silent escalation |
| Battery < 10% | Yes (alarm banner) | `alarm` | Action required |
| Network drops | Yes (icon change) | `alert` | Silent failure |
| Audio device lost | Yes (icon change) | `alert` | Silent failure |
| Volume key pressed | Yes (OSD, 1.5s) | none | You can hear the volume change |
| Brightness key pressed | Yes (OSD, 1.5s) | none | You can see the screen dim |
| Workspace switch | Yes (topbar update) | none | You initiated it, you can see it |
| Launcher opened | Yes (overlay) | none | You initiated it, you can see it |

## Edge cases

- **Multiple cues in quick succession:** queue them, don't overlap. Each
  cue plays to completion before the next starts. Exception: `alarm` is
  allowed to interrupt anything except another `alarm`.
- `alarm` is repeating by design: it loops until acknowledged (click the
  banner, press `Esc`, or the condition resolves).
- **Dodona starts in DND mode:** no startup sound, no "welcome" cue. We
  begin in silence.
- **Dodona crashes:** Mango keybind restarts it. No sound on restart.
  The crash itself is invisible to the user (Mango keeps running).

## Audio backend

- Pipewire via rodio (rodio uses `cpal` which uses pipewire-PulseAudio
  compatibility layer on NixOS by default)
- We do not talk to pipewire directly — rodio handles it
- If pipewire is unavailable at runtime, sounds silently fail (logged at
  WARN level, no crash)
