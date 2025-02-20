const std = @import("std");
const rl = @import("raylib");

const Drawable = @import("../utils/drawable.zig").Drawable;
const Pos = @import("../utils/utils.zig").Pos;

const ResourcePath = "./resources/images/misc/ground.png";

pub const Ground = struct {
    pos: Pos = Pos.init(0, 0),
    scroll_speed: f32 = 3.0,
    width_start: f32 = 0.0,
    image: Drawable,
    width: i32,
    height: i32,

    pub fn init() anyerror!Ground {
        const image = try Drawable.init(ResourcePath, null);
        return Ground{
            .image = image,
            .width = image.texture.width,
            .height = image.texture.height,
        };
    }

    pub fn deinit(self: *Ground) void {
        self.image.deinit();
    }

    pub fn draw(self: *Ground, pos: Pos) void {
        self.image.draw(pos);
    }

    pub fn updateGroundScroll(self: *Ground) void {
        self.width_start -= self.scroll_speed;

        const ground_width: f32 = @floatFromInt(self.image.texture.width);
        if (self.width_start <= -ground_width) {
            self.width_start = 0;
        }
    }

    pub fn drawGroundScroll(self: *Ground) void {
        const dimensions: rl.Vector2 = self.image.getDimensions();

        self.image.texture.drawEx(rl.Vector2.init(self.width_start, 600.0), 0.0, 1, rl.Color.white);
        self.image.texture.drawEx(rl.Vector2.init(dimensions.x + self.width_start, 600.0), 0.0, 1, rl.Color.white);
    }
};
