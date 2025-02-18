const std = @import("std");
const rl = @import("raylib");

pub fn main() anyerror!void {
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
    const dino = try rl.loadTexture("./resources/images/dino.png");
    defer rl.unloadTexture(dino);

    const target: rl.RenderTexture2D = try rl.loadRenderTexture(screenWidth, screenHeight);
    defer rl.unloadRenderTexture(target);

    // Frame Rate
    rl.setTargetFPS(60);
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!rl.windowShouldClose()) { // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
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

            const dinoX = @as(i32, @divFloor(screenWidth - dino.width, 2));
            const dinoY = @as(i32, @divFloor(screenHeight - dino.height, 2));
            rl.drawTextureEx(dino, rl.Vector2.init(@floatFromInt(dinoX), @floatFromInt(dinoY)), 0.0, 1.25, rl.Color.ray_white);
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
