const std = @import("std");
const message = @import("message/message.zig");
const stl = @import("stl.zig");

/// Main entry point of the application.
/// This program prints a hello message using the message package.
/// Also demonstrates using C++ STL containers via Zig wrappers.
pub fn main() !void {
    // Get the page allocator for memory allocation
    const allocator = std.heap.page_allocator;

    // Generate the greeting message
    const greeting = try message.hello(allocator, "name");

    // Print the greeting message to stdout
    std.debug.print("{s}\n", .{greeting});

    // Free the allocated memory
    allocator.free(greeting);

    // Demonstrate using C++ STL containers from Zig
    std.debug.print("\n=== C++ STL Integration Demo ===\n", .{});

    // Use unordered_set (equivalent to std::unordered_set<int>)
    var set = stl.UnorderedSetInt.init();
    defer set.deinit();

    _ = set.insert(10);
    _ = set.insert(20);
    _ = set.insert(30);
    std.debug.print("UnorderedSet: inserted 10, 20, 30. Size: {d}\n", .{set.size()});
    std.debug.print("Contains 20: {}\n", .{set.contains(20)});
    _ = set.remove(20);
    std.debug.print("After removing 20, contains 20: {}\n", .{set.contains(20)});

    // Use unordered_map (equivalent to std::unordered_map<int, int>)
    var map = stl.UnorderedMapIntInt.init();
    defer map.deinit();

    _ = map.insert(1, 100);
    _ = map.insert(2, 200);
    _ = map.insert(3, 300);
    std.debug.print("\nUnorderedMap: inserted (1,100), (2,200), (3,300). Size: {d}\n", .{map.size()});
    std.debug.print("Get key 2: {d}\n", .{map.get(2).?});
    std.debug.print("Contains key 99: {}\n", .{map.contains(99)});

    // Use priority_queue (equivalent to std::priority_queue<int>)
    var pq = stl.PriorityQueueInt.init();
    defer pq.deinit();

    pq.push(10);
    pq.push(30);
    pq.push(20);
    std.debug.print("\nPriorityQueue: pushed 10, 30, 20. Size: {d}\n", .{pq.size()});
    std.debug.print("Top (max): {d}\n", .{pq.top()});
    pq.pop();
    std.debug.print("After pop, top: {d}\n", .{pq.top()});
    pq.pop();
    pq.pop();
    std.debug.print("Is empty: {}\n", .{pq.isEmpty()});

    std.debug.print("\n=== Demo Complete ===\n", .{});
}
