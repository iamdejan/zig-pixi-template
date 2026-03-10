// @file stl.zig
// @brief Zig wrappers for C++ STL containers
//
// This module provides Zig idiomatic wrappers around C++ STL containers
// (unordered_set, unordered_map, priority_queue) by using @cImport to
// interface with the C wrapper functions defined in stl_wrappers.hpp/cpp.
//
// The pattern: C++ STL -> C ABI wrappers -> Zig wrappers -> Zig idiomatic API
//
// Usage:
//   const stl = @import("stl");
//   var set = stl.UnorderedSetInt.init(allocator);
//   defer set.deinit();
//

const std = @import("std");
const c = @cImport({
    @cInclude("stl_c_wrappers.h");
});

/// A Zig wrapper around C++ std::unordered_set<int>
/// Provides an idiomatic Zig interface to the C++ unordered_set container
pub const UnorderedSetInt = struct {
    /// Pointer to the underlying C++ unordered_set (can be null)
    handle: ?*anyopaque,

    const Self = @This();

    /// Initializes a new unordered_set
    /// Uses the standard Zig allocator pattern
    /// @param allocator: Memory allocator (unused in this implementation, kept for API consistency)
    /// @return A new UnorderedSetInt instance - may panic on allocation failure
    pub fn init(allocator: std.mem.Allocator) Self {
        _ = allocator; // Reserved for future use
        return Self{ .handle = c.unordered_set_int_create() };
    }

    /// Destroys the unordered_set and frees memory
    /// Must be called when done with the set to prevent memory leaks
    pub fn deinit(self: Self) void {
        c.unordered_set_int_destroy(self.handle);
    }

    /// Inserts a value into the set
    /// @param value: The integer value to insert
    /// @return true if the value was newly inserted, false if it already existed
    pub fn insert(self: Self, value: i32) bool {
        return c.unordered_set_int_insert(self.handle, value) == 1;
    }

    /// Checks if a value exists in the set
    /// @param value: The value to check for
    /// @return true if the value exists, false otherwise
    pub fn contains(self: Self, value: i32) bool {
        return c.unordered_set_int_contains(self.handle, value) == 1;
    }

    /// Returns the number of elements in the set
    /// @return The size of the set
    pub fn size(self: Self) usize {
        return c.unordered_set_int_size(self.handle);
    }

    /// Removes a value from the set
    /// @param value: The value to remove
    /// @return true if the value was removed, false if it wasn't found
    pub fn remove(self: Self, value: i32) bool {
        return c.unordered_set_int_remove(self.handle, value) == 1;
    }
};

/// A Zig wrapper around C++ std::unordered_map<int, int>
/// Provides an idiomatic Zig interface to the C++ unordered_map container
pub const UnorderedMapIntInt = struct {
    /// Pointer to the underlying C++ unordered_map (can be null)
    handle: ?*anyopaque,

    const Self = @This();

    /// Initializes a new unordered_map
    /// Uses the standard Zig allocator pattern
    /// @param allocator: Memory allocator (unused in this implementation, kept for API consistency)
    /// @return A new UnorderedMapIntInt instance - may panic on allocation failure
    pub fn init(allocator: std.mem.Allocator) Self {
        _ = allocator; // Reserved for future use
        return Self{ .handle = c.unordered_map_int_int_create() };
    }

    /// Destroys the unordered_map and frees memory
    /// Must be called when done with the map to prevent memory leaks
    pub fn deinit(self: Self) void {
        c.unordered_map_int_int_destroy(self.handle);
    }

    /// Inserts a key-value pair into the map
    /// @param key: The integer key
    /// @param value: The integer value
    /// @return true if the key was newly inserted, false if it already existed (value updated)
    pub fn insert(self: Self, key: i32, value: i32) bool {
        return c.unordered_map_int_int_insert(self.handle, key, value) == 1;
    }

    /// Gets a value from the map by key
    /// @param key: The key to look up
    /// @return The value if found, null if not found
    pub fn get(self: Self, key: i32) ?i32 {
        var out_value: i32 = 0;
        const found = c.unordered_map_int_int_get(self.handle, key, &out_value);
        if (found == 1) {
            return out_value;
        }
        return null;
    }

    /// Checks if a key exists in the map
    /// @param key: The key to check for
    /// @return true if the key exists, false otherwise
    pub fn contains(self: Self, key: i32) bool {
        return c.unordered_map_int_int_contains(self.handle, key) == 1;
    }

    /// Returns the number of key-value pairs in the map
    /// @return The size of the map
    pub fn size(self: Self) usize {
        return c.unordered_map_int_int_size(self.handle);
    }

    /// Removes a key-value pair from the map
    /// @param key: The key to remove
    /// @return true if the key was removed, false if it wasn't found
    pub fn remove(self: Self, key: i32) bool {
        return c.unordered_map_int_int_remove(self.handle, key) == 1;
    }
};

