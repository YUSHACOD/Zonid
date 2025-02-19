const std = @import("std");
const rl = @import("raylib");

const Drawable = @import("../utils/utils.zig").Drawable;
const EntityError = @import("../utils/utils.zig").DrawableError;
const Pos = @import("../utils/utils.zig").Pos;

const ResourcePath = "./resources/images/misc/ground.png";

pub const Ground = struct {
    pos: Pos = Pos{ .x = 0, .y = 0 },
    scroll_speed: f32 = 3.0,
    width_start: f32 = 0.0,
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

    pub fn groundScrollUpdate(self: *Ground) void {
        self.width_start -= self.scroll_speed;

        const ground_width: f32 = @floatFromInt(self.image.texture.width);
        if (self.width_start <= -ground_width) {
            self.width_start = 0;
        }
    }

    pub fn groundScrollDraw(self: *Ground) void {
        const dimensions: rl.Vector2 = self.image.getDimensions();

        self.image.texture.drawEx(rl.Vector2.init(self.width_start, 600.0), 0.0, 1, rl.Color.white);
        self.image.texture.drawEx(rl.Vector2.init(dimensions.x + self.width_start, 600.0), 0.0, 1, rl.Color.white);
    }

    pub fn getWidth(self: *Ground) i32 {
        return self.image.texture.width;
    }

    pub fn getHeight(self: *Ground) i32 {
        return self.image.texture.height;
    }
};
