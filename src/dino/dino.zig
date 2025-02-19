const std = @import("std");
const rl = @import("raylib");

const Entity = @import("../utils/utils.zig").Entity;
const EntityError = @import("../utils/utils.zig").EntityError;
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

pub const Dino = struct {
    pos: Pos,
    textures: []Entity,

    pub fn init(pos: Pos, allocator: std.mem.Allocator) anyerror!Dino {
        const textures = try allocator.alloc(Entity, ResourcePaths.len);
        errdefer allocator.free(textures);

        for (ResourcePaths, 0..) |resource, i| {
            textures[i] = try Entity.init(resource, null);
        }

        return Dino{
            .pos = pos,
            .textures = textures,
        };
    }

    pub fn deinit(self: *Dino, allocator: std.mem.Allocator) void {
        for (self.textures) |entity| {
            entity.deinit();
        }
        allocator.free(self.textures);
    }
};
