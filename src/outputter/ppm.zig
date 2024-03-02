const std = @import("std");
const Color = @import("../color.zig").Color;
const Ray = @import("../ray.zig").Ray;
const Vec3 = @import("../vec3.zig").Vec3;

// Colours
const pale_blue = Color.init(0.5, 0.7, 1.0);
const redish = Color.init(1.0, 0.7, 0.5);

pub fn generate(width: u16, height: u16, max_color: u8) !void {
    const out = std.io.getStdOut();
    var bw = std.io.bufferedWriter(out.writer());
    const writer = bw.writer();

    const f_width = @as(f32, @floatFromInt(width));
    const f_height = @as(f32, @floatFromInt(height));

    // Camera
    const focal_length = 1.0;
    const viewport_height = 2.0;
    const viewport_width = viewport_height * (f_width / f_height);
    const camera_center = Vec3.zero();

    const viewport_u = Vec3.init(viewport_width, 0, 0);
    const viewport_v = Vec3.init(0, -viewport_height, 0);

    const pixel_delta_u = Vec3.from_vector(viewport_u.value / Vec3.init(f_width, f_width, f_width).value);
    const pixel_delta_v = Vec3.from_vector(viewport_v.value / Vec3.init(f_height, f_height, f_height).value);

    const viewport_top_left = Vec3.from_vector(camera_center.value - Vec3.init(0, 0, focal_length).value - (viewport_u.value / Vec3.init(2, 2, 2).value) - (viewport_v.value / Vec3.init(2, 2, 2).value));

    const pixel_top_left = Vec3.from_vector(viewport_top_left.value + Vec3.init(0.5, 0.5, 0.5).value * (pixel_delta_u.value + pixel_delta_v.value));

    try write_header(writer, width, height, max_color);

    for (0..height) |row_index| {
        std.log.debug("\rScanlines remaining: {}", .{height - row_index});
        const f_row = @as(f32, @floatFromInt(row_index));

        for (0..width) |column_index| {
            const f_column = @as(f32, @floatFromInt(column_index));
            const pixel_center = Vec3.from_vector(pixel_top_left.value + (Vec3.init(f_column, f_column, f_column).value * pixel_delta_u.value) + (Vec3.init(f_row, f_row, f_row).value * pixel_delta_v.value));
            const ray_direction = Vec3.from_vector(pixel_center.value - camera_center.value);
            const ray = Ray.init(camera_center, ray_direction);
            const color = ray_color(ray);

            try write_color(writer, color, max_color);
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

fn map_float_to_channel(value: f32, size: u8) u8 {
    const max_color_multiplier = @as(f32, @floatFromInt(size));
    return @as(u8, @intFromFloat(value * max_color_multiplier));
}

fn hit_sphere(center: Vec3, radius: f32, ray: Ray) f32 {
    const intersect = Vec3.from_vector(ray.origin.value - center.value);
    const a = ray.direction.dot(ray.direction);
    const b = 2.0 * intersect.dot(ray.direction);
    const c = intersect.dot(intersect) - radius * radius;
    const discriminant = b * b - 4.0 * a * c;

    if (discriminant < 0) {
        return -1.0;
    } else {
        return (-b - @sqrt(discriminant)) / (2.0 * a);
    }
}

fn ray_color(ray: Ray) Color {
    const hit_point = hit_sphere(Vec3.init(0, 0, -1), 0.5, ray);
    if (hit_point > 0.0) {
        const length = Vec3.from_vector(ray.at(hit_point).value - Vec3.init(0, 0, -1).value);
        return Color.from_vector(Color.init(length.x() + 1.0, length.y() + 1.0, length.z() + 1.0).value * Vec3.init(0.5, 0.5, 0.5).value);
    }

    const unit_direction = ray.direction.unit();
    const a = 0.5 * (unit_direction.y() + 1.0);
    const v = Color.init(1.0 - a, 1.0 - a, 1.0 - a).value * Color.init(1.0, 1.0, 1.0).value + Color.init(a, a, a).value * pale_blue.value;
    return Color.from_vector(v);
}
