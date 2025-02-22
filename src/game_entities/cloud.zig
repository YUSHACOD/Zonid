const std = @import("std");
const rl = @import("raylib");

const Drawable = @import("../utils/drawable.zig").Drawable;
const utils = @import("../utils/utils.zig");

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
