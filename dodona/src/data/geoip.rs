//! GeoIP lookup — maxminddb reader for the wireframe globe.
//!
//! Loads the MaxMind GeoLite2 Country database at startup. On each new
//! network connection (or periodically), looks up the destination IP's
//! country and plots it on the mission control globe as a wireframe arc
//! from the user's location.
//!
//! ## Database
//!
//! - File: `assets/geoip/GeoLite2-Country.mmdb`
//! - Source: MaxMind GeoLite2 (free, requires account — see docs/DEPENDENCIES.md
//!   §GeoIP database)
//! - Fetched separately by a Nix module; not committed to repo
//!
//! ## Fallback
//!
//! If the DB file is missing or a lookup fails, the globe shows abstract
//! topology (no geo, just traffic volume as line thickness from center).
//! The build does not fail if the DB is missing.
//!
//! ## TODO (future commit: `dodona(data): implement geoip lookup with maxminddb`)
//! - Implement `GeoipLookup` struct holding the loaded `maxminddb::Reader`
//! - Implement `lookup(ip: IpAddr) -> Option<Country>` returning ISO country code
//! - Implement graceful fallback when DB file is missing (log WARN, return None)
//! - Coordinate with `widgets::globe` for arc rendering
