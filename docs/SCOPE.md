
# Dodona — Scope Document

## Identity

**Dodona** is a single-binary Rust application that replaces the standard
NixOS desktop shell (status bar, launcher, notifications, OSD) with a
custom-built, phosphor-CRT-inspired control surface. It runs as a Wayland
layer-shell client on top of Mango WM, reads real system state via
filesystem polling and DBus, and renders directly through tiny-skia on a
CPU surface — no GTK, no Qt, no JavaScript, no Electron.

The name comes from Dodona, the oldest Greek oracle and a Jovian moon.
Both meanings fit: watchful, ambient, providing signals you wouldn't
otherwise notice.

## Goal

A daily-driver desktop shell that:

- Looks like a single coherent instrument panel, not a collection of widgets
- Costs less than 1% CPU at idle, less than 2% active, less than 40MB RAM
- Is the only persistent UI process besides Mango WM and foot
- Conveys information you'd otherwise miss (via sound, glow, position)
  without ever being noisy
- Survives 20+ hour continuous use without eye strain or attention fatigue

## In scope

- One Rust binary, `dodona`, packaged as a flake output
- **Top bar** — clock with ms, workspaces, network status, volume, battery,
  brightness
- **Side rails** — vertical gauges for CPU / RAM / GPU / TEMP / DISK
- **Bottom status** — media player, dotfiles git status, notification ticker
- **Mission control overlay** (`Super+0`) — full-screen dashboard with the
  GeoIP globe, scrolling graphs, process tree
- **Custom launcher** (`Super+Space`, replaces fuzzel)
- **Custom notification daemon** (replaces mako)
- **OSD** for volume / brightness changes (event-driven, 1.5s fade)
- **Audio cue system** — event-driven, honors DND
- **Wireframe GeoIP globe** with live network traffic arcs
- Solid `#222222` background (no wallpaper)
- Full palette swap across the existing system: stylix, foot, neovim,
  starship, tmux, fastfetch, limine, lock screen

## Out of scope (explicit)

- Forking Mango WM — animations stay as Mango ships them
- Custom kernel modules
- TTY console theming beyond basic color swap
- Cross-compositor support (Mango only, hardcode layer-shell assumptions)
- Cross-distro support (NixOS flake only)
- Config file format — palette and layout are compile-time; change = recompile
- Theming third-party GUI apps beyond what stylix does automatically
- Multi-monitor support beyond mirror/extend (single-panel layout for now)
- Mobile / touch targets — this is a laptop/workstation shell

## Non-goals (won't do, even if asked)

- **GPU rendering.** CPU-only via tiny-skia. If we ever need shaders we
  revisit, but the performance budget is met on CPU.
- **Plugin system.** Dodona is a single binary. Adding widgets = editing
  source.
- **Network-transparent operation.** Local system only.
- **Animation library.** Animations are minimal, purposeful, never
  decorative. Pulse for warnings, fade for OSD, slide for mission control.
  That's the entire animation vocabulary.
- **Theming third-party apps.** Firefox, GIMP, LibreOffice stay as
  themselves, recolored by stylix where it can. Accept this.

## Success criteria

| Criterion | Target | Measured by |
|---|---|---|
| Idle CPU | < 1% | `btop` over 10 min idle |
| Active CPU | < 2% | `btop` during typical use (typing, browsing) |
| RAM | < 40MB RSS | `ps -o rss` after 1h uptime |
| Binary size | < 15MB | `ls -lh` on release build |
| Cold start | < 200ms | `time dodona` until first frame |
| Crash-free | 24h continuous | No panics, no aborts |
| Battery impact | < 2% / hour | Compared to baseline (mako + fuzzel) |
| Visual coherence | All surfaces match palette | Manual review against PALETTE.md |
| Sound discipline | Zero "noise" sounds | Manual review against SOUND_DESIGN.md |

If any criterion fails, we don't ship. We fix it or we cut scope.

## Target hardware

- The same laptop the dotfiles currently run on: AMD APU, eDP-1,
  single monitor
- If you switch hardware, dodona may need tweaks (monitor output name,
  sensor paths)

## Maintenance model

- Single author, single machine
- No backwards compatibility promises
- Breaking changes are fine — edit, recompile, move on
- The docs in `docs/` are the source of truth. Code is implementation.

## Why not the alternatives

| Tool | Why not |
|---|---|
| waybar | GTK + CSS, not yours, widget-shaped, breaks the phosphor look |
| AGS | TypeScript + GTK, bloat, runtime cost |
| Eww | Closer in spirit, but config-driven, not code-driven |
| Custom Mango patches | 6+ months of work, high risk of losing interest |
| conky / polybar | X11 legacy or GTK-based, wrong layer |

Dodona exists because none of these let you write the UI as code with
full control while staying lightweight.
