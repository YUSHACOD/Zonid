const std = @import("std");
const rl = @import("raylib");

const Drawable = @import("../utils/drawable.zig").Drawable;
const utils = @import("../utils/utils.zig");

const ResourcePaths = [_][:0]const u8{
    "./resources/images/moons/moon_1.png",
    "./resources/images/moons/moon_2.png",
    "./resources/images/moons/moon_3.png",
    "./resources/images/moons/moon_4.png",
    "./resources/images/moons/moon_5.png",
    "./resources/images/moons/moon_6.png",
    "./resources/images/moons/moon_7.png",
};

const MoonPos = rl.Vector2{ .x = 1.291e3, .y = 1.03e2 };

pub const Moon = struct {
    drawables: []Drawable,
    state: isize = 0,
    width: f32,
    height: f32,

    pub fn init(allocator: std.mem.Allocator) anyerror!Moon {
        const drawables = try allocator.alloc(Drawable, ResourcePaths.len);
        errdefer allocator.free(drawables);

        for (ResourcePaths, 0..) |resource, i| {
            drawables[i] = try Drawable.init(resource, null);
        }

        return Moon{
            .drawables = drawables,
            .width = @floatFromInt(drawables[0].texture.width),
            .height = @floatFromInt(drawables[0].texture.height),
        };
    }

    pub fn deinit(self: *Moon, allocator: std.mem.Allocator) void {
        for (self.drawables) |entity| {
            entity.deinit();
        }
        allocator.free(self.drawables);
    }

    pub fn incrementState(self: *Moon) void {
        self.state = @mod((self.state + 1), ResourcePaths.len);
    }

    pub fn decrementState(self: *Moon) void {
        self.state = @mod((self.state - 1), ResourcePaths.len);
    }

    pub fn draw(self: *Moon, pos: rl.Vector2) void {
        self.drawables[@intCast(self.state)].draw(pos);
    }

    pub fn drawSelf(self: *Moon) void {
        self.drawables[@intCast(self.state)].draw(MoonPos);
    }
};
