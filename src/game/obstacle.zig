const std = @import("std");
const rl = @import("raylib");

const BirdLen = @import("../game_entities/bird.zig").Len;
const BigTreesLen = @import("../game_entities/big_trees.zig").Len;
const SmallTreesLen = @import("../game_entities/small_trees.zig").Len;

const Bird = @import("../game_entities/bird.zig").Bird;
const BigTree = @import("../game_entities/big_trees.zig").BigTree;
const SmallTree = @import("../game_entities/small_trees.zig").SmallTree;

const BirdAsset = @import("../game_entities/bird.zig").BirdAsset;
const BigTreesAsset = @import("../game_entities/big_trees.zig").BigTreesAsset;
const SmallTreesAsset = @import("../game_entities/small_trees.zig").SmallTreesAsset;

pub const Circle = struct {
    center: rl.Vector2,
    radius: f32,
};

pub const Obstacles = enum { Bird, BigTree, SmallTree };

pub const Obstacle = union(Obstacles) {
    Bird: usize,
    BigTree: usize,
    SmallTree: usize,
};

pub fn getRandomObstacle() Obstacle {
    const obstacle_type = std.crypto.random.enumValue(Obstacles);

    return switch (obstacle_type) {
        Obstacles.Bird => getRandomBird(),
        Obstacles.BigTree => getRandomBigTree(),
        Obstacles.SmallTree => getRandomSmallTree(),
    };
}

fn getRandomBird() Obstacle {
    return Obstacle{ .Bird = std.crypto.random.uintAtMost(usize, BirdLen) };
}

fn getRandomBigTree() Obstacle {
    return Obstacle{
        .BigTree = std.crypto.random.uintAtMost(usize, BigTreesLen),
    };
}

fn getRandomSmallTree() Obstacle {
    return Obstacle{
        .SmallTree = std.crypto.random.uintAtMost(usize, SmallTreesLen),
    };
}

pub const ObstacleActor = union(Obstacles) {
    Bird: Bird,
    BigTree: BigTree,
    SmallTree: SmallTree,
};

pub fn getCircle(
    actor: ObstacleActor,
    bird_asset: *const BirdAsset,
    big_tree_asset: *BigTreesAsset,
    small_tree_aseet: *SmallTreesAsset,
) Circle {
    return switch (actor) {
        Obstacles.Bird => actor.Bird.getCircle(bird_asset),
        Obstacles.BigTree => actor.BigTree.getCircle(big_tree_asset),
        Obstacles.SmallTree => actor.SmallTree.getCircle(small_tree_aseet),
    };
}

pub fn getObstacleActor(obstacle: Obstacle, max_width: f32, ground_position: f32) ObstacleActor {
    return switch (obstacle) {
        Obstacles.Bird => ObstacleActor{ .Bird = Bird.init(max_width, obstacle.Bird) },
        Obstacles.BigTree => ObstacleActor{ .BigTree = BigTree.init(
            max_width,
            obstacle.BigTree,
            ground_position,
        ) },
        Obstacles.SmallTree => ObstacleActor{ .SmallTree = SmallTree.init(
            max_width,
            obstacle.SmallTree,
            ground_position,
        ) },
    };
}
