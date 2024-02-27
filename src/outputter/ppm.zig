const std = @import("std");
const Color = @import("../color.zig").Color;
const Ray = @import("../ray.zig").Ray;
const Vec3 = @import("../vec3.zig").Vec3;

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
    const camera_center = Vec3.init(0, 0, 0);

    const viewport_u = Vec3.init(viewport_width, 0, 0);
    const viewport_v = Vec3.init(0, -viewport_height, 0);

    const pixel_delta_u = viewport_u.divide(Vec3.init(f_width, f_width, f_width));
    const pixel_delta_v = viewport_v.divide(Vec3.init(f_height, f_height, f_height));

    const viewport_top_left = camera_center.subtract(Vec3.init(0, 0, focal_length))
        .subtract(viewport_u.divide(Vec3.init(2, 2, 2)))
        .subtract(viewport_v.divide(Vec3.init(2, 2, 2)));

    const pixel_top_left = viewport_top_left.add(Vec3.init(0.5, 0.5, 0.5)).multiply(pixel_delta_u.add(pixel_delta_v));

    try write_header(writer, width, height, max_color);

    for (0..height) |row_index| {
        std.log.debug("\rScanlines remaining: {}", .{height - row_index});
        const f_row = @as(f32, @floatFromInt(row_index));

        for (0..width) |column_index| {
            const f_column = @as(f32, @floatFromInt(column_index));
            const pixel_center = pixel_top_left.add(pixel_delta_u.multiply(Vec3.init(f_row, f_row, f_row))).add(pixel_delta_v.multiply(Vec3.init(f_column, f_column, f_column)));
            const ray_direction = pixel_center.subtract(camera_center);
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
    std.log.debug("{} - {}", .{ value, size });
    const max_color_multiplier = @as(f32, @floatFromInt(size));
    return @as(u8, @intFromFloat(value * max_color_multiplier));
}

fn ray_color(ray: Ray) Color {
    const unit_direction = ray.direction.unit();
    const a = 0.5 * (unit_direction.y + 1.0);
    const v = Color.init(1.0, 1.0, 1.0).value.add(Color.init(0.5, 0.7, 1.0).value.multiply(Vec3.init(a, a, a))).multiply(Vec3.init(1, 1, 1).subtract(Vec3.init(a, a, a)));
    return Color.init(v.x, v.y, v.z);
}
