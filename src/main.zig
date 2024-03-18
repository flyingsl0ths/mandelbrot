const std = @import("std");
const math = std.math;

const rl = @import("raylib");

fn map(value: f32, from: struct { f32, f32 }, to: struct { f32, f32 }) f32 {
    const mapped = ((value - from[0]) * (to[1] - to[0])) / (from[1] - from[0]) + to[0];
    return @min(@max(mapped, to[0]), to[1]);
}

fn escapeTime(c: anytype, max_iterations: usize) ?usize {
    if (@TypeOf(c) != math.Complex(f64)) {
        return;
    }

    var z = math.Complex(f64){ .re = 0.0, .im = 0.0 };

    for (0..max_iterations) |iteration| {
        if (z.magnitude() > 4.0) {
            return iteration;
        }

        z = z.mul(z).add(c);
    }

    return null;
}

pub fn main() !void {
    const screen_width = 1280;
    const screen_height = 730;

    const max_iterations = 255;
    const re_start = -2.0;
    const re_end = 0.47;
    const im_start = -1.12;
    const im_end = 1.12;

    const foreground_color = rl.Color.init(0xe9, 0x1e, 0x63, 255);
    rl.initWindow(screen_width, screen_height, "Mandelbrot Set");
    defer rl.closeWindow();

    rl.setTargetFPS(60);

    while (!rl.windowShouldClose()) {
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(foreground_color);

        for (0..screen_width) |x| {
            for (0..screen_height) |y| {
                const px = map(@floatFromInt(x), .{ 0, screen_width }, .{ re_start, re_end });
                const py = map(@floatFromInt(y), .{ 0, screen_height }, .{ im_start, im_end });
                const c = math.Complex(f64){ .re = px, .im = py };

                if (escapeTime(c, max_iterations)) |iterations| {
                    var color: u8 = @intCast(max_iterations - iterations);
                    rl.drawPixel(@as(i32, @intCast(x)), @as(i32, @intCast(y)), rl.Color.init(color, color, color, color));
                }
            }
        }
    }
}
