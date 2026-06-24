//! Workspace state — mmsg IPC.
//!
//! Mango WM exposes workspace state via `mmsg` (Mango Message). We poll
//! mmsg on demand (workspace switches emit events we can listen for, but
//! the IPC protocol is TBD — see docs/ARCHITECTURE.md §Event sources).
//!
//! We expose:
//!   - Current workspace index
//!   - Workspace occupancy (windows per workspace)
//!   - Active window title (for the topbar)
//!
//! ## Rate
//!
//! Event-driven via mmsg IPC. Fallback: 500ms polling if event subscription
//! isn't available.
//!
//! ## TODO (future commit: `dodona(data): implement workspaces source with mmsg IPC`)
//! - Investigate mmsg's IPC protocol (likely a Unix socket or DBus)
//! - Implement `WorkspacesSnapshot { current: usize, occupied: Vec<bool>, active_title: String }`
//! - Spawn async task with mmsg event listener (or 500ms poll fallback)
//! - Coordinate with `ipc::mangoctl` for outbound commands (workspace switch)
