const std = @import("std");
const rl = @import("raylib");

const Drawable = @import("../utils/drawable.zig").Drawable;
const Pos = @import("../utils/utils.zig").Pos;

const ResourcePath = "./resources/images/misc/game_over.png";

pub const GameOverTitle = struct {
    pos: Pos = Pos.init(0, 0),
    image: Drawable,
    width: i32,
    height: i32,

    pub fn init() anyerror!GameOverTitle {
        const image = try Drawable.init(ResourcePath, null);
        return GameOverTitle{
            .image = image,
            .width = image.texture.width,
            .height = image.texture.height,
        };
    }

    pub fn deinit(self: *GameOverTitle) void {
        self.image.deinit();
    }

    pub fn draw(self: *GameOverTitle, pos: Pos) void {
        self.image.draw(pos);
    }

    pub fn drawSelf(self: *GameOverTitle) void {
        self.drawables[self.state].draw(self.pos);
    }
};
