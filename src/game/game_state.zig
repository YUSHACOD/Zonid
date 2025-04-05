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

const DinoStates = @import("../dino/dino.zig").DinoStates;

const HiScorePos = rl.Vector2.init(1350, 37);
const CurrScorePos = rl.Vector2.init(1640, 37);
const HiScoreTitlePos = rl.Vector2.init(1300, 37);
const GroundPos = @import("../dino/dino.zig").GroundPos;
const GameOverTitlePos: rl.Vector2 = rl.Vector2.init(960, 250);

const CloudPositions = @import("../game_entities/cloud.zig").CloudPositions;
const StarPositions = @import("../game_entities/stars.zig").StarPositions;
const StarStates = @import("../game_entities/stars.zig").StarStates;

const ScoreUpdateFrequency: u8 = 2;
const SpeedUpdateFrequency: u8 = 128;
const ScrollSpeed = @import("../game_entities/ground.zig").ScrollSpeed;
pub const Direction: f32 = -1;

const obstacle = @import("./obstacle.zig");
const Circle = obstacle.Circle;

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
    game_started: bool = false,
    game_ended: bool = false,
    update_count: u8 = 0,
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
                .value = 0,
                .pos = HiScorePos,
            },
            .current_score = Score{
                .value = 0,
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

    // Updates
    // ------------------------------------------------------------
    pub fn updateAll(self: *DinoGameState) void {
        if (!self.game_started) {
            if (rl.isKeyPressed(rl.KeyboardKey.space)) {
                self.game_started = true;
                self.dino.changeState(DinoStates.Running);
            }
        }

        if (self.game_ended) {
            if (rl.isKeyPressed(rl.KeyboardKey.r)) {
                self.game_ended = false;
                self.dino.changeState(DinoStates.Running);

                const init_obstacle = obstacle.getRandomObstacle();
                self.obstacle = init_obstacle;
                self.obstacle_actor = obstacle.getObstacleActor(
                    init_obstacle,
                    self.screen_dimension.x,
                    GroundPos,
                );

                self.current_score.value = 0;
                self.ground.scroll_speed = Direction * ScrollSpeed;
            }
        }

        if (self.game_started and !self.game_ended) {
            self.updateScoreAndSpeed();

            self.dino.updateAnimation();

            self.ground.updateGroundScroll();
            self.updateObstacles();
            self.updateCollision();
        }
    }

    fn updateScoreAndSpeed(self: *DinoGameState) void {
        self.update_count += 1;

        if (self.update_count % ScoreUpdateFrequency == 0) {
            // Score
            self.current_score.value += 1;
        }
        if (self.update_count % SpeedUpdateFrequency == 0) {
            self.update_count = 0;
            // Speed
            self.ground.scroll_speed += Direction * 0.25;

            // Update Moon state with speed update
            if (Direction == 1) {
                self.moon.incrementState();
            } else {
                self.moon.decrementState();
            }
        }

        if (self.current_score.value > self.hi_score.value) {
            self.hi_score.value = self.current_score.value;
        }
    }

    fn updateCollision(self: *DinoGameState) void {
        const obstacle_circle: Circle = obstacle.getCircle(
            self.obstacle_actor,
            &self.bird_asset,
            &self.big_trees_asset,
            &self.small_trees_asset,
        );
        const dino_circle: Circle = self.dino.getCircle();

        const collision: bool = rl.checkCollisionCircles(
            dino_circle.center,
            dino_circle.radius,
            obstacle_circle.center,
            obstacle_circle.radius,
        );

        if (collision) {
            self.dino.changeState(DinoStates.Shocked);
            self.game_ended = true;
        }
    }

    fn updateObstacles(self: *DinoGameState) void {
        switch (self.obstacle) {
            Obstacles.Bird => {
                self.obstacle_actor.Bird.updateAnimation(self.ground.scroll_speed);

                const left_bound = self.obstacle_actor.Bird.pos.x < -self.bird_asset.width;
                const right_bound = self.obstacle_actor.Bird.pos.x > self.screen_dimension.x;

                const start_position = if (Direction == 1)
                    self.screen_dimension.x
                else
                    -self.bird_asset.width;

                if (left_bound or right_bound) {
                    self.obstacle = obstacle.getRandomObstacle();
                    self.obstacle_actor = obstacle.getObstacleActor(
                        self.obstacle,
                        start_position,
                        GroundPos,
                    );
                }
            },
            Obstacles.BigTree => {
                self.obstacle_actor.BigTree.updateAnimation(self.ground.scroll_speed);

                const left_bound = self.obstacle_actor.BigTree.pos.x <
                    -self.big_trees_asset.width(self.obstacle_actor.BigTree.state);

                const right_bound = self.obstacle_actor.BigTree.pos.x > self.screen_dimension.x;

                const start_position = if (Direction == 1)
                    self.screen_dimension.x
                else
                    -self.big_trees_asset.width(self.obstacle_actor.BigTree.state);

                if (left_bound or right_bound) {
                    self.obstacle = obstacle.getRandomObstacle();
                    self.obstacle_actor = obstacle.getObstacleActor(
                        self.obstacle,
                        start_position,
                        GroundPos,
                    );
                }
            },
            Obstacles.SmallTree => {
                self.obstacle_actor.SmallTree.updateAnimation(self.ground.scroll_speed);

                const left_bound = self.obstacle_actor.SmallTree.pos.x < -self.small_trees_asset.width;
                const right_bound = self.obstacle_actor.SmallTree.pos.x > self.screen_dimension.x;

                const start_position = if (Direction == 1)
                    self.screen_dimension.x
                else
                    -self.small_trees_asset.width;

                if (left_bound or right_bound) {
                    self.obstacle = obstacle.getRandomObstacle();
                    self.obstacle_actor = obstacle.getObstacleActor(
                        self.obstacle,
                        start_position,
                        GroundPos,
                    );
                }
            },
        }
    }
    // ------------------------------------------------------------

    // Draws
    // ------------------------------------------------------------
    pub fn drawAll(self: *DinoGameState, allocator: std.mem.Allocator) anyerror!void {
        self.drawScenery();

        self.dino.drawSelf();

        self.ground.drawGroundScroll();
        self.drawObstacles();

        const adjusted_pos = utils.adjustPosMiddle(
            GameOverTitlePos,
            self.game_over_title.width,
            self.game_over_title.height,
        );
        if (self.game_ended) {
            self.game_over_title.draw(adjusted_pos);
        }

        self.hi_title.drawSelf();
        try self.current_score.drawScore(allocator, &self.nums_asset);
        try self.hi_score.drawScore(allocator, &self.nums_asset);
    }

    pub fn drawScenery(self: *DinoGameState) void {
        for (CloudPositions) |pos| {
            self.cloud_asset.draw(pos);
        }

        for (StarPositions, StarStates) |pos, state| {
            self.stars_asset.draw(pos, state);
        }

        self.moon.drawSelf();
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
    // ------------------------------------------------------------
};
