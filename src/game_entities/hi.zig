const std = @import("std");
const rl = @import("raylib");

const Drawable = @import("../utils/drawable.zig").Drawable;
const Pos = @import("../utils/utils.zig").Pos;

const ResourcePath = "./resources/images/misc/hi.png";

pub const HiScoreTitle = struct {
    pos: Pos,
    image: Drawable,
    width: i32,
    height: i32,

    pub fn init(pos: Pos) anyerror!HiScoreTitle {
        const image = try Drawable.init(ResourcePath, null);
        return HiScoreTitle{
            .pos = pos,
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
        const mid_adjustedPos: Pos = self.pos.adjustPosMiddle(self.width, self.height);
        self.image.draw(mid_adjustedPos);
    }
};
