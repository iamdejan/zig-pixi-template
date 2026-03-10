const std = @import("std");

/// Generates a greeting message for the given name.
/// This function takes a name as input and returns a formatted greeting string.
/// The caller is responsible for freeing the returned memory.
///
/// ## Arguments
/// * `allocator` - Memory allocator for creating the result string.
/// * `name` - The name to include in the greeting message.
///
/// ## Returns
/// An allocated string in the format "Hello, {name}".
pub fn hello(allocator: std.mem.Allocator, name: []const u8) ![]const u8 {
    // Format the greeting message using std.fmt
    return std.fmt.allocPrint(allocator, "Hello, {s}", .{name});
}

test "hello function returns correct greeting" {
    // Test with different names
    const test_names = [_][]const u8{ "alpha", "beta", "gamma" };

    for (test_names) |name| {
        const result = try hello(std.testing.allocator, name);
        defer std.testing.allocator.free(result);

        const expected = try std.fmt.allocPrint(std.testing.allocator, "Hello, {s}", .{name});
        defer std.testing.allocator.free(expected);

        try std.testing.expectEqualStrings(expected, result);
    }
}
