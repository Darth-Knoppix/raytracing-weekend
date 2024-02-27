const std = @import("std");

pub const Vec3 = struct {
    x: f32,
    y: f32,
    z: f32,

    pub fn init(x: f32, y: f32, z: f32) Vec3 {
        return Vec3{
            .x = x,
            .y = y,
            .z = z,
        };
    }

    pub fn dot(self: Vec3, other: Vec3) f32 {
        return self.x * other.x + self.y * other.y + self.z * other.z;
    }

    pub fn cross(self: Vec3, other: Vec3) Vec3 {
        return Vec3.init(self.y * other.z - self.z * other.y, self.z * other.x - self.x * other.z, self.x * other.y - self.y * other.x);
    }

    pub fn multiply(self: Vec3, other: Vec3) Vec3 {
        return Vec3.init(self.x * other.x, self.y * other.y, self.z * other.z);
    }

    pub fn add(self: Vec3, other: Vec3) Vec3 {
        return Vec3.init(self.x + other.x, self.y + other.y, self.z + other.z);
    }

    pub fn subtract(self: Vec3, other: Vec3) Vec3 {
        return Vec3.init(self.x - other.x, self.y - other.y, self.z - other.z);
    }

    pub fn divide(self: Vec3, other: Vec3) Vec3 {
        return Vec3.init(self.x * other.x, self.y * other.y, self.z * other.z);
    }

    pub fn length(self: Vec3) f32 {
        return @sqrt(self.length_squared());
    }

    pub fn length_squared(self: Vec3) f32 {
        return self.x * self.x + self.y * self.y + self.z * self.z;
    }

    pub fn unit(self: Vec3) Vec3 {
        const v_length = self.length();
        return self.divide(Vec3.init(v_length, v_length, v_length));
    }
};

test "multiply" {
    const a = Vec3.init(1, 2, 3);
    const b = Vec3.init(2, 2, 2);

    const result = a.multiply(b);
    try std.testing.expectEqual(Vec3.init(2, 4, 6), result);
}

test "add" {
    const a = Vec3.init(1, 2, 3);
    const b = Vec3.init(2, 2, 2);

    const result = a.add(b);
    try std.testing.expectEqual(Vec3.init(3, 4, 5), result);
}

test "subtract" {
    const a = Vec3.init(1, 2, 3);
    const b = Vec3.init(2, 2, 2);

    const result = a.subtract(b);
    try std.testing.expectEqual(Vec3.init(-1, 0, 1), result);
}
