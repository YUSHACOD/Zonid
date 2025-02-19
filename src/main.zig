const std = @import("std");
const rl = @import("raylib");

const Dino = @import("./dino/dino.zig").Dino;
const DinoStates = @import("./dino/dino.zig").DinoStates;
const utils = @import("./utils/utils.zig");

pub fn main() anyerror!void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    // Initialization
    //--------------------------------------------------------------------------------------
    const screenWidth = 1920;
    const screenHeight = 1080;

    // Window Context setup
    rl.initWindow(screenWidth, screenHeight, "Ozid, the reverse dino");
    rl.toggleFullscreen();
    defer rl.closeWindow();

    // Shader setup
    const shader = try rl.loadShader(null, "./resources/shaders/do_nothing.frag.glsl");
    defer rl.unloadShader(shader);

    // Texture Setup
    // Alway create textures after window init you stupid fuck !!!!
    var dino = try Dino.init(utils.Pos{ .x = 0, .y = 0 }, allocator);
    defer dino.deinit(allocator);
    ////////////////////////////////////////////////////////////////////////

    const target: rl.RenderTexture2D = try rl.loadRenderTexture(screenWidth, screenHeight);
    defer rl.unloadRenderTexture(target);

    // Frame Rate
    rl.setTargetFPS(60);
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!rl.windowShouldClose()) { // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        switch (rl.getKeyPressed()) {
            rl.KeyboardKey.one => dino.state = DinoStates.Idle,
            rl.KeyboardKey.two => dino.state = DinoStates.Run1,
            rl.KeyboardKey.three => dino.state = DinoStates.Run2,
            rl.KeyboardKey.four => dino.state = DinoStates.Crawl1,
            rl.KeyboardKey.five => dino.state = DinoStates.Crawl2,
            rl.KeyboardKey.six => dino.state = DinoStates.Shocked1,
            rl.KeyboardKey.seven => dino.state = DinoStates.Shocked2,
            rl.KeyboardKey.eight => dino.state = DinoStates.Blind,
            else => {},
        }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        {
            rl.beginDrawing();
            defer rl.endDrawing();

            {
                rl.beginShaderMode(shader);
                defer rl.endShaderMode();

                rl.drawTextureEx(target.texture, rl.Vector2{ .x = 0.0, .y = 0.0 }, 0.0, 1.0, rl.Color.white);
            }

            rl.drawLine(0, @divFloor(screenHeight, 2), screenWidth, @divFloor(screenHeight, 2), rl.Color.black);
            rl.drawLine(@divFloor(screenWidth, 2), 0, @divFloor(screenWidth, 2), screenHeight, rl.Color.black);

            const dinoX = @as(i32, @divFloor(screenWidth - dino.getWidth(), 2));
            const dinoY = @as(i32, @divFloor(screenHeight, 2) - dino.getHeight());
            dino.draw(utils.Pos.init(dinoX, dinoY));
        }
        //----------------------------------------------------------------------------------
    }
}

test "simple test" {
    var list = std.ArrayList(i32).init(std.testing.allocator);
    defer list.deinit(); // try commenting this out and see if zig detects the memory leak!
    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}
