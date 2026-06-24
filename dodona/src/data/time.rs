//! Clock — high-frequency time updates for the ms display.
//!
//! The topbar shows time with millisecond precision (per docs/SCOPE.md
//! §In scope → "clock with ms"). This requires a 100ms tick to keep
//! the display feeling live without burning CPU.
//!
//! We expose:
//!   - Current time (HH:MM:SS.mmm)
//!   - Date (for the topbar's secondary line)
//!   - Unix timestamp (for any widget that needs it)
//!
//! ## Rate
//!
//! 100ms via tokio interval. This is the highest-frequency data source.
//! Cheap — just a `clock_gettime` syscall.
//!
//! ## TODO (future commit: `dodona(data): implement time source with clock_gettime`)
//! - Implement `TimeSnapshot { time: String, date: String, unix_ms: u128 }`
//! - Use `nix::time::clock_gettime(ClockId::CLOCK_REALTIME)` for nanosecond precision
//! - Format using a fixed-format string (no chrono — we just need HH:MM:SS.mmm)
//! - Spawn async task with `tokio::time::interval(Duration::from_millis(100))`
