const std = @import("std");
const rl = @import("raylib");

const Drawable = @import("../utils/drawable.zig").Drawable;
const utils = @import("../utils/utils.zig");

const ResourcePaths = [_][*:0]const u8{
    "./resources/images/sky/star_1.png",
    "./resources/images/sky/star_2.png",
    "./resources/images/sky/star_3.png",
};

pub const StarPositions = [_]rl.Vector2{
    rl.Vector2{ .x = 3.64e2, .y = 1.85e2 },
    rl.Vector2{ .x = 1.199e3, .y = 2.52e2 },
    rl.Vector2{ .x = 1.017e3, .y = 3.6e1 },
    rl.Vector2{ .x = 7.17e2, .y = 8.7e1 },
    rl.Vector2{ .x = 5.7e1, .y = 3.33e2 },
    rl.Vector2{ .x = 4e1, .y = 1.53e2 },
    rl.Vector2{ .x = 1.501e3, .y = 2.16e2 },
    rl.Vector2{ .x = 1.743e3, .y = 4.06e2 },
    rl.Vector2{ .x = 1.813e3, .y = 9.5e1 },
};

pub const StarStates = [_]usize{ 0, 2, 1, 1, 0, 2, 1, 2, 0 };

pub const Stars = struct {
    drawables: []Drawable,
    width: f32,
    height: f32,

    pub fn init(allocator: std.mem.Allocator) anyerror!Stars {
        const drawables = try allocator.alloc(Drawable, ResourcePaths.len);
        errdefer allocator.free(drawables);

        for (ResourcePaths, 0..) |resource, i| {
            drawables[i] = try Drawable.init(resource, null);
        }

        return Stars{
            .drawables = drawables,
            .width = @floatFromInt(drawables[0].texture.width),
            .height = @floatFromInt(drawables[0].texture.height),
        };
    }

    pub fn deinit(self: *Stars, allocator: std.mem.Allocator) void {
        for (self.drawables) |entity| {
            entity.deinit();
        }
        allocator.free(self.drawables);
    }

    pub fn draw(self: *Stars, pos: rl.Vector2, state: usize) void {
        self.drawables[state].draw(pos);
    }
};
