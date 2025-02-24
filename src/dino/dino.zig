const std = @import("std");
const rl = @import("raylib");

const Drawable = @import("../utils/drawable.zig").Drawable;
const utils = @import("../utils/utils.zig");

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

pub const GroundPos: f32 = 620;

const DinoPos: rl.Vector2 = utils.init(380, 620);
const DinoAnimationSpeed: f32 = 0.1;

const Gravity: rl.Vector2 = rl.Vector2.init(0, 2000);
const JumpVelocity: rl.Vector2 = rl.Vector2.init(0, -900);

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
    pos: rl.Vector2 = DinoPos,
    state: DinoStates,
    state_idx: usize = 0,
    drawables: []Drawable,
    state_change_time: f32 = 0.0,
    velocity: rl.Vector2 = rl.Vector2.init(0, 0),
    is_jumping: bool = false,
    width: f32,
    height: f32,

    pub fn init(allocator: std.mem.Allocator) anyerror!Dino {
        const drawables = try allocator.alloc(Drawable, ResourcePaths.len);
        errdefer allocator.free(drawables);

        for (ResourcePaths, 0..) |resource, i| {
            drawables[i] = try Drawable.init(resource, null);
        }

        return Dino{
            .drawables = drawables,
            .state = DinoStates.Idle,
            .width = @floatFromInt(drawables[0].texture.width),
            .height = @floatFromInt(drawables[0].texture.height),
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
        self.width = @floatFromInt(self.drawables[self.state_idx].texture.width);
        self.height = @floatFromInt(self.drawables[self.state_idx].texture.height);
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

    pub fn getRec(self: *Dino) rl.Rectangle {
        const mid_adjustedPos: rl.Vector2 = utils.adjustPosWidth(
            self.pos,
            self.width,
            self.height,
        );

        return rl.Rectangle.init(
            mid_adjustedPos.x,
            mid_adjustedPos.y,
            self.width,
            self.height,
        );
    }

    pub fn updateAnimation(self: *Dino) void {
        const time_elapsed: f32 = rl.getFrameTime();

        if ((self.state != DinoStates.Idle or
            self.is_jumping) and
            self.state != DinoStates.Shocked)
        {
            // State Change
            // -------------------------------------------
            self.state_change_time += rl.getFrameTime();
            if (self.state_change_time >= DinoAnimationSpeed) {
                self.incrementState();
                self.state_change_time = 0.0;
            }
            // -------------------------------------------

            // Position Update
            // -------------------------------------------
            // Gravity
            const displacement: rl.Vector2 = utils.displacement(self.velocity, Gravity, time_elapsed);
            // New Velocity
            self.velocity = utils.newVelocity(self.velocity, Gravity, time_elapsed);
            self.pos = self.pos.add(displacement);
            // -------------------------------------------

            // Ground Collision
            // -------------------------------------------
            if (self.pos.y >= DinoPos.y) {
                self.pos.y = DinoPos.y;
                self.velocity = rl.Vector2.init(0, 0);
                self.is_jumping = false;

                if (self.state != DinoStates.Running and self.state != DinoStates.Crawling) {
                    self.changeState(DinoStates.Running);
                }
            }
            // -------------------------------------------

            // Jump
            // -------------------------------------------
            if (rl.isKeyPressed(rl.KeyboardKey.space) and !self.is_jumping) {
                self.is_jumping = true;
                self.velocity = JumpVelocity;
            }

            if (self.pos.y != DinoPos.y and self.state != DinoStates.Idle) {
                self.changeState(DinoStates.Idle);
            }
            // -------------------------------------------

            // Crawling
            // -------------------------------------------
            if (!self.is_jumping) {
                if (rl.isKeyDown(rl.KeyboardKey.down)) {
                    if (self.state != DinoStates.Crawling) {
                        self.changeState(DinoStates.Crawling);
                    }
                }

                if (rl.isKeyReleased(rl.KeyboardKey.down) and self.state == DinoStates.Crawling) {
                    self.changeState(DinoStates.Running);
                }
            }
            // -------------------------------------------
        }
    }

    pub fn draw(self: *Dino, pos: rl.Vector2) void {
        const current_state = self.state_idx;

        self.drawables[current_state].draw(pos);
    }

    pub fn drawSelf(self: *Dino) void {
        const current_state = self.state_idx;
        const mid_adjustedPos: rl.Vector2 = utils.adjustPosWidth(self.pos, self.width, self.height);

        self.drawables[current_state].draw(mid_adjustedPos);
    }
};
