const std = @import("std");
const Color = @import("../color.zig").Color;
const Ray = @import("../ray.zig").Ray;
const Vec3 = @import("../vec3.zig").Vec3;
const Scene = @import("../scene.zig").Scene;
const HitRecord = @import("../hit_record.zig").HitRecord;

// Colours
const pale_blue = Color.init(0.5, 0.7, 1.0);

pub fn generate(scene: Scene, width: u16, height: u16, max_color: u8) !void {
    const out = std.io.getStdOut();
    var bw = std.io.bufferedWriter(out.writer());
    const writer = bw.writer();

    const f_width = @as(f64, @floatFromInt(width));
    const f_height = @as(f64, @floatFromInt(height));

    // Camera
    const focal_length = 1.0;
    const viewport_height = 2.0;
    const viewport_width = viewport_height * (f_width / f_height);
    const camera_center = Vec3.zero();

    const viewport_u = Vec3.init(viewport_width, 0, 0);
    const viewport_v = Vec3.init(0, -viewport_height, 0);

    const pixel_delta_u = Vec3.from_vector(viewport_u.value / Vec3.from_scalar(f_width).value);
    const pixel_delta_v = Vec3.from_vector(viewport_v.value / Vec3.from_scalar(f_height).value);

    const viewport_top_left = Vec3.from_vector(camera_center.value - Vec3.init(0, 0, focal_length).value - (viewport_u.value / Vec3.from_scalar(2).value) - (viewport_v.value / Vec3.from_scalar(2).value));

    const pixel_top_left = Vec3.from_vector(viewport_top_left.value + Vec3.from_scalar(0.5).value * (pixel_delta_u.value + pixel_delta_v.value));

    try write_header(writer, width, height, max_color);

    var hit_record = HitRecord{ .front_facing = true, .normal = Vec3.zero(), .point = Vec3.zero(), .t = 0.0 };

    for (0..height) |row_index| {
        std.log.debug("\rScanlines remaining: {}", .{height - row_index});
        const f_row = @as(f64, @floatFromInt(row_index));

        for (0..width) |column_index| {
            const f_column = @as(f64, @floatFromInt(column_index));
            const pixel_center = Vec3.from_vector(pixel_top_left.value + (Vec3.from_scalar(f_column).value * pixel_delta_u.value) + (Vec3.from_scalar(f_row).value * pixel_delta_v.value));
            const ray_direction = Vec3.from_vector(pixel_center.value - camera_center.value);
            const ray = Ray.init(camera_center, ray_direction);
            const result = ray_color(ray, scene, hit_record);
            hit_record = result[1];

            try write_color(writer, result[0], max_color);
        }
    }

    try bw.flush();
}

pub fn write_header(writer: anytype, width: u16, height: u16, max_color: u8) !void {
    try writer.print("P3\n{} {}\n{}\n", .{ width, height, max_color });
}

pub fn write_color(writer: anytype, color: Color, max_color: u8) !void {
    const red_channel = map_float_to_channel(color.red(), max_color);
    const green_channel = map_float_to_channel(color.green(), max_color);
    const blue_channel = map_float_to_channel(color.blue(), max_color);

    try writer.print("{} {} {}\n", .{ red_channel, green_channel, blue_channel });
}

fn map_float_to_channel(value: f64, size: u8) u8 {
    const max_color_multiplier = @as(f64, @floatFromInt(size));
    return @as(u8, @intFromFloat(value * max_color_multiplier));
}

const ColorResult = std.meta.Tuple(&.{ Color, HitRecord });

fn ray_color(ray: Ray, scene: Scene, hit_record: HitRecord) ColorResult {
    const hit_result = scene.render(ray, 0.0, std.math.inf(f64));
    if (hit_result) |hit| {
        const color = Color.from_vector(Vec3.from_scalar(0.5).value * (hit.normal.value + Vec3.from_scalar(1.0).value));
        return .{ color, hit };
    }

    // Draw gradient
    const unit_direction = ray.direction.unit();
    const a = 0.5 * (unit_direction.y() + 1.0);
    const v = Color.from_scalar(1.0 - a).value * Color.from_scalar(1.0).value + Color.from_scalar(a).value * pale_blue.value;
    return .{ Color.from_vector(v), hit_record };
}
