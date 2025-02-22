const std = @import("std");
const rl = @import("raylib");

const Nums = @import("../game_entities/nums.zig").Nums;
const utils = @import("../utils/utils.zig");

const Spacing: f32 = 25;

pub const Score = struct {
    value: u32 = 0,
    pos: rl.Vector2 = rl.Vector2.init(0, 0),

    pub fn drawScore(self: *Score, allocator: std.mem.Allocator, nums_asset: *Nums) anyerror!void {
        const string_value: [:0]const u8 = try std.fmt.allocPrintZ(allocator, "{d:0>10}", .{self.value});
        const mid_adjustedPos: rl.Vector2 = utils.adjustPosHeight(self.pos, nums_asset.height);

        for (string_value, 0..) |num, i| {
            const idx: f32 = @floatFromInt(i);

            const digit_pos: rl.Vector2 = rl.Vector2{
                .x = mid_adjustedPos.x + (Spacing * idx),
                .y = mid_adjustedPos.y,
            };

            nums_asset.draw(digit_pos, num);
        }
    }
};
