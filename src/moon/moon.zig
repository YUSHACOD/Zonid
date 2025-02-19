const std = @import("std");
const rl = @import("raylib");

const Drawable = @import("../utils/utils.zig").Drawable;
const EntityError = @import("../utils/utils.zig").DrawableError;
const Pos = @import("../utils/utils.zig").Pos;

const ResourcePaths = [_][*:0]const u8{
    "./resources/images/moons/moon_1.png",
    "./resources/images/moons/moon_2.png",
    "./resources/images/moons/moon_3.png",
    "./resources/images/moons/moon_4.png",
    "./resources/images/moons/moon_5.png",
    "./resources/images/moons/moon_6.png",
    "./resources/images/moons/moon_7.png",
};

pub const Moon = struct {
    pos: Pos = Pos{ .x = 0, .y = 0 },
    state: usize,
    states: []Drawable,

    pub fn init(allocator: std.mem.Allocator) anyerror!Moon {
        const states = try allocator.alloc(Drawable, ResourcePaths.len);
        errdefer allocator.free(states);

        for (ResourcePaths, 0..) |resource, i| {
            states[i] = try Drawable.init(resource, null);
        }

        return Moon{
            .states = states,
            .state = 0,
        };
    }

    pub fn deinit(self: *Moon, allocator: std.mem.Allocator) void {
        for (self.states) |entity| {
            entity.deinit();
        }
        allocator.free(self.states);
    }

    pub fn incrementState(self: *Moon) void {
        self.state = (self.state + 1) % 7;
    }

    pub fn draw(self: *Moon, pos: Pos) void {
        self.states[self.state].draw(pos);
    }

    pub fn getWidth(self: *Moon) i32 {
        return self.states[self.state].texture.width;
    }

    pub fn getHeight(self: *Moon) i32 {
        return self.states[self.state].texture.height;
    }
};
