const std = @import("std");

const sdl = @cImport({
  @cInclude("SDL.h");
});

const AppError = error{
    SdlInit,
    SdlCreateWindow
};

pub fn main() !void {
    game() catch {
        std.log.info("failed...", .{});
    };
}

pub fn game() !void {
    const flags = sdl.SDL_WINDOW_SHOWN | sdl.SDL_WINDOW_OPENGL | sdl.SDL_WINDOW_RESIZABLE;

    var window = sdl.SDL_CreateWindow(
        "zig game",
        sdl.SDL_WINDOWPOS_UNDEFINED,
        sdl.SDL_WINDOWPOS_UNDEFINED,
        640, 480, flags
    );

    if (window == null) {
        return error.SdlCreateWindow;
    }

    var should_quit = false;
    while (!should_quit){
        should_quit = frame();
    }
}

fn frame() bool {
    var event : sdl.SDL_Event = undefined;
    var should_quit = false;
    while(sdl.SDL_PollEvent(&event) != 0){
        switch (event.type){
            sdl.SDL_QUIT => {
                should_quit = true;
            },
            else => {},
        }
    }

    draw();

    return should_quit;
}

fn draw() void {

}
