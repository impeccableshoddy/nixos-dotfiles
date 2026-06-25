//! Dodona - entry point.
//!
//! Phosphor-CRT control surface for NixOS + Mango WM.
//! Full-screen Background layer surface that acts as the desktop hub.

use tracing_subscriber::EnvFilter;

mod core;
mod data;
mod ipc;
mod render;
mod sound;
mod widgets;

fn main() -> anyhow::Result<()> {
    tracing_subscriber::fmt()
        .with_env_filter(EnvFilter::from_default_env())
        .init();

    tracing::info!(
        "dodona v{} - phosphor control surface",
        env!("CARGO_PKG_VERSION")
    );

    let (app, conn, event_queue) = core::wayland::connect()?;
    core::event_loop::run(app, conn, event_queue)?;

    Ok(())
}
