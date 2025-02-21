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
    Running,
    Crawling,
    Shocked,
    Blind,

    pub fn updateIndex(self: DinoStates) usize {
        const result: usize = switch (self) {
            DinoStates.Idle => 0,
            DinoStates.Running => 1,
            DinoStates.Crawling => 3,
            DinoStates.Shocked => 5,
            DinoStates.Blind => 7,
        };

        return result;
    }
};

pub const Dino = struct {
    pos: Pos = Pos{ .x = 0, .y = 0 },
    state: DinoStates,
    state_idx: usize = 0,
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

    pub fn changeState(self: *Dino, state: DinoStates) void {
        self.state = state;
        self.state_idx = state.updateIndex();
    }

    pub fn incrementState(self: *Dino) void {
        switch (self.state) {
            DinoStates.Idle => self.state_idx = 0,
            DinoStates.Running => self.state_idx = if (self.state_idx == 1) 2 else 1,
            DinoStates.Crawling => self.state_idx = if (self.state_idx == 3) 4 else 3,
            DinoStates.Shocked => self.state_idx = if (self.state_idx == 5) 6 else 5,
            DinoStates.Blind => self.state_idx = 7,
        }
    }

    pub fn draw(self: *Dino, pos: Pos) void {
        const current_state = self.state_idx;

        self.drawables[current_state].draw(pos);
    }

    pub fn drawSelf(self: *Dino) void {
        const current_state = self.state_idx;
        const mid_adjustedPos: Pos = self.pos.adjustPosMiddle(self.width, self.height);
        self.drawables[current_state].draw(mid_adjustedPos);
    }
};
