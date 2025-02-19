const std = @import("std");
const rl = @import("raylib");

const Drawable = @import("../utils/utils.zig").Drawable;
const EntityError = @import("../utils/utils.zig").DrawableError;
const Pos = @import("../utils/utils.zig").Pos;

const ResourcePaths = [_][*:0]const u8{
    "./resources/images/small_tree/small_tree_1.png",
    "./resources/images/small_tree/small_tree_2.png",
    "./resources/images/small_tree/small_tree_3.png",
    "./resources/images/small_tree/small_tree_4.png",
    "./resources/images/small_tree/small_tree_5.png",
    "./resources/images/small_tree/small_tree_6.png",
};

pub const SmallTree = struct {
    pos: Pos = Pos{ .x = 0, .y = 0 },
    state: usize,
    states: []Drawable,

    pub fn init(allocator: std.mem.Allocator) anyerror!SmallTree {
        const states = try allocator.alloc(Drawable, ResourcePaths.len);
        errdefer allocator.free(states);

        for (ResourcePaths, 0..) |resource, i| {
            states[i] = try Drawable.init(resource, null);
        }

        return SmallTree{
            .states = states,
            .state = 0,
        };
    }

    pub fn deinit(self: *SmallTree, allocator: std.mem.Allocator) void {
        for (self.states) |entity| {
            entity.deinit();
        }
        allocator.free(self.states);
    }

    pub fn incrementState(self: *SmallTree) void {
        self.state = (self.state + 1) % ResourcePaths.len;
    }

    pub fn draw(self: *SmallTree, pos: Pos) void {
        self.states[self.state].draw(pos);
    }

    pub fn getWidth(self: *SmallTree) i32 {
        return self.states[self.state].texture.width;
    }

    pub fn getHeight(self: *SmallTree) i32 {
        return self.states[self.state].texture.height;
    }
};
