const std = @import("std");
const rl = @import("raylib");

const Drawable = @import("drawable.zig").Drawable;

pub fn init(x: f32, y: f32) rl.Vector2 {
    return rl.Vector2{ .x = x, .y = y };
}

pub fn vecToPos(vec: rl.Vector2) rl.Vector2 {
    return rl.Vector2{
        .x = @intFromFloat(vec.x),
        .y = @intFromFloat(vec.y),
    };
}

pub fn adjustPosMiddle(pos: rl.Vector2, width: f32, height: f32) rl.Vector2 {
    return rl.Vector2{ .x = pos.x - @divFloor(width, 2), .y = pos.y - @divFloor(height, 2) };
}

pub fn adjustPosWidth(pos: rl.Vector2, width: f32, height: f32) rl.Vector2 {
    return rl.Vector2{ .x = pos.x - @divFloor(width, 2), .y = pos.y - height };
}

pub fn adjustPosHeight(pos: rl.Vector2, height: f32) rl.Vector2 {
    return rl.Vector2{ .x = pos.x, .y = pos.y - @divFloor(height, 2) };
}

pub fn updateWithMousePos(pos: *rl.Vector2) void {
    if (rl.isMouseButtonDown(rl.MouseButton.left)) {
        std.debug.print("mouse pos {}\n", .{rl.getMousePosition()});
        const mouse_p: rl.Vector2 = rl.getMousePosition();

        pos.x = mouse_p.x;
        pos.y = mouse_p.y;
    }
}

// Physics helpers
//----------------------------------------------------------------------------------
pub fn newVelocity(current_vel: rl.Vector2, accl: rl.Vector2, time_elapsed: f32) rl.Vector2 {
    return rl.Vector2{
        .x = current_vel.x + accl.x * time_elapsed,
        .y = current_vel.y + accl.y * time_elapsed,
    };
}

pub fn displacement(current_vel: rl.Vector2, accl: rl.Vector2, time_elapsed: f32) rl.Vector2 {
    const time_elapsed_2 = std.math.pow(f32, time_elapsed, 2);
    return rl.Vector2{
        .x = (current_vel.x * time_elapsed) + (0.5 * accl.x * time_elapsed_2),
        .y = (current_vel.y * time_elapsed) + (0.5 * accl.y * time_elapsed_2),
    };
}
//----------------------------------------------------------------------------------
