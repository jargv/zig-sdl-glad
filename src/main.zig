const Game = @import("./Game.zig").Game;

pub fn main() !void {
    var game = Game{};
    defer game.deinit();
    try game.init();
    try game.run();
}

