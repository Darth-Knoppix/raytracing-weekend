const std = @import("std");
const Vec3 = @import("./vec3.zig").Vec3;
const Ray = @import("./ray.zig").Ray;

pub const HitRecord = struct {
    point: Vec3,
    normal: Vec3,
    t: f64,
    front_facing: bool,

    pub fn set_face_normal(self: HitRecord, ray: Ray, outward_normal: Vec3) HitRecord {
        const new_front_facing = ray.direction.dot(outward_normal) < 0;
        var new_normal = Vec3.from_vector(Vec3.from_scalar(-1.0).value * outward_normal.value);
        if (new_front_facing) {
            new_normal = outward_normal;
        }

        return HitRecord{ .point = self.point, .t = self.t, .normal = new_normal, .front_facing = new_front_facing };
    }
};

pub const HitResult = struct {
    hit: bool,
    value: HitRecord,
};
