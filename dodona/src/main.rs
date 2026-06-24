//! Dodona — entry point.
//!
//! Parses args, sets up logging, connects to Wayland, and enters the
//! main event loop. See docs/ARCHITECTURE.md §Process model.

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
        "dodona v{} — phosphor control surface",
        env!("CARGO_PKG_VERSION")
    );
    tracing::info!(
        "see docs/SCOPE.md for what this is, docs/ARCHITECTURE.md for how it works"
    );

    // Connect to Wayland and create the topbar layer surface.
    // (Future commits add the side rails, bottom status, mission control,
    // launcher, and notification surfaces.)
    let (app, conn, event_queue) = core::wayland::connect()?;

    // Run the event loop. Blocks until ESC, SIGINT, SIGTERM, or compositor
    // close. Returns cleanly on exit.
    //
    // TODO (future commit: `dodona(core): wire tokio + wayland event merging`):
    //   - Build a tokio runtime (2 worker threads) SEPARATELY from the
    //     calloop main loop (calloop stays on the main thread per
    //     docs/ARCHITECTURE.md §Threading model)
    //   - Spawn data source tasks on tokio (cpu, mem, net, etc.)
    //   - Crossbeam-channel from tokio tasks → calloop source for
    //     UI event delivery
    core::event_loop::run(app, conn, event_queue)?;

    Ok(())
}
