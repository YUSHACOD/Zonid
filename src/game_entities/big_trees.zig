const std = @import("std");
const rl = @import("raylib");

const Drawable = @import("../utils/drawable.zig").Drawable;
const Pos = @import("../utils/utils.zig").Pos;

const ResourcePaths = [_][*:0]const u8{
    "./resources/images/big_tree/big_tree_1.png",
    "./resources/images/big_tree/big_tree_2.png",
    "./resources/images/big_tree/big_tree_3.png",
    "./resources/images/big_tree/big_tree_4.png",
    "./resources/images/big_tree/big_tree_5.png",
};

pub const BigTrees = struct {
    drawables: []Drawable,
    state: usize = 0,
    width: i32,
    height: i32,

    pub fn init(allocator: std.mem.Allocator) anyerror!BigTrees {
        const drawables = try allocator.alloc(Drawable, ResourcePaths.len);
        errdefer allocator.free(drawables);

        for (ResourcePaths, 0..) |resource, i| {
            drawables[i] = try Drawable.init(resource, null);
        }

        return BigTrees{
            .drawables = drawables,
            .width = drawables[0].texture.width,
            .height = drawables[0].texture.height,
        };
    }

    pub fn deinit(self: *BigTrees, allocator: std.mem.Allocator) void {
        for (self.drawables) |entity| {
            entity.deinit();
        }
        allocator.free(self.drawables);
    }

    pub fn incrementState(self: *BigTrees) void {
        self.state = (self.state + 1) % ResourcePaths.len;
    }

    pub fn draw(self: *BigTrees, pos: Pos) void {
        self.drawables[self.state].draw(pos);
    }
};
