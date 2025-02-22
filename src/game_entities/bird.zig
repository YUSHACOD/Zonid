const std = @import("std");
const rl = @import("raylib");

const Drawable = @import("../utils/drawable.zig").Drawable;
const utils = @import("../utils/utils.zig");

const ResourcePaths = [_][*:0]const u8{
    "./resources/images/bird/b_wing_down.png",
    "./resources/images/bird/b_wing_up.png",
};

pub const Bird = struct {
    assets: *BirdAsset,
    state: usize = 0,

    pub fn init(bird_asset: *BirdAsset) Bird {
        return Bird{
            .assets = bird_asset,
        };
    }

    pub fn incrementState(self: *Bird) void {
        self.assets.drawables[self.state] = (self.state + 1) % ResourcePaths.len;
    }

    pub fn draw(self: *Bird, pos: rl.Vector2) void {
        self.assets.drawables[self.state].draw(pos);
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
