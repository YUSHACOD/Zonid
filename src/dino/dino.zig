const std = @import("std");
const rl = @import("raylib");

const Drawable = @import("../utils/utils.zig").Drawable;
const EntityError = @import("../utils/utils.zig").DrawableError;
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
    pos: Pos,
    state: DinoStates,
    states: []Drawable,

    pub fn init(pos: Pos, allocator: std.mem.Allocator) anyerror!Dino {
        const states = try allocator.alloc(Drawable, ResourcePaths.len);
        errdefer allocator.free(states);

        for (ResourcePaths, 0..) |resource, i| {
            states[i] = try Drawable.init(resource, null);
        }

        return Dino{
            .pos = pos,
            .states = states,
            .state = DinoStates.Idle,
        };
    }

    pub fn deinit(self: *Dino, allocator: std.mem.Allocator) void {
        for (self.states) |entity| {
            entity.deinit();
        }
        allocator.free(self.states);
    }

    pub fn draw(self: *Dino, pos: Pos) void {
        self.states[self.state.idx()].draw(pos);
    }

    pub fn getWidth(self: *Dino) i32 {
        return self.states[self.state.idx()].texture.width;
    }

    pub fn getHeight(self: *Dino) i32 {
        return self.states[self.state.idx()].texture.height;
    }
};
