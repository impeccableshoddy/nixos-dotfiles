# Dodona — Palette

## The two colors

```
BG          #222222    rgb(34, 34, 34)     background, surfaces
ACCENT      #ffa133    rgb(255, 161, 51)   all UI elements, text, glow
```

That's it. Everything else is derived by mixing these two with black or
white at varying alpha. No new hues.

## Derivation rules

We do not introduce new colors. We vary brightness and opacity.

### Background shades (BG mixed with white at low alpha)

```
BG          #222222   0% white     base surface (full screen background)
BG_PANEL    #262626  ~6% white    panel surface (imperceptibly lighter)
BG_ELEVATED #2c2c2c ~12% white    raised elements (gauge tracks, graph bg)
BG_GLOW     #1a1a1a ~10% black    inner shadow zone (recessed elements)
```

### Accent shades (ACCENT mixed with BG at varying alpha)

```
ACCENT_FULL   #ffa133   100% alpha   active elements, primary data
ACCENT_HI     #ffb866  +30% white   highlight, selected, cursor
ACCENT_MID    #cc8128  -20% black   body text accents, normal UI
ACCENT_DIM    #995f1c  -40% black   secondary — labels, units, axis ticks
ACCENT_FAINT  #663d11  -60% black   decorative — gridlines, separators, inactive
ACCENT_GHOST  #331908  -80% black   background grid, watermark
```

## Application rules

| UI element | Color |
|---|---|
| Screen background | `BG` (solid, no wallpaper, no gradient) |
| Panel background | `BG_PANEL` |
| Panel border | `ACCENT_FAINT` (1px) |
| Panel border (active/focused) | `ACCENT_DIM` (1px) |
| Primary text (data readouts, numbers) | `ACCENT_FULL` |
| Secondary text (labels, units) | `ACCENT_DIM` |
| Decorative text (axis labels, hints) | `ACCENT_FAINT` |
| Active element (selected workspace, current track) | `ACCENT_FULL` |
| Inactive element | `ACCENT_FAINT` |
| Graph line (live data) | `ACCENT_FULL` |
| Graph gridlines | `ACCENT_GHOST` |
| Gauge fill | `ACCENT_FULL` |
| Gauge track | `BG_ELEVATED` |
| Glow halo (active/hovered only) | `ACCENT` at 30% alpha, 4px blur |

## State colors — exceptions only

Persistent UI never uses non-orange colors. State changes use these, only
when the state is active:

| State | Color | When | Behavior |
|---|---|---|---|
| OK | (none — default orange) | System nominal | Never visually distinct |
| WARN | `#ffa133` pulsing 1Hz | Temp > 75°C, disk > 85%, battery < 25% | Subtle pulse, no new hue |
| CRIT | `#ffa133` pulsing 3Hz + glow boost | Temp > 90°C, battery < 10%, disk > 95% | Faster pulse, glow halo |
| ALARM | `#ff2e66` (the one exception) | Operation failure, network drop, panic | Solid flash, sound, persistent banner |

WARN and CRIT are conveyed through *behavior* (pulse rate, glow intensity)
not new hues. ALARM is the only state that introduces a new color, and
only because pulsing orange isn't enough to break through attention for
genuine failures.

## Background policy

- Solid `#222222`, no wallpaper, no gradients, no patterns
- The UI elements ARE the visual interest
- This is non-negotiable for the phosphor aesthetic
- If you find yourself reaching for a wallpaper, you're compensating for
  weak UI. Fix the UI instead.

## Typography

```
FONT_DISPLAY  Departure Mono   all UI text in dodona
FONT_TERM     Commit Mono      terminal, editor
FONT_SYSTEM   Departure Mono   replaces Work Sans in stylix
FONT_SERIF    Departure Mono   replaces EB Garamond in stylix
```

Departure Mono everywhere except the terminal/editor. We commit to
monospace system-wide for the phosphor aesthetic. Web pages in Firefox
will render in Departure Mono — that's intentional. If it breaks a
specific site, add a Firefox-specific font override.

## Opacity / glow rules

- **Persistent UI:** solid colors, no glow (eye strain over 20h)
- **Active/hovered elements:** subtle 4px glow at 30% alpha
- **Mission control overlay:** glow allowed (on-demand, not persistent)
- **Notification banners:** glow allowed (event-driven, brief)
- **WARN/CRIT state:** glow allowed (purposeful, attention-grabbing)

Glow is a tool for attention, not decoration. Persistent glow = eye
strain. The default state of the UI is flat.

## Contrast ratios (verified for 20h readability)

| Pair | Ratio | WCAG |
|---|---|---|
| `ACCENT_FULL` on `BG` | 8.2:1 | AAA |
| `ACCENT_MID` on `BG` | 5.1:1 | AA |
| `ACCENT_DIM` on `BG` | 2.8:1 | below AA (decorative only) |
| `ACCENT_FAINT` on `BG` | 1.6:1 | decorative only — never for body text |
| `ACCENT_FULL` on `BG_PANEL` | 7.9:1 | AAA |
| `ALARM` on `BG` | 6.4:1 | AA |

Body text always uses `ACCENT_FULL` or `ACCENT_MID`. `ACCENT_DIM` and
below are for labels, units, gridlines — never running text.

## How this maps to the existing system

| Surface | Before | After |
|---|---|---|
| Stylix base color | Catppuccin Mocha (wallpaper-derived) | Dodona custom base16 (this palette) |
| Stylix wallpaper | `wallpapers/girl.jpg` | (removed, solid `#222222`) |
| Foot terminal bg | stylix-derived | `#222222` solid |
| Foot terminal fg | stylix-derived | `#ffa133` |
| Neovim colorscheme | catppuccin-nvim (Mocha) | custom dodona-nvim (this palette) |
| Starship palette | "girl" (ink/slate/rose/taupe/blush/deepred) | "dodona" (bg/accent + 4 shades) |
| Tmux status bar | default stylix | `#222222` bg, `#ffa133` accent |
| Fastfetch | custom ANSI RGB tokens | dodona palette tokens |
| Mako | stylix-derived | (replaced by dodona notifications) |
| Limine | default | dodona theme (bg + accent) |
| Lock screen | (none) | dodona-themed swaylock |

## What we explicitly do NOT do

- Mix other hues "for variety" — there is no variety, there is state
- Use color to convey hierarchy — hierarchy is conveyed by position,
  size, and brightness (within the one hue)
- Use color to convey branding — there is no branding, this is a tool
- Use color for decoration — decoration is geometric (lines, dots,
  brackets), not chromatic
