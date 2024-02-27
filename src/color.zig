const Vec3 = @import("./vec3.zig").Vec3;

pub const Color = struct {
    value: Vec3,

    pub fn init(r: f32, g: f32, b: f32) Color {
        return Color{ .value = Vec3.init(r, g, b) };
    }

    pub fn red(self: Color) f32 {
        return self.value.x;
    }

    pub fn green(self: Color) f32 {
        return self.value.y;
    }

    pub fn blue(self: Color) f32 {
        return self.value.z;
    }
};
