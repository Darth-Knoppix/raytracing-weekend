const Vec3 = @import("./vec3.zig").Vec3;

pub const Ray = struct {
    origin: Vec3,
    direction: Vec3,

    pub fn init(origin: Vec3, direction: Vec3) Ray {
        return Ray{
            .origin = origin,
            .direction = direction,
        };
    }

    pub fn at(self: Ray, t: f64) Vec3 {
        return Vec3.from_vector(self.origin.value + self.direction.value * Vec3.init(t, t, t).value);
    }
};
