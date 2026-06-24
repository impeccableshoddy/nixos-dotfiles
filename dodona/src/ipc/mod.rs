//! IPC: inter-process communication with external tools.
//!
//! Dodona talks to:
//!   - DBus (inbound: notifications, audio, media, network) — handled in
//!     the `data` module's source tasks, not here
//!   - mmsg (outbound: workspace switch, mango reload)
//!
//! No HTTP, no custom sockets, no custom IPC protocol.
//! See docs/ARCHITECTURE.md §IPC.

pub mod mangoctl;
