const std = @import("std");
const rl = @import("raylib");

const Dino = @import("../dino/dino.zig").Dino;

pub const DinoGameState = struct {
    dino: Dino,

    pub fn init() DinoGameState {}
};
