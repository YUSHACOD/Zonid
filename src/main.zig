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
    const screenWidth = 1920;
    const screenHeight = 1080;

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
    var game_state = try DinoGameState.init(allocator);
    defer game_state.deinit(allocator);
    //--------------------------------------------------------------------------------------

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
            rl.KeyboardKey.one => game_state.dino.changeState(DinoStates.Idle),
            rl.KeyboardKey.two => game_state.dino.changeState(DinoStates.Running),
            rl.KeyboardKey.three => game_state.dino.changeState(DinoStates.Crawling),
            rl.KeyboardKey.four => game_state.dino.changeState(DinoStates.Shocked),
            rl.KeyboardKey.five => game_state.dino.changeState(DinoStates.Blind),
            rl.KeyboardKey.nine => game_state.dino_animation_speed += 0.1,
            rl.KeyboardKey.zero => game_state.dino_animation_speed -= 0.1,
            rl.KeyboardKey.o => game_state.bird_asset.incrementState(),
            rl.KeyboardKey.n => game_state.moon.incrementState(),
            rl.KeyboardKey.j => game_state.stars_asset.incrementState(),
            rl.KeyboardKey.u => game_state.big_trees_asset.incrementState(),
            rl.KeyboardKey.i => game_state.small_trees_asset.incrementState(),
            else => {},
        }

        game_state.dino.updateAnimation(game_state.dino_animation_speed);
        game_state.dino.updateJumpAnimation();

        game_state.ground.updateGroundScroll();
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

            game_state.dino.drawSelf();

            game_state.bird_asset.draw(rl.Vector2.init(5, 5));
            game_state.moon.draw(rl.Vector2.init(300, 5));
            game_state.stars_asset.draw(rl.Vector2.init(400, 5));
            game_state.cloud_asset.draw(rl.Vector2.init(700, 5));

            game_state.big_trees_asset.draw(rl.Vector2.init(780, 625));
            game_state.small_trees_asset.draw(rl.Vector2.init(567, 600));

            game_state.game_over_title.draw(rl.Vector2.init(400, 200));

            game_state.hi_title.drawSelf();
            try game_state.current_score.drawScore(allocator, &game_state.nums_asset);
            try game_state.hi_score.drawScore(allocator, &game_state.nums_asset);

            game_state.ground.drawGroundScroll();

            // try game_state.score.drawScore(allocator);
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
