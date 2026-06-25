use crate::render::skia::SkiaSurface;
use tiny_skia::Color;

pub fn hline(surf: &mut SkiaSurface, x1: f32, x2: f32, y: f32, color: Color, width: f32) {
    surf.hline(x1, x2, y, color, width);
}

pub fn vline(surf: &mut SkiaSurface, x: f32, y1: f32, y2: f32, color: Color, width: f32) {
    surf.vline(x, y1, y2, color, width);
}

pub fn fill_rect(surf: &mut SkiaSurface, x: f32, y: f32, w: f32, h: f32, color: Color) {
    surf.fill_rect(x, y, w, h, color);
}

pub fn stroke_rect(surf: &mut SkiaSurface, x: f32, y: f32, w: f32, h: f32, color: Color, line_width: f32) {
    surf.stroke_rect(x, y, w, h, color, line_width);
}
