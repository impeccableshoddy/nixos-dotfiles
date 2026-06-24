//! Dodona — entry point.
//!
//! Parses args, sets up the tokio runtime, initializes logging, and
//! enters the main event loop. See docs/ARCHITECTURE.md §Process model.

use tracing_subscriber::EnvFilter;

mod core;
mod data;
mod ipc;
mod render;
mod sound;
mod widgets;

#[tokio::main]
async fn main() -> anyhow::Result<()> {
    tracing_subscriber::fmt()
        .with_env_filter(EnvFilter::from_default_env())
        .init();

    tracing::info!(
        "dodona v{} — phosphor control surface",
        env!("CARGO_PKG_VERSION")
    );
    tracing::info!(
        "see docs/SCOPE.md for what this is, docs/ARCHITECTURE.md for how it works"
    );

    // Scaffold only — the real work comes in subsequent commits:
    //   1. dodona(core): connect to wayland and create layer-shell surfaces
    //   2. dodona(render): wire tiny-skia pixmap commit to wayland buffer
    //   3. dodona(data): implement cpu source with /proc/stat parser
    //   ... and so on per docs/ARCHITECTURE.md
    tracing::warn!("scaffolding only — no wayland connection, no render loop, exiting");

    Ok(())
}