/// A Zig wrapper around C++ std::priority_queue<int>
/// Provides an idiomatic Zig interface to the C++ priority_queue container
/// Uses a max-heap by default (largest element at top)
pub const PriorityQueueInt = struct {
    /// Pointer to the underlying C++ priority_queue (can be null)
    handle: ?*anyopaque,

    const Self = @This();

    /// Initializes a new priority_queue
    /// Uses the standard Zig allocator pattern
    /// @param allocator: Memory allocator (unused in this implementation, kept for API consistency)
    /// @return A new PriorityQueueInt instance - may panic on allocation failure
    pub fn init(allocator: std.mem.Allocator) Self {
        _ = allocator; // Reserved for future use
        return Self{ .handle = c.priority_queue_int_create() };
    }

    /// Destroys the priority_queue and frees memory
    /// Must be called when done with the queue to prevent memory leaks
    pub fn deinit(self: Self) void {
        c.priority_queue_int_destroy(self.handle);
    }

    /// Pushes a value onto the priority_queue
    /// @param value: The integer value to push
    pub fn push(self: Self, value: i32) void {
        c.priority_queue_int_push(self.handle, value);
    }

    /// Returns the top element without removing it
    /// The top is the largest element (max-heap)
    /// @return The largest element, or 0 if empty
    /// @note Should check isEmpty() before calling this
    pub fn top(self: Self) i32 {
        return c.priority_queue_int_top(self.handle);
    }

    /// Removes the top element from the queue
    /// Does nothing if the queue is empty
    pub fn pop(self: Self) void {
        c.priority_queue_int_pop(self.handle);
    }

    /// Checks if the priority_queue is empty
    /// @return true if empty, false otherwise
    pub fn isEmpty(self: Self) bool {
        return c.priority_queue_int_empty(self.handle) == 1;
    }

    /// Returns the number of elements in the priority_queue
    /// @return The size of the queue
    pub fn size(self: Self) usize {
        return c.priority_queue_int_size(self.handle);
    }
};

// ============================================================================
// Unit Tests
// ============================================================================

const testing = std.testing;

test "UnorderedSetInt: insert and contains" {
    var set = UnorderedSetInt.init(testing.allocator);
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
    var set = UnorderedSetInt.init(testing.allocator);
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
    var map = UnorderedMapIntInt.init(testing.allocator);
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
    var map = UnorderedMapIntInt.init(testing.allocator);
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
    var pq = PriorityQueueInt.init(testing.allocator);
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
    var pq = PriorityQueueInt.init(testing.allocator);
    defer pq.deinit();

    // Pop on empty should not crash
    pq.pop();
    pq.pop();

    try testing.expect(pq.isEmpty());
    try testing.expectEqual(@as(i32, 0), pq.top());
}

test "PriorityQueueInt: multiple pushes and pops" {
    var pq = PriorityQueueInt.init(testing.allocator);
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
