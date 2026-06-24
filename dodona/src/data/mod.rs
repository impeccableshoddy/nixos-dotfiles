//! Data: system data sources.
//!
//! Each source runs as an async task, polling /proc, /sys, or DBus
//! at its own cadence, writing into a shared `AppState` cell.
//!
//! | Source    | Mechanism                          | Rate            |
//! |-----------|------------------------------------|-----------------|
//! | cpu       | /proc/stat file watch              | 500ms + watch   |
//! | mem       | /proc/meminfo file watch           | 1s              |
//! | net       | /proc/net/dev + NetworkManager DBus| 500ms + signal  |
//! | disk      | /proc/diskstats + statfs           | 1s              |
//! | gpu       | /sys/class/drm/.../gpu_busy_percent| 500ms           |
//! | temp      | /sys/class/hwmon/.../temp*         | 1s              |
//! | power     | /sys/class/power_supply/BAT0/*     | event + 2s      |
//! | audio     | WirePlumber DBus                   | event-driven    |
//! | media     | MPRIS DBus                         | event-driven    |
//! | workspaces| mmsg IPC                           | event-driven    |
//! | geoip     | maxminddb lookup                   | on-demand       |
//! | time      | clock_gettime                      | 100ms           |
//!
//! See docs/ARCHITECTURE.md §Event sources.

pub mod cpu;
pub mod disk;
pub mod geoip;
pub mod gpu;
pub mod media;
pub mod mem;
pub mod net;
pub mod power;
pub mod temp;
pub mod time;
pub mod workspaces;
pub mod audio;
