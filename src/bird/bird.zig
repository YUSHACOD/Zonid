const std = @import("std");
const rl = @import("raylib");

const Drawable = @import("../utils/utils.zig").Drawable;
const EntityError = @import("../utils/utils.zig").DrawableError;
const Pos = @import("../utils/utils.zig").Pos;

const ResourcePaths = [_][*:0]const u8{
    "./resources/images/bird/b_wing_down.png",
    "./resources/images/bird/b_wing_up.png",
};

pub const BirdStates = enum {
    Up,
    Down,

    pub fn idx(self: BirdStates) usize {
        return switch (self) {
            BirdStates.Up => 0,
            BirdStates.Down => 1,
        };
    }
};

pub const Bird = struct {
    pos: Pos = Pos{ .x = 0, .y = 0 },
    state: BirdStates,
    states: []Drawable,

    pub fn init(allocator: std.mem.Allocator) anyerror!Bird {
        const states = try allocator.alloc(Drawable, ResourcePaths.len);
        errdefer allocator.free(states);

        for (ResourcePaths, 0..) |resource, i| {
            states[i] = try Drawable.init(resource, null);
        }

        return Bird{
            .states = states,
            .state = BirdStates.Down,
        };
    }

    pub fn deinit(self: *Bird, allocator: std.mem.Allocator) void {
        for (self.states) |entity| {
            entity.deinit();
        }
        allocator.free(self.states);
    }

    pub fn draw(self: *Bird, pos: Pos) void {
        self.states[self.state.idx()].draw(pos);
    }

    pub fn getWidth(self: *Bird) i32 {
        return self.states[self.state.idx()].texture.width;
    }

    pub fn getHeight(self: *Bird) i32 {
        return self.states[self.state.idx()].texture.height;
    }
};
