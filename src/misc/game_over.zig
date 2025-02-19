const std = @import("std");
const rl = @import("raylib");

const Drawable = @import("../utils/utils.zig").Drawable;
const EntityError = @import("../utils/utils.zig").DrawableError;
const Pos = @import("../utils/utils.zig").Pos;

const ResourcePath = "./resources/images/misc/game_over.png";

pub const GameOver = struct {
    pos: Pos = Pos{ .x = 0, .y = 0 },
    image: Drawable,

    pub fn init() anyerror!GameOver {
        return GameOver{
            .image = try Drawable.init(ResourcePath, null),
        };
    }

    pub fn deinit(self: *GameOver) void {
        self.image.deinit();
    }

    pub fn draw(self: *GameOver, pos: Pos) void {
        self.image.draw(pos);
    }

    pub fn getWidth(self: *GameOver) i32 {
        return self.image.texture.width;
    }

    pub fn getHeight(self: *GameOver) i32 {
        return self.image.texture.height;
    }
};
