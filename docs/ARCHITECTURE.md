
# Dodona — Architecture

## Process model

Single process, single binary. Tokio multi-threaded runtime with 2 worker
threads (we don't need more). Main thread owns the Wayland event loop and
the render pipeline. Worker threads handle async data sources.

No child processes during normal operation. `wpctl`, `playerctl`,
`brightnessctl`, `mmsg` are called only on events or as fallbacks when DBus
isn't available.

## High-level data flow

```
┌─────────────────┐     ┌──────────────────┐     ┌─────────────────┐
│  Data sources   │     │   Widget state   │     │   Render loop   │
│  (async tasks)  │────▶│   (Arc<RwLock>)  │────▶│   (main thread) │
└─────────────────┘     └──────────────────┘     └─────────────────┘
        │                                                  │
        │                                                  ▼
        │                                           ┌───────────┐
        └─── file watches, DBus, timers ◀──────────│  Wayland  │
                                                  └───────────┘
```

Each data source runs as an async task. It writes its latest reading to a
shared state cell. The render loop, triggered by Wayland frame callbacks,
reads the cells and draws. No locks held during render — read, snapshot,
drop lock, draw.

## Module structure

```
dodona/
├── Cargo.toml
├── README.md
├── build.rs               # generates WAV files for sound cues
├── docs/                  # the docs you're reading
├── src/
│   ├── main.rs            # entry, arg parse, tokio runtime
│   ├── core/
│   │   ├── mod.rs
│   │   ├── wayland.rs     # wl_registry, layer-shell surfaces
│   │   ├── event_loop.rs  # tokio + wayland event merging
│   │   └── surface.rs     # surface lifecycle
│   ├── render/
│   │   ├── mod.rs
│   │   ├── skia.rs        # tiny-skia wrapper
│   │   ├── text.rs        # cosmic-text integration
│   │   ├── primitives.rs  # line, rect, arc, glow
│   │   └── theme.rs       # palette + font loading
│   ├── data/
│   │   ├── mod.rs
│   │   ├── cpu.rs         # /proc/stat
│   │   ├── mem.rs         # /proc/meminfo
│   │   ├── net.rs         # /proc/net/dev + NetworkManager DBus
│   │   ├── disk.rs        # /proc/diskstats + statfs
│   │   ├── gpu.rs         # /sys/class/drm/.../gpu_busy_percent
│   │   ├── temp.rs        # /sys/class/hwmon
│   │   ├── power.rs       # /sys/class/power_supply/BAT0
│   │   ├── audio.rs       # wpctl / WirePlumber DBus
│   │   ├── media.rs       # playerctl MPRIS DBus
│   │   ├── workspaces.rs  # mmsg IPC
│   │   ├── geoip.rs       # maxminddb lookup for the globe
│   │   └── time.rs        # clock_gettime
│   ├── widgets/
│   │   ├── mod.rs
│   │   ├── topbar.rs
│   │   ├── siderails.rs
│   │   ├── bottom_status.rs
│   │   ├── mission_control.rs
│   │   ├── launcher.rs
│   │   ├── notifications.rs
│   │   ├── globe.rs       # wireframe sphere + traffic arcs
│   │   └── graphs.rs      # reusable scrolling graph, bar, gauge
│   ├── sound/
│   │   ├── mod.rs
│   │   ├── cues.rs        # cue enum + trigger logic
│   │   └── player.rs      # rodio playback
│   └── ipc/
│       ├── mod.rs
│       └── mangoctl.rs    # parse mmsg output
└── assets/
    ├── fonts/
    │   ├── DepartureMono-Regular.otf
    │   └── CommitMono-Regular.otf
    ├── sounds/            # generated WAVs, gitignored
    └── geoip/             # GeoLite2 DB, gitignored
```

## Render loop

- Target 30fps when visible, 0fps when hidden
  (Wayland frame callbacks gate this automatically)
- Per frame:
  1. Receive frame callback from Wayland
  2. Snapshot all widget states (cheap RwLock reads)
  3. Determine dirty regions
  4. Re-render dirty regions to a tiny-skia pixmap
  5. Commit to Wayland buffer
  6. Wait for next frame callback

Dirty region tracking matters because the top bar is small but mission
control is full-screen. We don't redraw mission control if only the clock
ticked.

## Event sources

| Source | Mechanism | Rate |
|---|---|---|
| Wayland | event loop | event-driven |
| Clock | tokio interval | 100ms (for ms display) |
| CPU | file watch on /proc/stat | 500ms (file watch + fallback timer) |
| Mem | file watch on /proc/meminfo | 1s |
| Disk | file watch on /proc/diskstats | 1s |
| Net | file watch on /proc/net/dev | 500ms |
| GPU | file watch on /sys/class/drm/.../gpu_busy_percent | 500ms |
| Temp | file watch on /sys/class/hwmon/.../temp* | 1s |
| Battery | file watch on /sys/class/power_supply/BAT0/* | event + 2s fallback |
| Audio | DBus signal from WirePlumber | event-driven |
| Media | DBus signal from MPRIS | event-driven |
| Network state | DBus signal from NetworkManager | event-driven |
| Workspaces | mmsg IPC | event-driven (TBD — depends on Mango's IPC) |
| Notifications | DBus (org.freedesktop.Notifications) | event-driven |

## State management

`Arc<AppState>` where `AppState` is:

```rust
struct AppState {
    cpu: RwLock<CpuSnapshot>,
    mem: RwLock<MemSnapshot>,
    net: RwLock<NetSnapshot>,
    // ... one per data source
    config: Config,  // read-only after startup
    theme: Theme,    // read-only after startup
    dnd: AtomicBool,
}
```

Each snapshot is small (< 64 bytes typically). RwLock because reads >>>
writes. The render loop never holds a lock for more than a single snapshot
copy.

## IPC

- **Input:** DBus (notifications, audio, media, network)
- **Output:** mmsg IPC (workspace switches, mango reload)
- No HTTP, no custom sockets, no custom IPC protocol

## Lifecycle

- **Startup:** connect to Wayland → register layer-shell surfaces → spawn
  data source tasks → load fonts and sounds → enter event loop
- **Shutdown:** SIGINT/SIGTERM → close surfaces cleanly → exit 0
- **Crash:** panic = process exits. Mango keeps running. User restarts via
  a Mango keybind (`Super+Shift+d` or similar).

## Performance budget

| Component | CPU budget |
|---|---|
| Render loop | 0.5% (3ms/frame × 30fps) |
| Data sources total | 0.2% |
| Wayland IPC | 0.1% |
| Sound (when active) | 0.1% per cue |
| **Total idle** | **< 1%** |
| **Total active** | **< 2%** |

## Error handling

- `anyhow::Result` at boundaries (main, ipc, sound)
- `thiserror` for typed errors in `data/` and `render/` modules
- Panics only for invariant violations (Wayland connection lost = fatal)
- Data source errors: log via `tracing`, continue with last-known good
  value, never crash the UI
- A data source that errors 3 times in a row marks itself as "stale" and
  the widget shows `---` instead of stale data

## Threading model

- Main thread: Wayland event loop + render
- Tokio workers (2): DBus, file watches, timers
- Sound: spawn-on-demand `tokio::task::spawn_blocking` for rodio playback
- No shared mutable state across threads except `Arc<AppState>`

## Build pipeline

- `cargo build --release` produces the binary
- `build.rs` generates WAV files for sound cues (sine/square/saw/triangle
  oscillators + ADSR envelope)
- Nix flake wraps this: `nix build .#dodona` produces a derivation with
  just the binary + vendored fonts
- GeoIP DB is fetched separately by a Nix module (needs MaxMind license
  key in a secrets file)

## What this is not

- Not a library. Dodona is a binary. Internal modules aren't reusable.
- Not cross-platform. Linux + Wayland + Mango only.
- Not networked. No HTTP server, no remote control, no telemetry.
