//! Memory usage — reads /proc/meminfo.
//!
//! Parses MemTotal, MemAvailable, SwapTotal, SwapFree. Computes:
//!   - Used RAM % = (MemTotal - MemAvailable) / MemTotal
//!   - Used Swap % = (SwapTotal - SwapFree) / SwapTotal
//!   - 60-second rolling history of RAM usage
//!
//! ## Source
//!
//! `/proc/meminfo` — key:value pairs in KiB.
//!
//! ## Rate
//!
//! 1s via file watch + fallback timer. Memory moves slower than CPU.
//!
//! ## TODO (future commit: `dodona(data): implement mem source with /proc/meminfo parser`)
//! - Implement `MemSnapshot { ram_used_pct: f32, swap_used_pct: f32, history: RingBuffer<f32> }`
//! - Implement `parse_proc_meminfo(content: &str) -> ParsedMem`
//! - Spawn async task polling at 1s, writing into `AppState::mem`
