const std = @import("std");
const Color = @import("../color.zig").Color;

pub fn generate(width: u16, height: u16, max_color: u8) !void {
    const out = std.io.getStdOut();
    var bw = std.io.bufferedWriter(out.writer());
    const writer = bw.writer();

    try write_header(writer, width, height, max_color);

    for (0..height) |row_index| {
        std.log.debug("\rScanlines remaining: {}", .{height - row_index});

        for (0..width) |column_index| {
            const width_offset = @as(f32, @floatFromInt(width - 1));
            const height_offset = @as(f32, @floatFromInt(height - 1));

            const color = Color.init(@as(f32, @floatFromInt(column_index)) / width_offset, @as(f32, @floatFromInt(row_index)) / height_offset, 0);

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
