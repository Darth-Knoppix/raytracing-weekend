const std = @import("std");

pub const Vec3 = struct {
    value: @Vector(3, f32),

    pub fn init(rx: f32, ry: f32, rz: f32) Vec3 {
        return Vec3{ .value = @Vector(3, f32){ rx, ry, rz } };
    }

    pub fn zero() Vec3 {
        return Vec3{ .value = @Vector(3, f32){ 0, 0, 0 } };
    }

    pub fn from_vector(vector: [3]f32) Vec3 {
        return Vec3{ .value = vector };
    }

    pub fn length(self: Vec3) f32 {
        return @sqrt(self.length_squared());
    }

    pub fn length_squared(self: Vec3) f32 {
        return self.value[0] * self.value[0] + self.value[1] * self.value[1] + self.value[2] * self.value[2];
    }

    pub fn unit(self: Vec3) Vec3 {
        const v_length = self.length();
        return Vec3.from_vector(self.value / Vec3.init(v_length, v_length, v_length).value);
    }

    pub fn x(self: Vec3) f32 {
        return self.value[0];
    }

    pub fn y(self: Vec3) f32 {
        return self.value[1];
    }

    pub fn z(self: Vec3) f32 {
        return self.value[2];
    }

    pub fn dot(self: Vec3, other: Vec3) f32 {
        return self.x() * other.x() + self.y() * other.y() + self.z() * other.z();
    }
};

test "multiply" {
    const a = Vec3.init(1, 2, 3);
    const b = Vec3.init(2, 2, 2);

    const result = a.value * b.value;
    try std.testing.expectEqual(Vec3.init(2, 4, 6).value, result);
}

test "add" {
    const a = Vec3.init(1, 2, 3);
    const b = Vec3.init(2, 2, 2);

    const result = a.value + b.value;
    try std.testing.expectEqual(Vec3.init(3, 4, 5).value, result);
}

test "subtract" {
    const a = Vec3.init(1, 2, 3);
    const b = Vec3.init(2, 2, 2);

    const result = a.value - b.value;
    try std.testing.expectEqual(Vec3.init(-1, 0, 1).value, result);
}

test "dot" {
    const a = Vec3.init(1, 2, 3);
    const b = Vec3.init(2, 2, 2);

    const result = a.dot(b);
    const expected: f32 = 12;
    try std.testing.expectEqual(expected, result);
}
