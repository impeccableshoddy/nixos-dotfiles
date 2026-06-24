//! Event loop: merges Wayland events with tokio async tasks.
//!
//! The main thread owns the Wayland event loop (via smithay-client-toolkit's
//! calloop integration). Tokio runs on worker threads. The two communicate
//! via `crossbeam-channel` (lower latency than tokio mpsc for UI events).
//!
//! Per frame:
//!   1. Drain crossbeam channel (data updates from worker threads)
//!   2. Process Wayland events (input, frame callbacks, surface configure)
//!   3. If any frame callback fired: run render loop
//!   4. Block on Wayland event queue until next event
//!
//! ## TODO (future commit: `dodona(core): wire tokio + wayland event merging`)
//! - Implement `EventLoop` struct owning the calloop loop + crossbeam receiver
//! - Implement `run()` with the per-frame sequence above
//! - Wire SIGINT/SIGTERM via `tokio::signal` to cleanly break the loop
