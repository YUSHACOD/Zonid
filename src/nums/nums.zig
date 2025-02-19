const std = @import("std");
const rl = @import("raylib");

const Drawable = @import("../utils/utils.zig").Drawable;
const EntityError = @import("../utils/utils.zig").DrawableError;
const Pos = @import("../utils/utils.zig").Pos;

const ResourcePaths = [_][*:0]const u8{
    "./resources/images/nums/0.png",
    "./resources/images/nums/1.png",
    "./resources/images/nums/2.png",
    "./resources/images/nums/3.png",
    "./resources/images/nums/4.png",
    "./resources/images/nums/5.png",
    "./resources/images/nums/6.png",
    "./resources/images/nums/7.png",
    "./resources/images/nums/8.png",
    "./resources/images/nums/9.png",
};

pub const Nums = struct {
    pos: Pos = Pos{ .x = 0, .y = 0 },
    state: usize,
    states: []Drawable,

    pub fn init(allocator: std.mem.Allocator) anyerror!Nums {
        const states = try allocator.alloc(Drawable, ResourcePaths.len);
        errdefer allocator.free(states);

        for (ResourcePaths, 0..) |resource, i| {
            states[i] = try Drawable.init(resource, null);
        }

        return Nums{
            .states = states,
            .state = 0,
        };
    }

    pub fn deinit(self: *Nums, allocator: std.mem.Allocator) void {
        for (self.states) |entity| {
            entity.deinit();
        }
        allocator.free(self.states);
    }

    pub fn incrementState(self: *Nums) void {
        self.state = (self.state + 1) % ResourcePaths.len;
    }

    pub fn draw(self: *Nums, pos: Pos) void {
        self.states[self.state].draw(pos);
    }

    pub fn getWidth(self: *Nums) i32 {
        return self.states[self.state].texture.width;
    }

    pub fn getHeight(self: *Nums) i32 {
        return self.states[self.state].texture.height;
    }
};
