# Dodona Project Docs

Dodona is a single-binary Rust desktop shell for NixOS + Mango WM. It
replaces mako, fuzzel, and any future status bar with one custom-built,
phosphor-CRT-inspired control surface — Wayland layer-shell, CPU rendering
via tiny-skia, real system data, event-driven audio cues.

These documents are the source of truth. Code is the implementation.

## Documents

| Doc | What it covers |
|---|---|
| [SCOPE.md](SCOPE.md) | What we're building, what we're not, success criteria |
| [ARCHITECTURE.md](ARCHITECTURE.md) | Module layout, data flow, render loop, event system |
| [PALETTE.md](PALETTE.md) | The two colors, derivation rules, application rules |
| [DEPENDENCIES.md](DEPENDENCIES.md) | Cargo deps, system deps, vendored assets |
| [SOUND_DESIGN.md](SOUND_DESIGN.md) | When sounds fire, the catalog, DND mode |
| [GIT_WORKFLOW.md](GIT_WORKFLOW.md) | Branches, commits, merge checklist |

## Reading order

1. **SCOPE.md** — understand what we're doing and why
2. **PALETTE.md** — understand the aesthetic constraint (this drives everything)
3. **ARCHITECTURE.md** — understand how the code is structured
4. **DEPENDENCIES.md** — understand what we depend on and why
5. **SOUND_DESIGN.md** — understand the audio discipline
6. **GIT_WORKFLOW.md** — understand how we ship it

## Status

- v1.0 — initial scope locked, no code yet
- Branch: `feature/dodona`
- Next commit: palette swap across the existing system
