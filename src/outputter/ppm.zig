const std = @import("std");

pub fn generate(width: u16, height: u16, max_color: u8) !void {
    const out = std.io.getStdOut();
    var bw = std.io.bufferedWriter(out.writer());
    const stdout = bw.writer();

    try stdout.print("P3\n{} {}\n{}\n", .{ width, height, max_color });

    for (0..height) |row_index| {
        for (0..width) |column_index| {
            const width_offset = @as(f64, @floatFromInt(width - 1));
            const height_offset = @as(f64, @floatFromInt(height - 1));

            const red = @as(f64, @floatFromInt(column_index)) / width_offset;
            const green = @as(f64, @floatFromInt(row_index)) / height_offset;
            const blue = 0;

            const red_channel = map_float_to_channel(red, max_color);
            const green_channel = map_float_to_channel(green, max_color);
            const blue_channel = map_float_to_channel(blue, max_color);

            try stdout.print("{} {} {}\n", .{ red_channel, green_channel, blue_channel });
        }
    }

    try bw.flush();
}

fn map_float_to_channel(value: f64, size: u8) u8 {
    const max_color_multiplier = @as(f64, @floatFromInt(size));
    return @as(u8, @intFromFloat(value * max_color_multiplier));
}
