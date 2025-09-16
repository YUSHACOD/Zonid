# Zonid

Reverse dino game written in Zig using raylib. You play as the scenery: the world scrolls, the dino tries to survive.

## Features
- Parallax scenery: moons, stars, clouds, and scrolling ground
- Animated dino with multiple states: Idle, Running, Crawling, Shocked, Blind
- Randomized obstacles: birds, small trees, big trees
- Pixel-art UI assets for score, HI title, and game over
- Increasing speed over time; HI score tracking

## Controls
- **Space**: Start / Jump
- **Down Arrow**: Crawl (hold)
- **R**: Restart after game over
- **Esc**: Quit window

## Requirements
- Zig 0.14.0+
- Windows/Linux/macOS capable of building raylib (static link via dependency)
- Git (for dependency fetching)

## Getting Started
```bash
# Fetch dependencies (raylib, raygui, raylib-zig)
zig build --fetch

# Build
zig build

# Run
zig build run

# Install binary to zig-out/bin
zig build install
```

The game starts in fullscreen at 1920x1080. Assets are loaded from `resources/`.

## Project Structure
- `src/main.zig`: initializes window, shader, render target, and runs the loop. Creates `DinoGameState` and delegates update/draw.
- `src/game/game_state.zig`: core orchestration of game logic, input handling, scoring/speed, collisions, obstacle lifecycle, and drawing order.
- `src/dino/dino.zig`: dino actor, animation state machine (Idle/Running/Crawling/Shocked/Blind), physics (gravity/jump), and rendering.
- `src/game/obstacle.zig`: obstacle types (Bird/BigTree/SmallTree), random selection, spawn helpers, and collision circle helpers.
- `src/game/score.zig`: zero-padded numeric score rendering via `Nums` assets.
- `src/game_entities/*`: assets and drawable entities (ground, clouds, stars, moon, trees, bird, numbers, titles).
- `src/utils/*`: vector math, positioning helpers, `Drawable` wrapper.
- `build.zig` / `build.zig.zon`: Zig build graph and package dependencies (`raylib`, `raygui`, `raylib-zig`).
- `resources/`: images and shaders used by the game.

## Gameplay Notes
- Press Space to start; the ground scrolls and speed increases periodically.
- Moon phase changes with speed progression.
- Obstacles spawn from either side depending on direction and recycle when off-screen.
- Collision is circle-based for dino and obstacle approximations.

## Testing
Two test entry points are wired in the build:
```bash
zig build test
```
This builds and runs tests for `src/root.zig` and `src/main.zig`.

## Troubleshooting
- If dependency fetch fails, ensure Git is installed and network access is available, then run `zig build --fetch` again.
- If the window opens off-screen or on an unsupported resolution, edit `screenWidth`/`screenHeight` in `src/main.zig` and remove `rl.toggleFullscreen()` if desired.

