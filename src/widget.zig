const backend = @import("backend.zig");
const data = @import("data.zig");

pub const Class = struct {
    showFn: fn(widget: *Widget) anyerror!void,
    preferredSizeFn: fn(widget: *const Widget, available: data.Size) data.Size,
};

pub const Widget = struct {
    data: usize,
    peer: ?backend.PeerType = null,
    container_expanded: bool = false,
    class: *const Class,
    // layouting
    x: f64 = 0,
    y: f64 = 0,
    width: f64 = 0,
    height: f64 = 0,

    pub fn show(self: *Widget) anyerror!void {
        try self.class.showFn(self);
    }

    /// Get the preferred size for the given available space.
    /// With this system, minimum size is widget.getPreferredSize(Size { .width = 0, .height = 0 }),
    /// and maximum size is widget.getPreferredSize(Size { .width = std.math.maxInt(u32), .height = std.math.maxInt(u32) })
    pub fn getPreferredSize(self: *const Widget, available: data.Size) data.Size {
        return self.class.preferredSizeFn(self, available);
    }

    pub fn as(self: *Widget, comptime T: type) *T {
        return @intToPtr(*T, self.data);
    }
};
