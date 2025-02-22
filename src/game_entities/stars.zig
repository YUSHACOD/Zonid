const std = @import("std");
const rl = @import("raylib");

const Drawable = @import("../utils/drawable.zig").Drawable;
const utils = @import("../utils/utils.zig");

const ResourcePaths = [_][*:0]const u8{
    "./resources/images/sky/star_1.png",
    "./resources/images/sky/star_2.png",
    "./resources/images/sky/star_3.png",
};

pub const Stars = struct {
    drawables: []Drawable,
    state: usize = 0,
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

    pub fn incrementState(self: *Stars) void {
        self.state = (self.state + 1) % ResourcePaths.len;
    }

    pub fn draw(self: *Stars, pos: rl.Vector2) void {
        self.drawables[self.state].draw(pos);
    }
};
