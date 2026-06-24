# dodona

Phosphor-CRT control surface for NixOS + Mango WM. Single Rust binary,
Wayland layer-shell client, CPU rendering via tiny-skia, real system
data, event-driven audio cues.

## Status

- `cargo build` — succeeds (once `nix develop` shell is active)
- `cargo run` — connects to Wayland, creates a topbar layer surface,
  renders solid `#222222`, exits cleanly on ESC/SIGINT/SIGTERM
- Module tree — complete, all 38 source files in place
- Real implementations — `core::wayland` (WaylandState, layer surface),
  `core::event_loop` (calloop + WaylandSource + signalfd). Everything
  else is still stubs.

## What's here

```
dodona/
├── Cargo.toml            # deps pinned per docs/DEPENDENCIES.md
├── devshell.nix          # `nix develop` shell (rust toolchain + wayland deps)
├── build.rs              # stub — will generate WAV cues (see docs/SOUND_DESIGN.md)
├── src/
│   ├── main.rs           # entry, tracing init, calls core::wayland::connect + event_loop::run
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
# Enter the dev shell (from repo root — flake.nix imports dodona/devshell.nix)
nix develop

# Inside the shell:
cargo build              # compile
cargo run                # launches the topbar (solid #222222 fill for now)
RUST_LOG=debug cargo run # with logs
cargo clippy             # lint
cargo fmt                # format
```

ESC, SIGINT, or SIGTERM exits cleanly. The topbar currently renders a
solid `#222222` fill — the render pipeline (tiny-skia + cosmic-text)
lands in the next commit and replaces this with actual widgets.
