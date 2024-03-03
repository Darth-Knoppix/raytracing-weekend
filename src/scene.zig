const std = @import("std");
const Vec3 = @import("./vec3.zig").Vec3;
const Ray = @import("./ray.zig").Ray;
const Sphere = @import("./sphere.zig").Sphere;
const HitRecord = @import("./hit_record.zig").HitRecord;

pub const Scene = struct {
    nodes: std.ArrayList(Sphere),

    pub fn render(self: Scene, ray: Ray, ray_tmin: f64, ray_tmax: f64) ?HitRecord {
        var closest = ray_tmax;
        var last_hit: ?HitRecord = null;
        for (self.nodes.items) |node| {
            const hit = node.hit(ray, ray_tmin, closest);
            if (hit) |h| {
                closest = h.t;
                last_hit = h;
            }
        }

        return last_hit;
    }
};
