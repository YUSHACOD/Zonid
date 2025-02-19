const std = @import("std");
const rl = @import("raylib");
const utils = @import("./utils/utils.zig");

const Dino = @import("./dino/dino.zig").Dino;
const Bird = @import("./bird/bird.zig").Bird;
const Moon = @import("./moon/moon.zig").Moon;
const Star = @import("./sky/star.zig").Star;
const Cloud = @import("./sky/cloud.zig").Cloud;
const Nums = @import("./nums/nums.zig").Nums;
const BigTree = @import("./tree/big_tree.zig").BigTree;
const SmallTree = @import("./tree/small_tree.zig").SmallTree;
const GameOver = @import("./misc/game_over.zig").GameOver;
const Ground = @import("./misc/ground.zig").Ground;
const Hi = @import("./misc/hi.zig").Hi;

const DinoStates = @import("./dino/dino.zig").DinoStates;
const BirdStates = @import("./bird/bird.zig").BirdStates;

const BackGroundShader = "./resources/shaders/do_nothing.frag.glsl";

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
    var moon = try Moon.init(allocator);
    defer moon.deinit(allocator);
    //--------------------------------------------------------------------------------------
    var star = try Star.init(allocator);
    defer star.deinit(allocator);
    //--------------------------------------------------------------------------------------
    var cloud = try Cloud.init();
    defer cloud.deinit();
    //--------------------------------------------------------------------------------------
    var gameOver = try GameOver.init();
    defer gameOver.deinit();
    //--------------------------------------------------------------------------------------
    var ground = try Ground.init();
    defer ground.deinit();
    //--------------------------------------------------------------------------------------
    var hi = try Hi.init();
    defer hi.deinit();
    //--------------------------------------------------------------------------------------
    var nums = try Nums.init(allocator);
    defer nums.deinit(allocator);
    //--------------------------------------------------------------------------------------
    var bigTree = try BigTree.init(allocator);
    defer bigTree.deinit(allocator);
    //--------------------------------------------------------------------------------------
    var smallTree = try SmallTree.init(allocator);
    defer smallTree.deinit(allocator);
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
            rl.KeyboardKey.nine => bird.state = BirdStates.Down,
            rl.KeyboardKey.zero => bird.state = BirdStates.Up,
            rl.KeyboardKey.n => moon.incrementState(),
            rl.KeyboardKey.j => star.incrementState(),
            rl.KeyboardKey.y => nums.incrementState(),
            rl.KeyboardKey.u => bigTree.incrementState(),
            rl.KeyboardKey.i => smallTree.incrementState(),
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

            bird.draw(utils.Pos.init(5, 5));
            moon.draw(utils.Pos.init(300, 5));
            star.draw(utils.Pos.init(400, 5));
            cloud.draw(utils.Pos.init(700, 5));

            nums.draw(utils.Pos.init(100, 400));
            bigTree.draw(utils.Pos.init(780, 400));
            smallTree.draw(utils.Pos.init(567, 600));

            gameOver.draw(utils.Pos.init(400, 200));
            ground.draw(utils.Pos.init(0, 600));
            hi.draw(utils.Pos.init(700, 200));
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
