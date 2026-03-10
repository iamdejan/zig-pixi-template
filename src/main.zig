const std = @import("std");
const message = @import("message/message.zig");

/// Main entry point of the application.
/// This program prints a hello message using the message package.
pub fn main() !void {
    // Get the page allocator for memory allocation
    const allocator = std.heap.page_allocator;

    // Generate the greeting message
    const greeting = try message.hello(allocator, "name");

    // Print the greeting message to stdout
    std.debug.print("{s}\n", .{greeting});

    // Free the allocated memory
    allocator.free(greeting);
}
