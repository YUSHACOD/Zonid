const std = @import("std");
const rl = @import("raylib");

const Drawable = @import("../utils/utils.zig").Drawable;
const EntityError = @import("../utils/utils.zig").DrawableError;
const Pos = @import("../utils/utils.zig").Pos;

const ResourcePaths = [_][*:0]const u8{
    "./resources/images/sky/star_1.png",
    "./resources/images/sky/star_2.png",
    "./resources/images/sky/star_3.png",
};

pub const Star = struct {
    pos: Pos = Pos{ .x = 0, .y = 0 },
    state: usize,
    states: []Drawable,

    pub fn init(allocator: std.mem.Allocator) anyerror!Star {
        const states = try allocator.alloc(Drawable, ResourcePaths.len);
        errdefer allocator.free(states);

        for (ResourcePaths, 0..) |resource, i| {
            states[i] = try Drawable.init(resource, null);
        }

        return Star{
            .states = states,
            .state = 0,
        };
    }

    pub fn deinit(self: *Star, allocator: std.mem.Allocator) void {
        for (self.states) |entity| {
            entity.deinit();
        }
        allocator.free(self.states);
    }

    pub fn incrementState(self: *Star) void {
        self.state = (self.state + 1) % 3;
    }

    pub fn draw(self: *Star, pos: Pos) void {
        self.states[self.state].draw(pos);
    }

    pub fn getWidth(self: *Star) i32 {
        return self.states[self.state].texture.width;
    }

    pub fn getHeight(self: *Star) i32 {
        return self.states[self.state].texture.height;
    }
};
