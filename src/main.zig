const std = @import("std");
const rl = @import("raylib");
const utils = @import("./utils/utils.zig");

const Dino = @import("./dino/dino.zig").Dino;
const Bird = @import("./game_entities/bird.zig").Bird;
const Nums = @import("./game_entities/nums.zig").Nums;
const Moons = @import("./game_entities/moons.zig").Moons;
const Stars = @import("./game_entities/stars.zig").Stars;
const Cloud = @import("./game_entities/cloud.zig").Cloud;
const Ground = @import("./game_entities/ground.zig").Ground;
const BigTrees = @import("./game_entities/big_trees.zig").BigTrees;
const SmallTrees = @import("./game_entities/small_trees.zig").SmallTrees;
const HiScoreTitle = @import("./game_entities/hi.zig").HiScoreTitle;
const GameOverTitle = @import("./game_entities/game_over.zig").GameOverTitle;

const Score = @import("./game/score.zig").Score;

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
    var dino = try Dino.init(allocator);
    defer dino.deinit(allocator);
    //--------------------------------------------------------------------------------------
    var bird = try Bird.init(allocator);
    defer bird.deinit(allocator);
    //--------------------------------------------------------------------------------------
    var moon = try Moons.init(allocator);
    defer moon.deinit(allocator);
    //--------------------------------------------------------------------------------------
    var star = try Stars.init(allocator);
    defer star.deinit(allocator);
    //--------------------------------------------------------------------------------------
    var cloud = try Cloud.init();
    defer cloud.deinit();
    //--------------------------------------------------------------------------------------
    var gameOver = try GameOverTitle.init();
    defer gameOver.deinit();
    //--------------------------------------------------------------------------------------
    var ground = try Ground.init();
    defer ground.deinit();
    //--------------------------------------------------------------------------------------
    var hi = try HiScoreTitle.init();
    defer hi.deinit();
    //--------------------------------------------------------------------------------------
    var nums = try Nums.init(allocator);
    defer nums.deinit(allocator);
    //--------------------------------------------------------------------------------------
    var bigTree = try BigTrees.init(allocator);
    defer bigTree.deinit(allocator);
    //--------------------------------------------------------------------------------------
    var smallTree = try SmallTrees.init(allocator);
    defer smallTree.deinit(allocator);
    //--------------------------------------------------------------------------------------

    // Score structure
    var score: Score = Score{
        .pos = utils.Pos{ .x = 500, .y = 500 },
        .value = 123456789,
        .nums_asset = &nums,
    };

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
            rl.KeyboardKey.one => dino.state = DinoStates.Idle,
            rl.KeyboardKey.two => dino.state = DinoStates.Run1,
            rl.KeyboardKey.three => dino.state = DinoStates.Run2,
            rl.KeyboardKey.four => dino.state = DinoStates.Crawl1,
            rl.KeyboardKey.five => dino.state = DinoStates.Crawl2,
            rl.KeyboardKey.six => dino.state = DinoStates.Shocked1,
            rl.KeyboardKey.seven => dino.state = DinoStates.Shocked2,
            rl.KeyboardKey.eight => dino.state = DinoStates.Blind,
            rl.KeyboardKey.o => bird.incrementState(),
            rl.KeyboardKey.n => moon.incrementState(),
            rl.KeyboardKey.j => star.incrementState(),
            rl.KeyboardKey.u => bigTree.incrementState(),
            rl.KeyboardKey.i => smallTree.incrementState(),
            else => {},
        }

        dino.pos.updateWithMousePos();

        ground.updateGroundScroll();
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

            dino.drawSelf();

            bird.draw(utils.Pos.init(5, 5));
            moon.draw(utils.Pos.init(300, 5));
            star.draw(utils.Pos.init(400, 5));
            cloud.draw(utils.Pos.init(700, 5));

            bigTree.draw(utils.Pos.init(780, 400));
            smallTree.draw(utils.Pos.init(567, 600));

            gameOver.draw(utils.Pos.init(400, 200));
            hi.draw(utils.Pos.init(700, 200));

            ground.drawGroundScroll();

            try score.drawScore(allocator);
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
