const std = @import("std");
const rl = @import("raylib");

const Drawable = @import("../utils/drawable.zig").Drawable;
const utils = @import("../utils/utils.zig");

const ResourcePath = "./resources/images/misc/ground.png";

const Direction: f32 = @import("../game/game_state.zig").Direction;

const ScrollSpeed: f32 = 6.0;

pub const Ground = struct {
    pos: rl.Vector2 = rl.Vector2.init(0, 0),
    scroll_speed: f32 = Direction * ScrollSpeed,
    width_start: f32 = 0.0,
    image: Drawable,
    width: f32,
    height: f32,

    pub fn init() anyerror!Ground {
        const image = try Drawable.init(ResourcePath, null);
        return Ground{
            .image = image,
            .width = @floatFromInt(image.texture.width),
            .height = @floatFromInt(image.texture.height),
        };
    }

    pub fn deinit(self: *Ground) void {
        self.image.deinit();
    }

    pub fn draw(self: *Ground, pos: rl.Vector2) void {
        self.image.draw(pos);
    }

    pub fn updateGroundScroll(self: *Ground) void {
        self.width_start -= self.scroll_speed;

        const ground_width: f32 = @floatFromInt(self.image.texture.width);
        if (self.width_start <= -ground_width or self.width_start >= ground_width) {
            self.width_start = 0;
        }
    }

    pub fn drawGroundScroll(self: *Ground) void {
        const dimensions: rl.Vector2 = self.image.getDimensions();

        self.image.texture.drawEx(rl.Vector2.init(self.width_start, 600.0), 0.0, 1, rl.Color.white);
        self.image.texture.drawEx(rl.Vector2.init((Direction * dimensions.x) + self.width_start, 600.0), 0.0, 1, rl.Color.white);
    }
};
