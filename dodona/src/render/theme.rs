//! Theme: palette + font loading.

use std::sync::LazyLock;
use tiny_skia::Color;

pub static BG: LazyLock<Color> =
    LazyLock::new(|| Color::from_rgba8(0x22, 0x22, 0x22, 0xFF));
pub static ACCENT: LazyLock<Color> =
    LazyLock::new(|| Color::from_rgba8(0xFF, 0xA1, 0x33, 0xFF));
pub static ALARM: LazyLock<Color> =
    LazyLock::new(|| Color::from_rgba8(0xFF, 0x2E, 0x66, 0xFF));

pub static BG_PANEL: LazyLock<Color> =
    LazyLock::new(|| Color::from_rgba8(0x26, 0x26, 0x26, 0xFF));
pub static BG_ELEVATED: LazyLock<Color> =
    LazyLock::new(|| Color::from_rgba8(0x2C, 0x2C, 0x2C, 0xFF));
pub static BG_GLOW: LazyLock<Color> =
    LazyLock::new(|| Color::from_rgba8(0x1A, 0x1A, 0x1A, 0xFF));

pub static ACCENT_FULL: LazyLock<Color> =
    LazyLock::new(|| Color::from_rgba8(0xFF, 0xA1, 0x33, 0xFF));
pub static ACCENT_HI: LazyLock<Color> =
    LazyLock::new(|| Color::from_rgba8(0xFF, 0xB8, 0x66, 0xFF));
pub static ACCENT_MID: LazyLock<Color> =
    LazyLock::new(|| Color::from_rgba8(0xCC, 0x81, 0x28, 0xFF));
pub static ACCENT_DIM: LazyLock<Color> =
    LazyLock::new(|| Color::from_rgba8(0x99, 0x5F, 0x1C, 0xFF));
pub static ACCENT_FAINT: LazyLock<Color> =
    LazyLock::new(|| Color::from_rgba8(0x66, 0x3D, 0x11, 0xFF));
pub static ACCENT_GHOST: LazyLock<Color> =
    LazyLock::new(|| Color::from_rgba8(0x33, 0x19, 0x08, 0xFF));

pub static CRITICAL: LazyLock<Color> =
    LazyLock::new(|| Color::from_rgba8(0xFF, 0x5A, 0x3C, 0xFF));
pub static WARNING: LazyLock<Color> =
    LazyLock::new(|| Color::from_rgba8(0xE8, 0x55, 0x5A, 0xFF));

pub static DEPARTURE_MONO: &[u8] =
    include_bytes!(concat!(env!("OUT_DIR"), "/DepartureMono-Regular.otf"));
pub static COMMIT_MONO: &[u8] =
    include_bytes!(concat!(env!("OUT_DIR"), "/CommitMono-Regular.otf"));

pub fn validate_font(data: &[u8], name: &str) -> anyhow::Result<()> {
    if data.len() < 4 {
        anyhow::bail!("font {name} too small ({} bytes)", data.len());
    }
    let magic = &data[0..4];
    if magic == b"OTTO" || magic == b"\x00\x01\x00\x00" || magic == b"true" || magic == b"OTCF" {
        Ok(())
    } else {
        anyhow::bail!(
            "font {name} has invalid magic bytes: {:02X?} (expected OTTO/0001/true/OTCF)",
            magic
        )
    }
}

pub struct Theme {
    pub bg: Color,
    pub accent: Color,
    pub alarm: Color,
    pub bg_panel: Color,
    pub bg_elevated: Color,
    pub bg_glow: Color,
    pub accent_full: Color,
    pub accent_hi: Color,
    pub accent_mid: Color,
    pub accent_dim: Color,
    pub accent_faint: Color,
    pub accent_ghost: Color,
    pub critical: Color,
    pub warning: Color,
    pub departure_mono: &'static [u8],
    pub commit_mono: &'static [u8],
}

impl Theme {
    pub fn load() -> anyhow::Result<Self> {
        validate_font(DEPARTURE_MONO, "DepartureMono-Regular")?;
        validate_font(COMMIT_MONO, "CommitMono-Regular")?;

        Ok(Self {
            bg: *BG,
            accent: *ACCENT,
            alarm: *ALARM,
            bg_panel: *BG_PANEL,
            bg_elevated: *BG_ELEVATED,
            bg_glow: *BG_GLOW,
            accent_full: *ACCENT_FULL,
            accent_hi: *ACCENT_HI,
            accent_mid: *ACCENT_MID,
            accent_dim: *ACCENT_DIM,
            accent_faint: *ACCENT_FAINT,
            accent_ghost: *ACCENT_GHOST,
            critical: *CRITICAL,
            warning: *WARNING,
            departure_mono: DEPARTURE_MONO,
            commit_mono: COMMIT_MONO,
        })
    }
}
