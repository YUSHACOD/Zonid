const std = @import("std");
const rl = @import("raylib");

const Pos = @import("../utils/utils.zig").Pos;

const BirdAsset = @import("../game_entities/bird.zig").BirdAsset;
const Nums = @import("../game_entities/nums.zig").Nums;
const Moon = @import("../game_entities/moon.zig").Moon;
const Stars = @import("../game_entities/stars.zig").Stars;
const Cloud = @import("../game_entities/cloud.zig").Cloud;
const Ground = @import("../game_entities/ground.zig").Ground;
const BigTrees = @import("../game_entities/big_trees.zig").BigTrees;
const SmallTrees = @import("../game_entities/small_trees.zig").SmallTrees;
const HiScoreTitle = @import("../game_entities/hi.zig").HiScoreTitle;
const GameOverTitle = @import("../game_entities/game_over.zig").GameOverTitle;

const Dino = @import("../dino/dino.zig").Dino;
const Score = @import("./score.zig").Score;
const Bird = @import("../game_entities/bird.zig").Bird;

const HiScorePos = Pos.init(0, 0);
const CurrScorePos = Pos.init(0, 0);

pub const DinoGameState = struct {
    // Actors
    // ----------------------------
    dino: Dino,
    hi_score: Score,
    current_score: Score,
    ground: Ground,
    moon: Moon,
    // ----------------------------

    // Actor Assets
    // ----------------------------
    nums_asset: Nums,
    big_trees_asset: BigTrees,
    small_trees_asset: SmallTrees,
    bird_asset: BirdAsset,
    cloud_asset: Cloud,
    stars_asset: Stars,
    // ----------------------------

    // Text Assets
    // ----------------------------
    game_over_title: GameOverTitle,
    hi_title: HiScoreTitle,
    // ----------------------------

    pub fn init(allocator: std.mem.Allocator) anyerror!DinoGameState {
        var nums_asset = try Nums.init(allocator);
        const big_trees_asset = try BigTrees.init(allocator);
        const small_trees_asset = try SmallTrees.init(allocator);
        const bird_asset = try BirdAsset.init(allocator);
        const cloud_asset = try Cloud.init();
        const stars_asset = try Stars.init(allocator);
        const game_over_title = try GameOverTitle.init();
        const hi_title = try HiScoreTitle.init();

        return DinoGameState{
            // Game Actors
            // ----------------------------
            .dino = try Dino.init(allocator),
            .hi_score = Score{
                .pos = HiScorePos,
                .nums_asset = &nums_asset,
            },
            .current_score = Score{
                .pos = CurrScorePos,
                .nums_asset = &nums_asset,
            },
            .ground = try Ground.init(),
            .moon = try Moon.init(allocator),
            // ----------------------------

            // Asset Initialization
            // ----------------------------
            .nums_asset = nums_asset,
            .big_trees_asset = big_trees_asset,
            .small_trees_asset = small_trees_asset,
            .bird_asset = bird_asset,
            .cloud_asset = cloud_asset,
            .stars_asset = stars_asset,
            .game_over_title = game_over_title,
            .hi_title = hi_title,
            // ----------------------------

        };
    }

    pub fn deinit(self: *DinoGameState, allocator: std.mem.Allocator) void {
        self.dino.deinit(allocator);
        self.ground.deinit();
        self.moon.deinit(allocator);

        self.nums_asset.deinit(allocator);
        self.big_trees_asset.deinit(allocator);
        self.small_trees_asset.deinit(allocator);
        self.bird_asset.deinit(allocator);
        self.cloud_asset.deinit();
        self.stars_asset.deinit(allocator);
    }
};
