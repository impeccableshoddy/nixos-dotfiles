//! GPU usage — reads /sys/class/drm/.../gpu_busy_percent.
//!
//! AMD GPUs expose `gpu_busy_percent` under `/sys/class/drm/card*/device/`.
//! This is the AMDGPU-specific interface. For Intel/Nvidia we'd need
//! different paths or vendor tools — out of scope for now (see docs/SCOPE.md
//! §Target hardware).
//!
//! ## Source
//!
//! `/sys/class/drm/card0/device/gpu_busy_percent` — integer 0-100.
//!
//! ## Rate
//!
//! 500ms via file watch + fallback timer.
//!
//! ## TODO (future commit: `dodona(data): implement gpu source with /sys/class/drm`)
//! - Implement `GpuSnapshot { busy_pct: u8, history: RingBuffer<u8> }`
//! - Implement `read_gpu_busy_percent() -> Result<u8>` scanning all cardN paths
//! - Spawn async task polling at 500ms
//! - On AMD APU (target hardware), card0 is the APU's integrated GPU

use crate::core::event_loop::UiEvent;
pub fn spawn(_tx: calloop::channel::SyncSender<UiEvent>) {}
