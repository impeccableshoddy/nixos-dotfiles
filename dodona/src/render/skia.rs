use tiny_skia::{Color, FillRule, Paint, PathBuilder, Pixmap, Shader, Stroke, Transform};

pub struct SkiaSurface {
    pixmap: Pixmap,
}

impl SkiaSurface {
    pub fn new(width: u32, height: u32) -> Option<Self> {
        Pixmap::new(width, height).map(|pixmap| Self { pixmap })
    }

    pub fn resize(&mut self, width: u32, height: u32) {
        if width != self.pixmap.width() || height != self.pixmap.height() {
            self.pixmap = Pixmap::new(width, height).unwrap_or_else(|| {
                panic!("failed to allocate {}x{} pixmap", width, height)
            });
        }
    }

    pub fn pixmap(&self) -> &Pixmap { &self.pixmap }
    pub fn pixmap_mut(&mut self) -> &mut Pixmap { &mut self.pixmap }
    pub fn width(&self) -> u32 { self.pixmap.width() }
    pub fn height(&self) -> u32 { self.pixmap.height() }

    pub fn clear(&mut self, color: Color) { self.pixmap.fill(color); }

    pub fn hline(&mut self, x1: f32, x2: f32, y: f32, color: Color, width: f32) {
        if x2 <= x1 { return; }
        let mut pb = PathBuilder::new();
        pb.move_to(x1, y);
        pb.line_to(x2, y);
        let path = pb.finish().unwrap();
        let paint = Paint { shader: Shader::SolidColor(color), ..Default::default() };
        let stroke = Stroke { width, ..Default::default() };
        self.pixmap.stroke_path(&path, &paint, &stroke, Transform::identity(), None);
    }

    pub fn vline(&mut self, x: f32, y1: f32, y2: f32, color: Color, width: f32) {
        if y2 <= y1 { return; }
        let mut pb = PathBuilder::new();
        pb.move_to(x, y1);
        pb.line_to(x, y2);
        let path = pb.finish().unwrap();
        let paint = Paint { shader: Shader::SolidColor(color), ..Default::default() };
        let stroke = Stroke { width, ..Default::default() };
        self.pixmap.stroke_path(&path, &paint, &stroke, Transform::identity(), None);
    }

    pub fn fill_rect(&mut self, x: f32, y: f32, w: f32, h: f32, color: Color) {
        if w <= 0.0 || h <= 0.0 { return; }
        let mut pb = PathBuilder::new();
        pb.move_to(x, y);
        pb.line_to(x + w, y);
        pb.line_to(x + w, y + h);
        pb.line_to(x, y + h);
        pb.close();
        let path = pb.finish().unwrap();
        let paint = Paint { shader: Shader::SolidColor(color), ..Default::default() };
        self.pixmap.fill_path(&path, &paint, FillRule::EvenOdd, Transform::identity(), None);
    }

    pub fn stroke_rect(&mut self, x: f32, y: f32, w: f32, h: f32, color: Color, line_width: f32) {
        if w <= 0.0 || h <= 0.0 { return; }
        let mut pb = PathBuilder::new();
        pb.move_to(x, y);
        pb.line_to(x + w, y);
        pb.line_to(x + w, y + h);
        pb.line_to(x, y + h);
        pb.close();
        let path = pb.finish().unwrap();
        let paint = Paint { shader: Shader::SolidColor(color), ..Default::default() };
        let stroke = Stroke { width: line_width, ..Default::default() };
        self.pixmap.stroke_path(&path, &paint, &stroke, Transform::identity(), None);
    }

    pub fn commit_to_shm(&self, canvas: &mut [u8]) {
        let src = self.pixmap.data();
        for (dst, src_px) in canvas.chunks_exact_mut(4).zip(src.chunks_exact(4)) {
            dst[0] = src_px[2]; // B
            dst[1] = src_px[1]; // G
            dst[2] = src_px[0]; // R
            dst[3] = src_px[3]; // A
        }
    }
}
