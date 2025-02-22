const std = @import("std");
const rl = @import("raylib");

const Drawable = @import("../utils/drawable.zig").Drawable;
const utils = @import("../utils/utils.zig");

const ResourcePath = "./resources/images/misc/game_over.png";

pub const GameOverTitle = struct {
    pos: rl.Vector2 = rl.Vector2.init(0, 0),
    image: Drawable,
    width: f32,
    height: f32,

    pub fn init() anyerror!GameOverTitle {
        const image = try Drawable.init(ResourcePath, null);
        return GameOverTitle{
            .image = image,
            .width = @floatFromInt(image.texture.width),
            .height = @floatFromInt(image.texture.height),
        };
    }

    pub fn deinit(self: *GameOverTitle) void {
        self.image.deinit();
    }

    pub fn draw(self: *GameOverTitle, pos: rl.Vector2) void {
        self.image.draw(pos);
    }

    pub fn drawSelf(self: *GameOverTitle) void {
        self.drawables[self.state].draw(self.pos);
    }
};
