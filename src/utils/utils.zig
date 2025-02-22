const std = @import("std");
const rl = @import("raylib");

const Drawable = @import("drawable.zig").Drawable;

pub const Pos = struct {
    x: i32,
    y: i32,

    pub fn toVector(self: Pos) rl.Vector2 {
        return rl.Vector2.init(@floatFromInt(self.x), @floatFromInt(self.y));
    }

    pub fn init(x: i32, y: i32) Pos {
        return Pos{ .x = x, .y = y };
    }

    pub fn vecToPos(vec: rl.Vector2) Pos {
        return Pos{
            .x = @intFromFloat(vec.x),
            .y = @intFromFloat(vec.y),
        };
    }

    pub fn adjustPosMiddle(pos: *Pos, width: i32, height: i32) Pos {
        return Pos{ .x = pos.x - @divFloor(width, 2), .y = pos.y - @divFloor(height, 2) };
    }

    pub fn adjustPosWidth(pos: *Pos, width: i32, height: i32) Pos {
        return Pos{ .x = pos.x - @divFloor(width, 2), .y = pos.y - height };
    }

    pub fn adjustPosHeight(pos: *Pos, height: i32) Pos {
        return Pos{ .x = pos.x, .y = pos.y - @divFloor(height, 2) };
    }

    pub fn updateWithMousePos(pos: *Pos) void {
        if (rl.isMouseButtonDown(rl.MouseButton.left)) {
            std.debug.print("mouse pos {}\n", .{rl.getMousePosition()});
            const mouse_p: Pos = Pos.vecToPos(rl.getMousePosition());

            pos.x = mouse_p.x;
            pos.y = mouse_p.y;
        }
    }
};
