# dodona

Phosphor-CRT control surface for NixOS + Mango WM. Single Rust binary,
Wayland layer-shell client, CPU rendering via tiny-skia, real system
data, event-driven audio cues.

This is the **scaffolding commit** — the cargo project compiles, the
module tree matches `../docs/ARCHITECTURE.md`, but no behavior is
implemented yet. Every module is a stub with a doc comment describing
what it will contain and which future commit will fill it in.

## Status

- `cargo build` — succeeds
- `cargo run` — exits cleanly with a "scaffolding only" log line
- Module tree — complete, all 38 source files in place
- Real implementations — none yet

## What's here

```
dodona/
├── Cargo.toml            # deps pinned per docs/DEPENDENCIES.md
├── build.rs              # stub — will generate WAV cues (see docs/SOUND_DESIGN.md)
├── src/
│   ├── main.rs           # entry, tokio runtime, tracing init
│   ├── core/             # wayland, event_loop, surface
│   ├── render/           # skia, text, primitives, theme
│   ├── data/             # 14 system data sources
│   ├── widgets/          # 8 widgets (topbar, siderails, globe, etc.)
│   ├── sound/            # cues, player
│   └── ipc/              # mangoctl (mmsg output parser)
└── assets/
    ├── fonts/            # vendored later (Departure Mono, Commit Mono)
    ├── sounds/           # generated at build time
    └── geoip/            # fetched separately (MaxMind GeoLite2)
```

## Source of truth

Code is the implementation. The docs in `../docs/` are the source of truth:

- `../docs/SCOPE.md` — what we're building
- `../docs/ARCHITECTURE.md` — module layout, data flow, render loop
- `../docs/PALETTE.md` — `#222222` + `#ffa133`, derivation rules
- `../docs/DEPENDENCIES.md` — pinned crates with rationale
- `../docs/SOUND_DESIGN.md` — 6-cue catalog, DND mode
- `../docs/GIT_WORKFLOW.md` — commit conventions, merge checklist

## Running

```
cargo run
# or with logs
RUST_LOG=info cargo run
```

Nothing happens yet. That's the point.
