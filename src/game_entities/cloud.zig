const std = @import("std");
const rl = @import("raylib");

const Drawable = @import("../utils/drawable.zig").Drawable;
const Pos = @import("../utils/utils.zig").Pos;

const ResourcePath = "./resources/images/sky/cloud.png";

pub const Cloud = struct {
    image: Drawable,
    width: i32,
    height: i32,

    pub fn init() anyerror!Cloud {
        const image = try Drawable.init(ResourcePath, null);
        return Cloud{
            .image = image,
            .width = image.texture.width,
            .height = image.texture.height,
        };
    }

    pub fn deinit(self: *Cloud) void {
        self.image.deinit();
    }

    pub fn draw(self: *Cloud, pos: Pos) void {
        self.image.draw(pos);
    }
};
