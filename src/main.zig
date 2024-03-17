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

    for (0..max_iterations) |i| {
        if (z.magnitude() > 4.0) {
            return i;
        }

        z = z.mul(z).add(c);
    }

    return null;
}

pub fn main() !void {
    const screenWidth = 800;
    const screenHeight = 450;
    const max_iterations = 1000;

    rl.initWindow(screenWidth, screenHeight, "Mandelbrot Set");
    defer rl.closeWindow();

    rl.setTargetFPS(60);

    while (!rl.windowShouldClose()) {
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(rl.Color.black);

        for (0..screenWidth) |x| {
            for (0..screenHeight) |y| {
                const px = map(@floatFromInt(x), .{ 0, screenWidth }, .{ -2.0, 0.47 });
                const py = map(@floatFromInt(y), .{ 0, screenHeight }, .{ -1.12, 1.12 });
                const c = math.Complex(f64){ .re = px, .im = py };

                if (escapeTime(c, max_iterations)) |_| {
                    rl.drawPixel(@as(i32, @intCast(x)), @as(i32, @intCast(y)), rl.Color.white);
                }
            }
        }
    }
}
