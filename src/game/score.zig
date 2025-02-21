const std = @import("std");
const rl = @import("raylib");

const Nums = @import("../game_entities/nums.zig").Nums;
const Pos = @import("../utils/utils.zig").Pos;

const Spacing: i32 = 25;

pub const Score = struct {
    value: u32 = 0,
    pos: Pos = Pos.init(0, 0),
    nums_asset: *Nums,

    pub fn drawScore(self: *Score, allocator: std.mem.Allocator) anyerror!void {
        const string_value: [:0]const u8 = try std.fmt.allocPrintZ(allocator, "{d:0>10}", .{self.value});

        for (string_value, 0..) |num, i| {
            const idx: i32 = @intCast(i);

            const digit_pos: Pos = Pos{
                .x = self.pos.x + (Spacing * idx),
                .y = self.pos.y,
            };

            self.nums_asset.draw(digit_pos, num);
        }
    }
};
