const std = @import("std");
const rl = @import("raylib");

const Drawable = @import("../utils/drawable.zig").Drawable;
const utils = @import("../utils/utils.zig");

const Circle = @import("../game/obstacle.zig").Circle;

const ResourcePaths = [_][*:0]const u8{
    "./resources/images/bird/b_wing_down.png",
    "./resources/images/bird/b_wing_up.png",
};

const BirdAnimationSpeed: f32 = 0.1;

pub const ObstaclePositions = [_]f32{ 500, 525, 580 };

pub const Len: usize = ObstaclePositions.len - 1;

pub const Bird = struct {
    pos: rl.Vector2,
    state_change_time: f32 = 0.0,
    state: usize = 0,

    pub fn init(
        max_width: f32,
        obstacle_position: usize,
    ) Bird {
        std.debug.print("max_width: {} \n", .{max_width});

        return Bird{
            .pos = rl.Vector2{
                .x = max_width,
                .y = ObstaclePositions[obstacle_position],
            },
        };
    }

    pub fn getCircle(self: Bird, bird_asset: *const BirdAsset) Circle {
        const adjusted_pos = utils.adjustPosHeight(
            self.pos,
            bird_asset.height,
        );

        const adjust_circle: rl.Vector2 = utils.adjustPosCircle(
            adjusted_pos,
            bird_asset.width,
            bird_asset.height,
        );

        const radius: f32 = if (bird_asset.width >= bird_asset.height)
            bird_asset.height
        else
            bird_asset.width;

        return Circle{
            .center = adjust_circle,
            .radius = @divFloor(radius, 2),
        };
    }

    pub fn incrementState(self: *Bird) void {
        self.state = (self.state + 1) % ResourcePaths.len;
    }

    pub fn updateAnimation(self: *Bird, scroll_speed: f32) void {
        self.state_change_time += rl.getFrameTime();

        if (self.state_change_time >= BirdAnimationSpeed) {
            self.incrementState();
            self.state_change_time = 0.0;
        }

        self.pos.x -= scroll_speed;
    }

    pub fn draw(self: *Bird, bird_asset: *BirdAsset) void {
        const adjusted_pos = utils.adjustPosHeight(
            self.pos,
            bird_asset.height,
        );

        // const adjust_circle: rl.Vector2 = utils.adjustPosCircle(adjusted_pos, bird_asset.width, bird_asset.height);
        //
        // const radius: f32 = if (bird_asset.width >= bird_asset.height) bird_asset.height else bird_asset.width;
        // rl.drawCircleV(adjust_circle, @divFloor(radius, 2), rl.Color.sky_blue);

        bird_asset.drawables[self.state].draw(adjusted_pos);
    }
};

pub const BirdAsset = struct {
    drawables: []Drawable,
    state: usize = 0,
    width: f32,
    height: f32,

    pub fn init(allocator: std.mem.Allocator) anyerror!BirdAsset {
        const drawables = try allocator.alloc(Drawable, ResourcePaths.len);
        errdefer allocator.free(drawables);

        for (ResourcePaths, 0..) |resource, i| {
            drawables[i] = try Drawable.init(resource, null);
        }

        return BirdAsset{
            .drawables = drawables,
            .width = @floatFromInt(drawables[0].texture.width),
            .height = @floatFromInt(drawables[0].texture.height),
        };
    }

    pub fn deinit(self: *BirdAsset, allocator: std.mem.Allocator) void {
        for (self.drawables) |entity| {
            entity.deinit();
        }
        allocator.free(self.drawables);
    }

    pub fn incrementState(self: *BirdAsset) void {
        self.state = (self.state + 1) % ResourcePaths.len;
    }

    pub fn draw(self: *BirdAsset, pos: rl.Vector2) void {
        self.drawables[self.state].draw(pos);
    }
};
