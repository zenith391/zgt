const backend = @import("backend.zig");
const Size = @import("data.zig").Size;

pub const DrawContext = backend.Canvas.DrawContext;

pub const Canvas_Impl = struct {
    pub usingnamespace @import("internal.zig").All(Canvas_Impl);

    peer: ?backend.Canvas = null,
    handlers: Canvas_Impl.Handlers = undefined,

    pub fn init() Canvas_Impl {
        return Canvas_Impl.init_events(Canvas_Impl {});
    }

    /// Internal function used at initialization.
    /// It is used to move some pointers so things do not break.
    pub fn pointerMoved(self: *Canvas_Impl) void {
        _ = self;
    }

    pub fn getPreferredSize(self: *Canvas_Impl, available: Size) Size {
        _ = self;
        _ = available;

        // As it's a canvas, by default it should take the available space
        return available;
    }

    pub fn show(self: *Canvas_Impl) !void {
        if (self.peer == null) {
            self.peer = try backend.Canvas.create();
            try self.show_events();
        }
    }
};

pub fn Canvas(config: struct {
    onclick: ?Canvas_Impl.Callback = null
}) Canvas_Impl {
    var btn = Canvas_Impl.init();
    if (config.onclick) |onclick| {
        btn.addClickHandler(onclick) catch unreachable; // TODO: improve
    }
    return btn;
}
