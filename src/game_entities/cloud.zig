const std = @import("std");
const rl = @import("raylib");

const Drawable = @import("../utils/drawable.zig").Drawable;
const utils = @import("../utils/utils.zig");

pub const CloudPositions = [_]rl.Vector2{
    rl.Vector2{ .x = 80, .y = 400 },
    rl.Vector2{ .x = 280, .y = 280 },
    rl.Vector2{ .x = 140, .y = 180 },
    rl.Vector2{ .x = 700, .y = 200 },
    rl.Vector2{ .x = 525, .y = 40 },
    rl.Vector2{ .x = 1060, .y = 150 },
    rl.Vector2{ .x = 1370, .y = 300 },
    rl.Vector2{ .x = 1760, .y = 150 },
    rl.Vector2{ .x = 1600, .y = 75 },
};

const ResourcePath = "./resources/images/sky/cloud.png";

pub const Cloud = struct {
    image: Drawable,
    width: f32,
    height: f32,

    pub fn init() anyerror!Cloud {
        const image = try Drawable.init(ResourcePath, null);
        return Cloud{
            .image = image,
            .width = @floatFromInt(image.texture.width),
            .height = @floatFromInt(image.texture.height),
        };
    }

    pub fn deinit(self: *Cloud) void {
        self.image.deinit();
    }

    pub fn draw(self: *Cloud, pos: rl.Vector2) void {
        self.image.draw(pos);
    }
};
