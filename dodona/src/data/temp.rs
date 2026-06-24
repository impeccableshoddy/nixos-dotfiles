//! Temperature sensors — reads /sys/class/hwmon.
//!
//! Walks /sys/class/hwmon/ discovering all temperature sensors. Each
//! hwmon device has a `tempN_input` file (millidegrees Celsius) and
//! optional `tempN_label` (human-readable name).
//!
//! We expose all sensors and let the widget pick which to display.
//! Typical sensors on the target hardware (AMD APU laptop):
//!   - Tctl (CPU die)
//!   - Tdie (CPU die, alternative)
//!   - edgedge (GPU edge)
//!   - junction (GPU junction)
//!   - mem (DIMM)
//!   - nvme (SSD)
//!
//! ## Source
//!
//! `/sys/class/hwmon/hwmonN/tempM_input` and `tempM_label`.
//!
//! ## Rate
//!
//! 1s via file watch + fallback timer. Temperature moves slowly.
//!
//! ## TODO (future commit: `dodona(data): implement temp source with /sys/class/hwmon`)
//! - Implement `TempSnapshot { sensors: Vec<TempReading> }`
//! - Implement `TempReading { label: String, temp_c: f32 }`
//! - Implement `discover_hwmon() -> Vec<HwmonDevice>` walking /sys/class/hwmon
//! - Spawn async task polling at 1s
//! - Per docs/PALETTE.md §State colors: WARN at 75°C, CRIT at 90°C
