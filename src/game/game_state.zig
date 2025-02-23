const std = @import("std");
const rl = @import("raylib");

const utils = @import("../utils/utils.zig");

const BirdAsset = @import("../game_entities/bird.zig").BirdAsset;
const Nums = @import("../game_entities/nums.zig").Nums;
const Moon = @import("../game_entities/moon.zig").Moon;
const Stars = @import("../game_entities/stars.zig").Stars;
const Cloud = @import("../game_entities/cloud.zig").Cloud;
const Ground = @import("../game_entities/ground.zig").Ground;
const BigTreesAsset = @import("../game_entities/big_trees.zig").BigTreesAsset;
const SmallTreesAsset = @import("../game_entities/small_trees.zig").SmallTreesAsset;
const HiScoreTitle = @import("../game_entities/hi.zig").HiScoreTitle;
const GameOverTitle = @import("../game_entities/game_over.zig").GameOverTitle;

const Dino = @import("../dino/dino.zig").Dino;
const Score = @import("./score.zig").Score;
const Bird = @import("../game_entities/bird.zig").Bird;
const Obstacle = @import("./obstacle.zig").Obstacle;
const Obstacles = @import("./obstacle.zig").Obstacles;
const ObstacleActor = @import("./obstacle.zig").ObstacleActor;

const HiScorePos = rl.Vector2.init(1350, 37);
const CurrScorePos = rl.Vector2.init(1640, 37);
const HiScoreTitlePos = rl.Vector2.init(1300, 37);
const GroundPos = @import("../dino/dino.zig").GroundPos;

const obstacle = @import("./obstacle.zig");

pub const DinoGameState = struct {
    // Actors
    // ----------------------------
    dino: Dino,
    hi_score: Score,
    current_score: Score,
    ground: Ground,
    moon: Moon,
    obstacle: Obstacle,
    obstacle_actor: ObstacleActor,
    // ----------------------------

    // Actor Assets
    // ----------------------------
    nums_asset: Nums,
    big_trees_asset: BigTreesAsset,
    small_trees_asset: SmallTreesAsset,
    bird_asset: BirdAsset,
    cloud_asset: Cloud,
    stars_asset: Stars,
    // ----------------------------

    // Text Assets
    // ----------------------------
    game_over_title: GameOverTitle,
    hi_title: HiScoreTitle,
    // ----------------------------

    // Speeds
    // ----------------------------
    dino_animation_speed: f32 = 0.1,
    // ----------------------------

    // Other fields
    // ----------------------------
    screen_dimension: rl.Vector2,
    // ----------------------------

    // Init Deinit
    // ------------------------------------------------------------
    pub fn init(allocator: std.mem.Allocator, dimensions: rl.Vector2) anyerror!DinoGameState {
        const nums_asset = try Nums.init(allocator);
        const big_trees_asset = try BigTreesAsset.init(allocator);
        const small_trees_asset = try SmallTreesAsset.init(allocator);
        const bird_asset = try BirdAsset.init(allocator);
        const cloud_asset = try Cloud.init();
        const stars_asset = try Stars.init(allocator);
        const game_over_title = try GameOverTitle.init();
        const hi_title = try HiScoreTitle.init(HiScoreTitlePos);

        const init_obstacle = obstacle.getRandomObstacle();

        return DinoGameState{
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

            // Game Actors
            // ----------------------------
            .dino = try Dino.init(allocator),
            .hi_score = Score{
                .value = 123456789,
                .pos = HiScorePos,
            },
            .current_score = Score{
                .value = 123456789,
                .pos = CurrScorePos,
            },
            .ground = try Ground.init(),
            .moon = try Moon.init(allocator),
            // ----------------------------

            //
            // ----------------------------
            .screen_dimension = dimensions,
            .obstacle = init_obstacle,
            .obstacle_actor = obstacle.getObstacleActor(
                init_obstacle,
                dimensions.x,
                GroundPos,
            ),
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
    // ------------------------------------------------------------

    pub fn updateObstacles(self: *DinoGameState) void {
        switch (self.obstacle) {
            Obstacles.Bird => {
                self.obstacle_actor.Bird.updateAnimation(self.ground.scroll_speed);

                if (self.obstacle_actor.Bird.pos.x <= -self.bird_asset.width) {
                    self.obstacle = obstacle.getRandomObstacle();
                    self.obstacle_actor = obstacle.getObstacleActor(
                        self.obstacle,
                        self.screen_dimension.x,
                        GroundPos,
                    );
                }
            },
            Obstacles.BigTree => {
                self.obstacle_actor.BigTree.updateAnimation(self.ground.scroll_speed);

                if (self.obstacle_actor.BigTree.pos.x <= -self.big_trees_asset.width) {
                    self.obstacle = obstacle.getRandomObstacle();
                    self.obstacle_actor = obstacle.getObstacleActor(
                        self.obstacle,
                        self.screen_dimension.x,
                        GroundPos,
                    );
                }
            },
            Obstacles.SmallTree => {
                self.obstacle_actor.SmallTree.updateAnimation(self.ground.scroll_speed);

                if (self.obstacle_actor.SmallTree.pos.x <= -self.big_trees_asset.width) {
                    self.obstacle = obstacle.getRandomObstacle();
                    self.obstacle_actor = obstacle.getObstacleActor(
                        self.obstacle,
                        self.screen_dimension.x,
                        GroundPos,
                    );
                }
            },
        }
    }

    pub fn drawObstacles(self: *DinoGameState) void {
        switch (self.obstacle) {
            Obstacles.Bird => {
                self.obstacle_actor.Bird.draw(&self.bird_asset);
            },
            Obstacles.BigTree => {
                self.obstacle_actor.BigTree.draw(&self.big_trees_asset);
            },
            Obstacles.SmallTree => {
                self.obstacle_actor.SmallTree.draw(&self.small_trees_asset);
            },
        }
    }
};
