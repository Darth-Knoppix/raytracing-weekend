const std = @import("std");
const ppm_outputter = @import("./outputter/ppm.zig");
const Vec3 = @import("./vec3.zig").Vec3;
const Scene = @import("./scene.zig").Scene;
const Sphere = @import("./sphere.zig").Sphere;

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    const aspect_ratio: f64 = 16.0 / 9.0;
    const raw_image_width: f64 = 768.0;
    const raw_image_height: f64 = raw_image_width / aspect_ratio;

    const image_height = @as(u16, @intFromFloat(raw_image_height));
    const image_width = @as(u16, @intFromFloat(raw_image_width));

    var new_list = std.ArrayList(Sphere).init(allocator);
    defer new_list.deinit();
    try new_list.append(Sphere.init(Vec3.init(0, -100.5, -1), 100));
    try new_list.append(Sphere.init(Vec3.init(0, 0, -1), 0.5));
    const scene = Scene{ .nodes = new_list };

    std.debug.print("Outputting PPM file", .{});
    try ppm_outputter.generate(scene, image_width, image_height, 255);
    std.debug.print("Done\n", .{});
}
