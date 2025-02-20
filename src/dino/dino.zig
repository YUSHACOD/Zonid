const std = @import("std");
const rl = @import("raylib");

const Drawable = @import("../utils/drawable.zig").Drawable;
const Pos = @import("../utils/utils.zig").Pos;

const ResourcePaths = [_][*:0]const u8{
    "./resources/images/dinos/dino_idle.png",
    "./resources/images/dinos/dino_run1.png",
    "./resources/images/dinos/dino_run2.png",
    "./resources/images/dinos/dino_crawl1.png",
    "./resources/images/dinos/dino_crawl2.png",
    "./resources/images/dinos/dino_shocked1.png",
    "./resources/images/dinos/dino_shocked2.png",
    "./resources/images/dinos/dino_blind.png",
};

pub const DinoStates = enum {
    Idle,
    Run1,
    Run2,
    Crawl1,
    Crawl2,
    Shocked1,
    Shocked2,
    Blind,

    pub fn idx(self: DinoStates) usize {
        return switch (self) {
            DinoStates.Idle => 0,
            DinoStates.Run1 => 1,
            DinoStates.Run2 => 2,
            DinoStates.Crawl1 => 3,
            DinoStates.Crawl2 => 4,
            DinoStates.Shocked1 => 5,
            DinoStates.Shocked2 => 6,
            DinoStates.Blind => 7,
        };
    }
};

pub const Dino = struct {
    pos: Pos = Pos{ .x = 0, .y = 0 },
    state: DinoStates,
    drawables: []Drawable,
    width: i32,
    height: i32,

    pub fn init(allocator: std.mem.Allocator) anyerror!Dino {
        const drawables = try allocator.alloc(Drawable, ResourcePaths.len);
        errdefer allocator.free(drawables);

        for (ResourcePaths, 0..) |resource, i| {
            drawables[i] = try Drawable.init(resource, null);
        }

        return Dino{
            .drawables = drawables,
            .state = DinoStates.Idle,
            .width = drawables[0].texture.width,
            .height = drawables[0].texture.height,
        };
    }

    pub fn deinit(self: *Dino, allocator: std.mem.Allocator) void {
        for (self.drawables) |entity| {
            entity.deinit();
        }
        allocator.free(self.drawables);
    }

    pub fn draw(self: *Dino, pos: Pos) void {
        const current_state = self.state.idx();

        self.drawables[current_state].draw(pos);
    }

    pub fn drawSelf(self: *Dino) void {
        const current_state = self.state.idx();
        const mid_adjustedPos: Pos = self.pos.adjustPosMiddle(self.width, self.height);
        self.drawables[current_state].draw(mid_adjustedPos);
    }
};
