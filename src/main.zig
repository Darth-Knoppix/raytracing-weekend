const std = @import("std");
const ppm_outputter = @import("./outputter/ppm.zig");
const Vec3 = @import("./vec3.zig").Vec3;

pub fn main() !void {
    const aspect_ratio = 16.0 / 9.0;
    const raw_image_width = 512.0;
    const raw_image_height = raw_image_width / aspect_ratio;

    const image_width = @as(u16, @intFromFloat(raw_image_width));
    const image_height = @as(u16, @intFromFloat(raw_image_height));

    std.debug.print("Outputting PPM file", .{});
    try ppm_outputter.generate(image_width, image_height, 255);
    std.debug.print("Done\n", .{});
}
