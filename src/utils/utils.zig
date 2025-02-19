const std = @import("std");
const rl = @import("raylib");

pub const Pos = struct {
    x: i32,
    y: i32,

    pub fn toVector(self: Pos) rl.Vector2 {
        return rl.Vector2.init(@floatFromInt(self.x), @floatFromInt(self.y));
    }

    pub fn init(x: i32, y: i32) Pos {
        return Pos{ .x = x, .y = y };
    }
};

pub const Drawable = struct {
    texture: rl.Texture2D,
    shader: rl.Shader,
    rotation: f32,
    scale: f32,
    color: rl.Color,

    pub fn init(
        texture_path: [*:0]const u8,
        shader_path: ?[*:0]const u8,
    ) anyerror!Drawable {
        return Drawable{
            .texture = try rl.loadTexture(texture_path),
            .shader = try rl.loadShader(null, shader_path),
            .rotation = 0.0,
            .scale = 1.0,
            .color = rl.Color.white,
        };
    }

    pub fn deinit(self: Drawable) void {
        rl.unloadShader(self.shader);
        rl.unloadTexture(self.texture);
    }

    pub fn draw(self: *Drawable, pos: Pos) void {
        rl.beginShaderMode(self.shader);
        defer rl.endShaderMode();

        rl.drawTextureEx(self.texture, pos.toVector(), self.rotation, self.scale, self.color);
    }
};
