//! Network status — /proc/net/dev + NetworkManager DBus.
//!
//! Two data sources merged:
//!   1. `/proc/net/dev` — bytes/packets in/out per interface (rate-based)
//!   2. NetworkManager DBus — connection state, SSID, signal strength
//!
//! Computes:
//!   - Throughput in/out (B/s) over the last sample interval
//!   - Active connection type (ethernet / wifi / none)
//!   - SSID + signal strength (for wifi)
//!   - Connection state (connected / connecting / disconnected)
//!
//! ## Rate
//!
//! - /proc/net/dev: 500ms via file watch + fallback timer
//! - NetworkManager: event-driven via DBus signal `PropertiesChanged`
//!
//! ## TODO (future commit: `dodona(data): implement net source with /proc/net/dev + NetworkManager DBus`)
//! - Implement `NetSnapshot { rx_bps: u64, tx_bps: u64, state: NetState, ssid: Option<String>, signal: u8 }`
//! - Implement `parse_proc_net_dev(content: &str) -> HashMap<String, DevCounters>`
//! - Implement DBus proxy for `org.freedesktop.NetworkManager`
//! - Spawn async task polling /proc/net/dev at 500ms + DBus signal listener
