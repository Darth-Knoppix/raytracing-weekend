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

    pub fn at(self: Ray, t: f32) Ray {
        return self.origin.add(self.direction.multiply(Vec3.init(t, t, t)));
    }
};