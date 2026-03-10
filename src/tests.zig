// @file src/tests.zig
// @brief Test aggregation file that includes all modules containing tests.
//
// In Zig, tests in imported modules are compiled but may not be automatically discovered.
// This file imports the modules and also includes inline test declarations to ensure
// the test runner can find them.

const std = @import("std");
const message = @import("message/message.zig");
const stl = @import("stl.zig");

const testing = std.testing;

// ============================================================================
// Re-declare tests from message.zig to make them discoverable
// ============================================================================

test "hello function returns correct greeting" {
    // Test with different names
    const test_names = [_][]const u8{ "alpha", "beta", "gamma" };

    for (test_names) |name| {
        const result = try message.hello(testing.allocator, name);
        defer testing.allocator.free(result);

        const expected = try std.fmt.allocPrint(testing.allocator, "Hello, {s}", .{name});
        defer testing.allocator.free(expected);

        try testing.expectEqualStrings(expected, result);
    }
}

// ============================================================================
// Re-declare tests from stl.zig to make them discoverable
// ============================================================================

test "UnorderedSetInt: insert and contains" {
    var set = stl.UnorderedSetInt.init();
    defer set.deinit();

    // Insert some values
    try testing.expect(set.insert(10));
    try testing.expect(set.insert(20));
    try testing.expect(set.insert(30));

    // Size should be 3
    try testing.expectEqual(@as(usize, 3), set.size());

    // Values should be contained
    try testing.expect(set.contains(10));
    try testing.expect(set.contains(20));
    try testing.expect(set.contains(30));

    // Non-existent value
    try testing.expect(!set.contains(40));

    // Duplicate insert should return false
    try testing.expect(!set.insert(10));
}

test "UnorderedSetInt: remove" {
    var set = stl.UnorderedSetInt.init();
    defer set.deinit();

    try testing.expect(set.insert(5));
    try testing.expect(set.insert(10));

    // Remove existing
    try testing.expect(set.remove(5));
    try testing.expectEqual(@as(usize, 1), set.size());
    try testing.expect(!set.contains(5));

    // Remove non-existing
    try testing.expect(!set.remove(99));
}

test "UnorderedMapIntInt: insert and get" {
    var map = stl.UnorderedMapIntInt.init();
    defer map.deinit();

    // Insert key-value pairs
    try testing.expect(map.insert(1, 100));
    try testing.expect(map.insert(2, 200));
    try testing.expect(map.insert(3, 300));

    // Size should be 3
    try testing.expectEqual(@as(usize, 3), map.size());

    // Get values
    try testing.expectEqual(@as(i32, 100), map.get(1));
    try testing.expectEqual(@as(i32, 200), map.get(2));
    try testing.expectEqual(@as(i32, 300), map.get(3));

    // Non-existent key
    try testing.expect(map.get(99) == null);

    // Duplicate key should not insert (but may update)
    try testing.expect(!map.insert(1, 999));
    try testing.expectEqual(@as(i32, 100), map.get(1)); // Original value preserved
}

test "UnorderedMapIntInt: contains and remove" {
    var map = stl.UnorderedMapIntInt.init();
    defer map.deinit();

    try testing.expect(map.insert(1, 100));
    try testing.expect(map.insert(2, 200));

    // Contains
    try testing.expect(map.contains(1));
    try testing.expect(map.contains(2));
    try testing.expect(!map.contains(99));

    // Remove
    try testing.expect(map.remove(1));
    try testing.expectEqual(@as(usize, 1), map.size());
    try testing.expect(!map.contains(1));
    try testing.expect(!map.remove(99));
}

test "PriorityQueueInt: push, top, pop" {
    var pq = stl.PriorityQueueInt.init();
    defer pq.deinit();

    // Initially empty
    try testing.expect(pq.isEmpty());
    try testing.expectEqual(@as(usize, 0), pq.size());

    // Push elements
    pq.push(10);
    pq.push(30);
    pq.push(20);

    try testing.expect(!pq.isEmpty());
    try testing.expectEqual(@as(usize, 3), pq.size());

    // Top should be largest (max-heap)
    try testing.expectEqual(@as(i32, 30), pq.top());

    // Pop and check order
    pq.pop();
    try testing.expectEqual(@as(i32, 20), pq.top());

    pq.pop();
    try testing.expectEqual(@as(i32, 10), pq.top());

    pq.pop();
    try testing.expect(pq.isEmpty());
}

test "PriorityQueueInt: pop on empty doesn't crash" {
    var pq = stl.PriorityQueueInt.init();
    defer pq.deinit();

    // Pop on empty should not crash
    pq.pop();
    pq.pop();

    try testing.expect(pq.isEmpty());
    try testing.expectEqual(@as(i32, 0), pq.top());
}

test "PriorityQueueInt: multiple pushes and pops" {
    var pq = stl.PriorityQueueInt.init();
    defer pq.deinit();

    // Push in random order
    pq.push(5);
    pq.push(15);
    pq.push(10);
    pq.push(25);
    pq.push(20);

    // Should come out in descending order (max-heap)
    try testing.expectEqual(@as(i32, 25), pq.top());
    pq.pop();

    try testing.expectEqual(@as(i32, 20), pq.top());
    pq.pop();

    try testing.expectEqual(@as(i32, 15), pq.top());
    pq.pop();

    try testing.expectEqual(@as(i32, 10), pq.top());
    pq.pop();

    try testing.expectEqual(@as(i32, 5), pq.top());
    pq.pop();

    try testing.expect(pq.isEmpty());
}
