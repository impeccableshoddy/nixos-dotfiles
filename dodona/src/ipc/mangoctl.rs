//! mangoctl — parse mmsg output and send commands to Mango.
//!
//! Mango WM's IPC binary is `mmsg`. We use it for:
//!   - Reading workspace state (consumed by `data::workspaces`)
//!   - Switching workspaces (outbound: `mmsg workspace N`)
//!   - Reloading Mango config (outbound: `mmsg reload`)
//!
//! ## TODO (future commit: `dodona(ipc): implement mangoctl mmsg wrapper`)
//! - Investigate mmsg's exact CLI and IPC protocol
//!   (likely a Unix socket; mmsg is the client binary)
//! - Define `WorkspaceState { current: usize, occupied: Vec<bool> }`
//! - Implement `read_state() -> WorkspaceState` parsing mmsg output
//! - Implement `switch_workspace(n: usize)` calling mmsg
//! - Implement `reload_mango()` calling mmsg
//! - Spawn async task polling mmsg at 500ms (or event-driven if mmsg supports it)
//! - Cache the last-read state; only re-parse if mmsg output changed
//!   (cheap hash check before parse)
