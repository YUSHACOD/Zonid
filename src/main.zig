const std = @import("std");
const rl = @import("raylib");

const utils = @import("./utils/utils.zig");

const DinoGameState = @import("game/game_state.zig").DinoGameState;
const DinoStates = @import("./dino/dino.zig").DinoStates;

const BackGroundShader = "./resources/shaders/do_nothing.frag.glsl";

pub fn main() anyerror!void {
    // Allocator
    //--------------------------------------------------------------------------------------
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    //--------------------------------------------------------------------------------------

    // Initialization
    //--------------------------------------------------------------------------------------
    const screenWidth: i32 = 1920;
    const screenHeight: i32 = 1080;

    // Window Context setup
    rl.initWindow(screenWidth, screenHeight, "Ozid, the reverse dino");
    rl.toggleFullscreen();
    defer rl.closeWindow();

    // Shader setup
    const shader = try rl.loadShader(null, BackGroundShader);
    defer rl.unloadShader(shader);

    // Texture Setup
    // Alway create textures after window init you stupid fuck !!!!
    //--------------------------------------------------------------------------------------
    var game_state = try DinoGameState.init(allocator, rl.Vector2.init(
        @floatFromInt(screenWidth),
        @floatFromInt(screenHeight),
    ));
    defer game_state.deinit(allocator);
    //--------------------------------------------------------------------------------------

    // Texture Target
    const target: rl.RenderTexture2D = try rl.loadRenderTexture(screenWidth, screenHeight);
    defer rl.unloadRenderTexture(target);

    // Frame Rate
    rl.setTargetFPS(60);
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!rl.windowShouldClose()) { // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        game_state.updateAll();
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        {
            rl.beginDrawing();
            defer rl.endDrawing();

            { // Begin Shader Mode
                rl.beginShaderMode(shader);
                defer rl.endShaderMode();

                rl.drawTextureEx(target.texture, rl.Vector2{ .x = 0.0, .y = 0.0 }, 0.0, 1.0, rl.Color.white);
            } // End Shader Mode

            try game_state.drawAll(allocator);
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
