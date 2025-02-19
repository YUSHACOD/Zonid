const std = @import("std");
const rl = @import("raylib");

const Drawable = @import("../utils/utils.zig").Drawable;
const EntityError = @import("../utils/utils.zig").DrawableError;
const Pos = @import("../utils/utils.zig").Pos;

const ResourcePath = "./resources/images/sky/cloud.png";

pub const Cloud = struct {
    pos: Pos = Pos{ .x = 0, .y = 0 },
    image: Drawable,

    pub fn init() anyerror!Cloud {
        return Cloud{
            .image = try Drawable.init(ResourcePath, null),
        };
    }

    pub fn deinit(self: *Cloud) void {
        self.image.deinit();
    }

    pub fn draw(self: *Cloud, pos: Pos) void {
        self.image.draw(pos);
    }

    pub fn getWidth(self: *Cloud) i32 {
        return self.image.texture.width;
    }

    pub fn getHeight(self: *Cloud) i32 {
        return self.image.texture.height;
    }
};
