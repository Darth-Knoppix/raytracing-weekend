const std = @import("std");
const ppm_outputter = @import("./outputter/ppm.zig");

pub fn main() !void {
    std.debug.print("Outputting PPM file", .{});
    try ppm_outputter.generate(512, 512, 255);
    std.debug.print("Done\n", .{});
}

test "simple test" {
    var list = std.ArrayList(i32).init(std.testing.allocator);
    defer list.deinit(); // try commenting this out and see if zig detects the memory leak!
    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}
