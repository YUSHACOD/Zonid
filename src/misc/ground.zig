const std = @import("std");
const rl = @import("raylib");

const Drawable = @import("../utils/utils.zig").Drawable;
const EntityError = @import("../utils/utils.zig").DrawableError;
const Pos = @import("../utils/utils.zig").Pos;

const ResourcePath = "./resources/images/misc/ground.png";

pub const Ground = struct {
    pos: Pos = Pos{ .x = 0, .y = 0 },
    image: Drawable,

    pub fn init() anyerror!Ground {
        return Ground{
            .image = try Drawable.init(ResourcePath, null),
        };
    }

    pub fn deinit(self: *Ground) void {
        self.image.deinit();
    }

    pub fn draw(self: *Ground, pos: Pos) void {
        self.image.draw(pos);
    }

    pub fn getWidth(self: *Ground) i32 {
        return self.image.texture.width;
    }

    pub fn getHeight(self: *Ground) i32 {
        return self.image.texture.height;
    }
};
