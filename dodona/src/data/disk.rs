//! Disk I/O + filesystem usage — /proc/diskstats + statfs.
//!
//! Two metrics per filesystem:
//!   - I/O throughput (reads + writes in B/s) from /proc/diskstats
//!   - Capacity usage (% used) from statfs on each mounted path
//!
//! We monitor the root filesystem by default. Future: list mounts from
//! /proc/mounts and monitor each.
//!
//! ## Sources
//!
//! - `/proc/diskstats` — per-device read/write sector counts
//! - `statvfs(2)` syscall — filesystem capacity
//!
//! ## Rate
//!
//! 1s via file watch on /proc/diskstats + fallback timer. statfs is
//! called on the same interval (no inotify for capacity).
//!
//! ## TODO (future commit: `dodona(data): implement disk source with /proc/diskstats + statfs`)
//! - Implement `DiskSnapshot { io_bps: u64, used_pct: f32, total_bytes: u64 }`
//! - Implement `parse_proc_diskstats(content: &str) -> HashMap<String, DiskCounters>`
//! - Use `nix::sys::statfs::statfs(path)` for capacity
//! - Spawn async task polling at 1s
