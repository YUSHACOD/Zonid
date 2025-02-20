const std = @import("std");
const rl = @import("raylib");

const Drawable = @import("../utils/drawable.zig").Drawable;
const Pos = @import("../utils/utils.zig").Pos;

const ResourcePath = "./resources/images/misc/hi.png";

pub const HiScoreTitle = struct {
    pos: Pos = Pos.init(0, 0),
    image: Drawable,
    width: i32,
    height: i32,

    pub fn init() anyerror!HiScoreTitle {
        const image = try Drawable.init(ResourcePath, null);
        return HiScoreTitle{
            .image = image,
            .width = image.texture.width,
            .height = image.texture.height,
        };
    }

    pub fn deinit(self: *HiScoreTitle) void {
        self.image.deinit();
    }

    pub fn draw(self: *HiScoreTitle, pos: Pos) void {
        self.image.draw(pos);
    }

    pub fn drawSelf(self: *HiScoreTitle) void {
        self.drawables[self.state].draw(self.pos);
    }
};
