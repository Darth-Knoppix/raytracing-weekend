const std = @import("std");
const Vec3 = @import("./vec3.zig").Vec3;
const Ray = @import("./ray.zig").Ray;
const HitRecord = @import("./hit_record.zig").HitRecord;
const HitResult = @import("./hit_record.zig").HitResult;

pub const Sphere = struct {
    center: Vec3,
    radius: f64,

    pub fn init(center: Vec3, radius: f64) Sphere {
        return Sphere{ .center = center, .radius = radius };
    }

    pub fn hit(self: Sphere, ray: Ray, ray_tmin: f64, ray_tmax: f64) ?HitRecord {
        const intersect = Vec3.from_vector(ray.origin.value - self.center.value);
        const a = ray.direction.length_squared();
        const half_b = intersect.dot(ray.direction);
        const c = intersect.length_squared() - (self.radius * self.radius);
        const discriminant = (half_b * half_b) - (a * c);
        if (discriminant < 0) {
            return null;
        }

        const square_root = @sqrt(discriminant);

        var root = (-half_b - square_root) / a;
        if (root <= ray_tmin or ray_tmax <= root) {
            root = (-half_b + square_root) / a;
            if (root <= ray_tmin or ray_tmax <= root) {
                return null;
            }
        }

        var new_hit_record = HitRecord{
            .front_facing = false,
            .t = root,
            .point = ray.at(root),
            .normal = Vec3.from_vector((ray.at(root).value - self.center.value) / Vec3.from_scalar(self.radius).value),
        };
        const outward_normal = Vec3.from_vector((ray.at(root).value - self.center.value) / Vec3.from_scalar(self.radius).value);
        new_hit_record = new_hit_record.set_face_normal(ray, outward_normal);

        return new_hit_record;
    }
};

test "hit returns result" {
    const sphere = Sphere.init(Vec3.zero(), 0.5);
    const result = sphere.hit(Ray.init(Vec3.zero(), Vec3.init(0, 0, -1)), 0, 10, HitRecord{ .normal = Vec3.zero(), .point = Vec3.zero(), .t = 2.0, .front_facing = true });
    try std.testing.expectEqual(true, result.hit);
}
