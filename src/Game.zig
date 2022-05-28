const std = @import("std");

const sdl = @cImport({
  @cInclude("SDL.h");
});

const gl = @cImport({
  @cInclude("glad/glad.h");
});

const AppError = error{
    SdlInit,
    SdlCreateWindow,
    GlCreateContext,
    GladLoaderSetup,
};

pub const Game = struct {
    window : ?*sdl.SDL_Window = null,
    gl_ctx : sdl.SDL_GLContext = null,

    pub fn init(self: *Game) !void {
        const flags = sdl.SDL_WINDOW_SHOWN | sdl.SDL_WINDOW_OPENGL | sdl.SDL_WINDOW_RESIZABLE;

        _ = sdl.SDL_GL_SetAttribute(sdl.SDL_GL_DOUBLEBUFFER, 1);
        _ = sdl.SDL_GL_SetAttribute(sdl.SDL_GL_DEPTH_SIZE, 24);
        _ = sdl.SDL_GL_SetAttribute(sdl.SDL_GL_STENCIL_SIZE, 8);
        _ = sdl.SDL_GL_SetAttribute(sdl.SDL_GL_ACCELERATED_VISUAL, 1);
        _ = sdl.SDL_GL_SetAttribute(sdl.SDL_GL_CONTEXT_MAJOR_VERSION, 4);
        _ = sdl.SDL_GL_SetAttribute(sdl.SDL_GL_CONTEXT_MINOR_VERSION, 5);
        _ = sdl.SDL_GL_SetAttribute(sdl.SDL_GL_CONTEXT_FLAGS, sdl.SDL_GL_CONTEXT_FORWARD_COMPATIBLE_FLAG);
        _ = sdl.SDL_GL_SetAttribute(sdl.SDL_GL_CONTEXT_PROFILE_MASK, sdl.SDL_GL_CONTEXT_PROFILE_CORE);
        _ = sdl.SDL_GL_SetAttribute(sdl.SDL_GL_CONTEXT_FLAGS, sdl.SDL_GL_CONTEXT_DEBUG_FLAG);

        self.window = sdl.SDL_CreateWindow(
            "zig game",
            sdl.SDL_WINDOWPOS_UNDEFINED,
            sdl.SDL_WINDOWPOS_UNDEFINED,
            640, 480, flags
        );

        if (self.window == null) {
            return error.SdlCreateWindow;
        }

        self.gl_ctx = sdl.SDL_GL_CreateContext(self.window);
        if (self.gl_ctx == null){
            return error.GLCreateContext;
        }
        _ = sdl.SDL_GL_MakeCurrent(self.window, self.gl_ctx);

        var loader_setup= gl.gladLoadGLES2Loader(
            sdl.SDL_GL_GetProcAddress
        );
        if (loader_setup == 0){
            return error.GladLoaderSetup;
        }
    }

    pub fn run(self: *Game) !void {
        var should_quit = false;
        while (!should_quit){
            should_quit = self.frame();
        }
    }

    pub fn deinit(self: *Game) void {
        sdl.SDL_GL_DeleteContext(self.gl_ctx);
        sdl.SDL_DestroyWindow(self.window);
    }

    fn frame(self: *Game) bool {
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

        self.draw();

        return should_quit;
    }

    fn draw(self: *Game) void {
        gl.glClearColor(1,1,0,1);
        gl.glClear(gl.GL_COLOR_BUFFER_BIT | gl.GL_DEPTH_BUFFER_BIT);
        sdl.SDL_GL_SwapWindow(self.window);
    }
};
