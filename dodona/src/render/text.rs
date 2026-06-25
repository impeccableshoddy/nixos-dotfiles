use cosmic_text::{Attrs, Buffer, Color as CosmicColor, FontSystem, Metrics, Shaping, SwashCache};
use tiny_skia::{Color, Pixmap};

pub struct TextRenderer {
    font_system: FontSystem,
    swash_cache: SwashCache,
}

impl TextRenderer {
    pub fn new(departure_mono: &[u8], commit_mono: &[u8]) -> Self {
        let mut font_system = FontSystem::new();
        font_system.db_mut().load_font_data(departure_mono.to_vec());
        font_system.db_mut().load_font_data(commit_mono.to_vec());
        let swash_cache = SwashCache::new();
        Self { font_system, swash_cache }
    }

    pub fn draw_text(
        &mut self,
        pixmap: &mut Pixmap,
        text: &str,
        x: f32,
        y: f32,
        font_size: f32,
        color: Color,
    ) -> f32 {
        let attrs = Attrs::new();
        let metrics = Metrics::new(font_size, font_size * 1.2);
        let mut buffer = Buffer::new(&mut self.font_system, metrics);
        buffer.set_size(&mut self.font_system, Some(f32::MAX), Some(font_size * 1.4));
        buffer.set_text(&mut self.font_system, text, attrs, Shaping::Advanced);
        buffer.shape_until_scroll(&mut self.font_system, false);

        let text_width = buffer
            .layout_runs()
            .map(|run| run.line_w)
            .max_by(|a, b| a.partial_cmp(b).unwrap_or(std::cmp::Ordering::Equal))
            .unwrap_or(0.0);

        let cosmic_color = tiny_to_cosmic_color(color);
        let pm_width = pixmap.width() as i32;
        let pm_height = pixmap.height() as i32;

        {
            let pm_data = pixmap.data_mut();

            buffer.draw(
                &mut self.font_system,
                &mut self.swash_cache,
                cosmic_color,
                |span_x, span_y, span_w, span_h, span_color| {
                    let a = span_color.a();
                    if a == 0 { return; }
                    let r = span_color.r();
                    let g = span_color.g();
                    let b = span_color.b();

                    for dy in 0..span_h {
                        for dx in 0..span_w {
                            let target_x = x as i32 + span_x + dx as i32;
                            let target_y = y as i32 + span_y + dy as i32;
                            if target_x < 0 || target_y < 0 || target_x >= pm_width || target_y >= pm_height {
                                continue;
                            }
                            let offset = ((target_y * pm_width + target_x) * 4) as usize;
                            if offset + 3 >= pm_data.len() { continue; }

                            if a == 255 {
                                pm_data[offset] = r;
                                pm_data[offset + 1] = g;
                                pm_data[offset + 2] = b;
                                pm_data[offset + 3] = 0xFF;
                            } else {
                                let af = a as f32 / 255.0;
                                let inv = 1.0 - af;
                                pm_data[offset] = (r as f32 * af + pm_data[offset] as f32 * inv) as u8;
                                pm_data[offset + 1] = (g as f32 * af + pm_data[offset + 1] as f32 * inv) as u8;
                                pm_data[offset + 2] = (b as f32 * af + pm_data[offset + 2] as f32 * inv) as u8;
                                pm_data[offset + 3] = 0xFF;
                            }
                        }
                    }
                },
            );
        }

        text_width
    }
}

fn tiny_to_cosmic_color(c: Color) -> CosmicColor {
    CosmicColor::rgba(
        (c.red() * 255.0) as u8,
        (c.green() * 255.0) as u8,
        (c.blue() * 255.0) as u8,
        (c.alpha() * 255.0) as u8,
    )
}
