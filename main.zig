const std = @import("std");
const math = std.math;

fn map(value: f32, from: struct { f32, f32 }, to: struct { f32, f32 }) f32 {
    const mapped = ((value - from[0]) * (to[1] - to[0])) / (from[1] - from[0]) + to[0];
    return math.min(math.max(mapped, to[0]), to[1]);
}

fn escapeTime(c: @TypeOf(math.Complex(f32)), max_iterations: u32) ?u32 {
    var z = math.Complex(f32){ .re = 0, .im = 0 };

    for (0..max_iterations) |i| {
        if (z.magnitude() > 4.0) {
            return i;
        }

        z = z.mul(z).add(c);
    }
}

pub fn main() !void {
    _ = std.io.getStdOut().write("Hello World!!");
}
