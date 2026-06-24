//! Power / battery — reads /sys/class/power_supply/BAT0.
//!
//! Reads:
//!   - capacity (0-100, percent)
//!   - status (Charging / Discharging / Full / Not charging)
//!   - current (microamps, positive = discharging on most laptops)
//!   - voltage (microvolts)
//!
//! Computes:
//!   - Battery % (from capacity)
//!   - Charging state (from status)
//!   - Estimated time remaining (from current + remaining capacity)
//!     - Only when discharging — when charging, show "—"
//!     - Rough estimate: remaining_Wh / current_W = hours
//!
//! ## Source
//!
//! `/sys/class/power_supply/BAT0/{capacity,status,current_now,voltage_now}`
//!
//! ## Rate
//!
//! Event-driven via `notify` file watch on the BAT0 directory, with a
//! 2s fallback timer. Power_supply sysfs emits uevents on capacity change
//! but not always on time-to-empty updates.
//!
//! ## TODO (future commit: `dodona(data): implement power source with /sys/class/power_supply`)
//! - Implement `PowerSnapshot { capacity_pct: u8, status: ChargeStatus, time_remaining_min: Option<u32> }`
//! - Implement `parse_power_supply(dir: &Path) -> PowerSnapshot`
//! - Spawn async task with notify file watch on BAT0/ + 2s timer
//! - Per docs/PALETTE.md §State colors: WARN at <25%, CRIT at <10%
