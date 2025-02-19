const std = @import("std");
const rl = @import("raylib");

const Drawable = @import("../utils/utils.zig").Drawable;
const EntityError = @import("../utils/utils.zig").DrawableError;
const Pos = @import("../utils/utils.zig").Pos;

const ResourcePaths = [_][*:0]const u8{
    "./resources/images/big_tree/big_tree_1.png",
    "./resources/images/big_tree/big_tree_2.png",
    "./resources/images/big_tree/big_tree_3.png",
    "./resources/images/big_tree/big_tree_4.png",
    "./resources/images/big_tree/big_tree_5.png",
};

pub const BigTree = struct {
    pos: Pos = Pos{ .x = 0, .y = 0 },
    state: usize,
    states: []Drawable,

    pub fn init(allocator: std.mem.Allocator) anyerror!BigTree {
        const states = try allocator.alloc(Drawable, ResourcePaths.len);
        errdefer allocator.free(states);

        for (ResourcePaths, 0..) |resource, i| {
            states[i] = try Drawable.init(resource, null);
        }

        return BigTree{
            .states = states,
            .state = 0,
        };
    }

    pub fn deinit(self: *BigTree, allocator: std.mem.Allocator) void {
        for (self.states) |entity| {
            entity.deinit();
        }
        allocator.free(self.states);
    }

    pub fn incrementState(self: *BigTree) void {
        self.state = (self.state + 1) % ResourcePaths.len;
    }

    pub fn draw(self: *BigTree, pos: Pos) void {
        self.states[self.state].draw(pos);
    }

    pub fn getWidth(self: *BigTree) i32 {
        return self.states[self.state].texture.width;
    }

    pub fn getHeight(self: *BigTree) i32 {
        return self.states[self.state].texture.height;
    }
};
