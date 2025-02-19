const std = @import("std");
const rl = @import("raylib");

pub const Pos = struct {
    x: i32,
    y: i32,

    pub fn toVector(self: *Pos) rl.Vector2 {
        return rl.Vector2.init(@floatFromInt(self.x), @floatFromInt(self.y));
    }
};

pub const EntityError = error{ShitHappened};

// Size 56
pub const Entity = struct {
    texture: rl.Texture2D,
    shader: rl.Shader,
    pos: Pos,
    rotation: f32,
    scale: f32,
    color: rl.Color,

    pub fn init(
        texture_path: [*:0]const u8,
        shader_path: ?[*:0]const u8,
    ) anyerror!Entity {
        return Entity{
            .texture = try rl.loadTexture(texture_path),
            .shader = try rl.loadShader(null, shader_path),
            .pos = Pos{ .x = 0, .y = 0 },
            .rotation = 0.0,
            .scale = 1.0,
            .color = rl.Color.black,
        };
    }

    pub fn deinit(self: Entity) void {
        rl.unloadShader(self.shader);
        rl.unloadTexture(self.texture);
    }

    pub fn draw(self: *Entity) void {
        rl.beginShaderMode(self.shader);
        defer rl.endShaderMode();

        rl.drawTextureEx(self.texture, self.pos.toVector(), self.rotation, self.scale, self.color);
    }
};
