//! CPU usage — reads /proc/stat.
//!
//! Parses the `cpu` aggregate line and per-core lines. Computes:
//!   - Aggregate usage % (idle vs non-idle ticks)
//!   - Per-core usage % (for side rail gauges)
//!   - 60-second rolling history (for mission control graphs)
//!
//! ## Source
//!
//! `/proc/stat` (lines starting with `cpu`). Format:
//!   `cpu  user nice system idle iowait irq softirq steal guest guest_nice`
//!
//! All values are in USER_HZ (typically 100Hz on x86_64).
//!
//! ## Rate
//!
//! 500ms via file watch on /proc/stat + fallback timer. File watch is
//! primary; timer catches cases where /proc/stat is updated without
//! triggering inotify (rare, but the kernel doesn't guarantee it).
//!
//! ## TODO (future commit: `dodona(data): implement cpu source with /proc/stat parser`)
//! - Implement `CpuSnapshot { aggregate: f32, per_core: Vec<f32>, history: RingBuffer<f32> }`
//! - Implement `parse_proc_stat(content: &str) -> ParsedStat`
//! - Implement `sample(prev: ParsedStat, curr: ParsedStat) -> CpuSnapshot` (delta-based)
//! - Spawn async task polling at 500ms, writing into `AppState::cpu`
