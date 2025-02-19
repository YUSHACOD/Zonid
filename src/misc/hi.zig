const std = @import("std");
const rl = @import("raylib");

const Drawable = @import("../utils/utils.zig").Drawable;
const EntityError = @import("../utils/utils.zig").DrawableError;
const Pos = @import("../utils/utils.zig").Pos;

const ResourcePath = "./resources/images/misc/hi.png";

pub const Hi = struct {
    pos: Pos = Pos{ .x = 0, .y = 0 },
    image: Drawable,

    pub fn init() anyerror!Hi {
        return Hi{
            .image = try Drawable.init(ResourcePath, null),
        };
    }

    pub fn deinit(self: *Hi) void {
        self.image.deinit();
    }

    pub fn draw(self: *Hi, pos: Pos) void {
        self.image.draw(pos);
    }

    pub fn getWidth(self: *Hi) i32 {
        return self.image.texture.width;
    }

    pub fn getHeight(self: *Hi) i32 {
        return self.image.texture.height;
    }
};
