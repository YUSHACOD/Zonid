const std = @import("std");
const rl = @import("raylib");

const Drawable = @import("../utils/drawable.zig").Drawable;
const Pos = @import("../utils/utils.zig").Pos;

const ResourcePaths = [_][*:0]const u8{
    "./resources/images/nums/0.png",
    "./resources/images/nums/1.png",
    "./resources/images/nums/2.png",
    "./resources/images/nums/3.png",
    "./resources/images/nums/4.png",
    "./resources/images/nums/5.png",
    "./resources/images/nums/6.png",
    "./resources/images/nums/7.png",
    "./resources/images/nums/8.png",
    "./resources/images/nums/9.png",
};

const AsciiNumOffset: i32 = 48;

pub const Nums = struct {
    drawables: []Drawable,
    width: i32,
    height: i32,

    pub fn init(allocator: std.mem.Allocator) anyerror!Nums {
        const drawables = try allocator.alloc(Drawable, ResourcePaths.len);
        errdefer allocator.free(drawables);

        for (ResourcePaths, 0..) |resource, i| {
            drawables[i] = try Drawable.init(resource, null);
        }

        return Nums{
            .drawables = drawables,
            .width = drawables[0].texture.width,
            .height = drawables[0].texture.height,
        };
    }

    pub fn deinit(self: *Nums, allocator: std.mem.Allocator) void {
        for (self.drawables) |entity| {
            entity.deinit();
        }
        allocator.free(self.drawables);
    }

    pub fn draw(self: *const Nums, pos: Pos, char: u8) void {
        if (std.ascii.isDigit(char)) {
            const idx: usize = @intCast(char - AsciiNumOffset);

            self.drawables[idx].draw(pos);
        } else {
            std.debug.print("risky char bastard: {} \n", .{char});
        }
    }
};
