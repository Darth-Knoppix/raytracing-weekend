const std = @import("std");

pub const Color = struct {
    value: @Vector(3, f64),

    pub fn init(r: f64, g: f64, b: f64) Color {
        const clamped_r = std.math.clamp(r, 0.0, 1.0);
        const clamped_g = std.math.clamp(g, 0.0, 1.0);
        const clamped_b = std.math.clamp(b, 0.0, 1.0);

        return Color{ .value = @Vector(3, f64){ clamped_r, clamped_g, clamped_b } };
    }

    pub fn from_scalar(v: f64) Color {
        return Color.init(v, v, v);
    }

    pub fn red(self: Color) f64 {
        return self.value[0];
    }

    pub fn green(self: Color) f64 {
        return self.value[1];
    }

    pub fn blue(self: Color) f64 {
        return self.value[2];
    }

    pub fn from_vector(vector: [3]f64) Color {
        return Color.init(vector[0], vector[1], vector[2]);
    }
};
