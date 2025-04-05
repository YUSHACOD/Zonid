const std = @import("std");
const rl = @import("raylib");

const Drawable = @import("../utils/drawable.zig").Drawable;
const utils = @import("../utils/utils.zig");

const Circle = @import("../game/obstacle.zig").Circle;

const ResourcePaths = [_][:0]const u8{
    "./resources/images/small_tree/small_tree_1.png",
    "./resources/images/small_tree/small_tree_2.png",
    "./resources/images/small_tree/small_tree_3.png",
    "./resources/images/small_tree/small_tree_4.png",
    "./resources/images/small_tree/small_tree_5.png",
    "./resources/images/small_tree/small_tree_6.png",
};

pub const Len: usize = ResourcePaths.len - 1;

pub const SmallTree = struct {
    pos: rl.Vector2,
    state: usize = 0,

    pub fn init(
        max_width: f32,
        resource_position: usize,
        ground_position: f32,
    ) SmallTree {
        std.debug.print("max_width: {} \n", .{max_width});

        return SmallTree{
            .pos = rl.Vector2{
                .x = max_width,
                .y = ground_position,
            },
            .state = resource_position,
        };
    }

    pub fn getCircle(self: SmallTree, small_tree_asset: *SmallTreesAsset) Circle {
        const adjusted_pos = utils.adjustPosWidth(
            self.pos,
            small_tree_asset.width,
            small_tree_asset.height,
        );

        const adjust_circle: rl.Vector2 = utils.adjustPosCircle(
            adjusted_pos,
            small_tree_asset.width,
            small_tree_asset.height,
        );

        const radius: f32 = if (small_tree_asset.width >= small_tree_asset.height)
            small_tree_asset.height
        else
            small_tree_asset.width;

        return Circle{
            .center = adjust_circle,
            .radius = @divFloor(radius, 2),
        };
    }

    pub fn updateAnimation(self: *SmallTree, scroll_speed: f32) void {
        self.pos.x -= scroll_speed;
    }

    pub fn draw(self: *SmallTree, small_tree_asset: *SmallTreesAsset) void {
        const adjusted_pos = utils.adjustPosWidth(
            self.pos,
            small_tree_asset.width,
            small_tree_asset.height,
        );

        // const adjust_circle: rl.Vector2 = utils.adjustPosCircle(
        //     adjusted_pos,
        //     small_tree_asset.width,
        //     small_tree_asset.height,
        // );
        //
        // const radius: f32 = if (small_tree_asset.width >= small_tree_asset.height)
        //     small_tree_asset.height
        // else
        //     small_tree_asset.width;
        //
        // rl.drawCircleV(adjust_circle, @divFloor(radius, 2), rl.Color.sky_blue);

        small_tree_asset.drawables[self.state].draw(adjusted_pos);
    }
};

pub const SmallTreesAsset = struct {
    drawables: []Drawable,
    width: f32,
    height: f32,

    pub fn init(allocator: std.mem.Allocator) anyerror!SmallTreesAsset {
        const drawables = try allocator.alloc(Drawable, ResourcePaths.len);
        errdefer allocator.free(drawables);

        for (ResourcePaths, 0..) |resource, i| {
            drawables[i] = try Drawable.init(resource, null);
        }

        return SmallTreesAsset{
            .drawables = drawables,
            .width = @floatFromInt(drawables[0].texture.width),
            .height = @floatFromInt(drawables[0].texture.height),
        };
    }

    pub fn deinit(self: *SmallTreesAsset, allocator: std.mem.Allocator) void {
        for (self.drawables) |entity| {
            entity.deinit();
        }
        allocator.free(self.drawables);
    }

    pub fn draw(self: *SmallTreesAsset, pos: rl.Vector2) void {
        self.drawables[self.state].draw(pos);
    }
};
