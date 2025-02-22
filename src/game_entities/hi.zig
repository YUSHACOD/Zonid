const std = @import("std");
const rl = @import("raylib");

const Drawable = @import("../utils/drawable.zig").Drawable;
const utils = @import("../utils/utils.zig");

const ResourcePath = "./resources/images/misc/hi.png";

pub const HiScoreTitle = struct {
    pos: rl.Vector2,
    image: Drawable,
    width: f32,
    height: f32,

    pub fn init(pos: rl.Vector2) anyerror!HiScoreTitle {
        const image = try Drawable.init(ResourcePath, null);
        return HiScoreTitle{
            .pos = pos,
            .image = image,
            .width = @floatFromInt(image.texture.width),
            .height = @floatFromInt(image.texture.height),
        };
    }

    pub fn deinit(self: *HiScoreTitle) void {
        self.image.deinit();
    }

    pub fn draw(self: *HiScoreTitle, pos: rl.Vector2) void {
        self.image.draw(pos);
    }

    pub fn drawSelf(self: *HiScoreTitle) void {
        const mid_adjustedPos: rl.Vector2 = utils.adjustPosMiddle(self.pos, self.width, self.height);
        self.image.draw(mid_adjustedPos);
    }
};
