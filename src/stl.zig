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
//   var set = stl.UnorderedSetInt.init();
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
    /// @return A new UnorderedSetInt instance - may panic on allocation failure
    pub fn init() Self {
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
    /// @return A new UnorderedMapIntInt instance - may panic on allocation failure
    pub fn init() Self {
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
    /// @return A new PriorityQueueInt instance - may panic on allocation failure
    pub fn init() Self {
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
