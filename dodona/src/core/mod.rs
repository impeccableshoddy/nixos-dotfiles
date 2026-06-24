//! Core: Wayland connection, event loop, surface lifecycle.
//!
//! This module owns the main thread. The Wayland event loop and the
//! render pipeline both run here. Worker threads (tokio) feed data
//! into the shared `AppState` that the render loop reads.
//!
//! See docs/ARCHITECTURE.md §Process model and §Module structure.

pub mod event_loop;
pub mod surface;
pub mod wayland;
