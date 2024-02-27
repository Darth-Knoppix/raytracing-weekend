pub const Color = struct {
    value: @Vector(3, f32),

    pub fn init(r: f32, g: f32, b: f32) Color {
        return Color{ .value = @Vector(3, f32){ r, g, b } };
    }

    pub fn red(self: Color) f32 {
        return self.value[0];
    }

    pub fn green(self: Color) f32 {
        return self.value[1];
    }

    pub fn blue(self: Color) f32 {
        return self.value[2];
    }

    pub fn from_vector(vector: [3]f32) Color {
        return Color{ .value = vector };
    }
};
