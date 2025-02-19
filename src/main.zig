const std = @import("std");
const rl = @import("raylib");

const dinoImport = @import("./dino/dino.zig");
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

    // Alway create textures after window init you stupid fuck !!!!
    var dino2 = try dinoImport.Dino.init(utils.Pos{ .x = 0, .y = 0 }, allocator);
    defer dino2.deinit(allocator);
    ////////////////////////////////////////////////////////////////////////

    // Shader setup
    const shader = try rl.loadShader(null, "./resources/shaders/do_nothing.frag.glsl");
    defer rl.unloadShader(shader);

    // Texture Setup
    const dino = try rl.loadTexture("./resources/images/dinos/dino_idle.png");
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

            const dinoX = @as(i32, @divExact(screenWidth - dino.width, 2));
            const dinoY = @as(i32, @divExact(screenHeight, 2) - dino.height);
            rl.drawTextureEx(dino, rl.Vector2.init(@floatFromInt(dinoX), @floatFromInt(dinoY)), 0.0, 1.0, rl.Color.sky_blue);
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
