const Game = @import("./Game.zig");

pub fn main() !void {
    var game = Game{};
    defer game.deinit();
    try game.init();
    try game.run();
}

