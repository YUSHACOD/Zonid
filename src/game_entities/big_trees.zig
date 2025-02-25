const std = @import("std");
const rl = @import("raylib");

const Drawable = @import("../utils/drawable.zig").Drawable;
const utils = @import("../utils/utils.zig");

const Circle = @import("../game/obstacle.zig").Circle;

const ResourcePaths = [_][*:0]const u8{
    "./resources/images/big_tree/big_tree_1.png",
    "./resources/images/big_tree/big_tree_2.png",
    "./resources/images/big_tree/big_tree_3.png",
    "./resources/images/big_tree/big_tree_4.png",
    "./resources/images/big_tree/big_tree_5.png",
};

pub const Len: usize = ResourcePaths.len - 1;

pub const BigTree = struct {
    pos: rl.Vector2,
    state: usize = 0,

    pub fn init(
        max_width: f32,
        resource_position: usize,
        ground_position: f32,
    ) BigTree {
        std.debug.print("max_width: {} \n", .{max_width});

        return BigTree{
            .pos = rl.Vector2{
                .x = max_width,
                .y = ground_position,
            },
            .state = resource_position,
        };
    }

    pub fn getCircle(self: BigTree, big_tree_asset: *BigTreesAsset) Circle {
        const width = big_tree_asset.width(self.state);
        const height = big_tree_asset.height(self.state);

        const adjusted_pos = utils.adjustPosWidth(
            self.pos,
            width,
            height,
        );

        const adjust_circle: rl.Vector2 = utils.adjustPosCircle(
            adjusted_pos,
            width,
            height,
        );

        const radius: f32 = if (width >= height)
            height
        else
            width;

        return Circle{
            .center = adjust_circle,
            .radius = @divFloor(radius, 2),
        };
    }

    pub fn updateAnimation(self: *BigTree, scroll_speed: f32) void {
        self.pos.x -= scroll_speed;
    }

    pub fn draw(self: *BigTree, big_tree_asset: *BigTreesAsset) void {
        const width: f32 = big_tree_asset.width(self.state);
        const height: f32 = big_tree_asset.height(self.state);

        const adjusted_pos = utils.adjustPosWidth(
            self.pos,
            width,
            height,
        );

        // const adjust_circle: rl.Vector2 = utils.adjustPosCircle(
        //     adjusted_pos,
        //     width,
        //     height,
        // );
        //
        // const radius: f32 = if (width >= height)
        //     height
        // else
        //     width;
        //
        // rl.drawCircleV(adjust_circle, @divFloor(radius, 2), rl.Color.sky_blue);

        big_tree_asset.drawables[self.state].draw(adjusted_pos);
    }
};

pub const BigTreesAsset = struct {
    drawables: []Drawable,

    pub fn init(allocator: std.mem.Allocator) anyerror!BigTreesAsset {
        const drawables = try allocator.alloc(Drawable, ResourcePaths.len);
        errdefer allocator.free(drawables);

        for (ResourcePaths, 0..) |resource, i| {
            drawables[i] = try Drawable.init(resource, null);
        }

        return BigTreesAsset{
            .drawables = drawables,
        };
    }

    pub fn deinit(self: *BigTreesAsset, allocator: std.mem.Allocator) void {
        for (self.drawables) |entity| {
            entity.deinit();
        }
        allocator.free(self.drawables);
    }

    pub fn width(self: *BigTreesAsset, state: usize) f32 {
        return @floatFromInt(self.drawables[state].texture.width);
    }

    pub fn height(self: *BigTreesAsset, state: usize) f32 {
        return @floatFromInt(self.drawables[state].texture.height);
    }

    pub fn draw(self: *BigTreesAsset, pos: rl.Vector2) void {
        self.drawables[self.state].draw(pos);
    }
};
