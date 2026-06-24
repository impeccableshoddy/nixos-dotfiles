//! Widgets: the UI components that read AppState and draw to the surface.
//!
//! Each widget owns its geometry (computed once on surface resize) and
//! its dirty flag. The render loop walks the widget list each frame,
//! re-rendering only the ones that are dirty.
//!
//! | Widget           | Surface                | Trigger             |
//! |------------------|------------------------|---------------------|
//! | topbar           | top edge              | always visible      |
//! | siderails        | left + right edges    | always visible      |
//! | bottom_status    | bottom edge           | always visible      |
//! | mission_control  | fullscreen overlay    | Super+0 toggle      |
//! | launcher         | centered overlay      | Super+Space toggle  |
//! | notifications    | top-right popups      | event-driven        |
//! | globe            | inside mission_control| mission_control vis |
//! | graphs           | reusable sub-widget   | embedded in others  |
//!
//! See docs/SCOPE.md §In scope and docs/ARCHITECTURE.md §Module structure.

pub mod bottom_status;
pub mod globe;
pub mod graphs;
pub mod launcher;
pub mod mission_control;
pub mod notifications;
pub mod siderails;
pub mod topbar;
