const std = @import("std");
const rl = @import("raylib");

const Drawable = @import("../utils/drawable.zig").Drawable;
const Pos = @import("../utils/utils.zig").Pos;

const ResourcePaths = [_][*:0]const u8{
    "./resources/images/moons/moon_1.png",
    "./resources/images/moons/moon_2.png",
    "./resources/images/moons/moon_3.png",
    "./resources/images/moons/moon_4.png",
    "./resources/images/moons/moon_5.png",
    "./resources/images/moons/moon_6.png",
    "./resources/images/moons/moon_7.png",
};

pub const Moon = struct {
    pos: Pos = Pos.init(0, 0),
    drawables: []Drawable,
    state: usize = 0,
    width: i32,
    height: i32,

    pub fn init(allocator: std.mem.Allocator) anyerror!Moon {
        const drawables = try allocator.alloc(Drawable, ResourcePaths.len);
        errdefer allocator.free(drawables);

        for (ResourcePaths, 0..) |resource, i| {
            drawables[i] = try Drawable.init(resource, null);
        }

        return Moon{
            .drawables = drawables,
            .width = drawables[0].texture.width,
            .height = drawables[0].texture.height,
        };
    }

    pub fn deinit(self: *Moon, allocator: std.mem.Allocator) void {
        for (self.drawables) |entity| {
            entity.deinit();
        }
        allocator.free(self.drawables);
    }

    pub fn incrementState(self: *Moon) void {
        self.state = (self.state + 1) % ResourcePaths.len;
    }

    pub fn draw(self: *Moon, pos: Pos) void {
        self.drawables[self.state].draw(pos);
    }

    pub fn drawSelf(self: *Moon) void {
        self.drawables[self.state].draw(self.pos);
    }
};
