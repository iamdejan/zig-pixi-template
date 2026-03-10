/**
 * @file stl_wrappers.hpp
 * @brief C++ STL container wrappers for Zig interop
 * 
 * This file provides functions C++ that wrap STL containers (unordered_set,
 * unordered_map, priority_queue) to allow Zig to interact with them via C ABI.
 */

#ifndef STL_WRAPPERS_HPP
#define STL_WRAPPERS_HPP

#include <unordered_set>
#include <unordered_map>
#include <queue>
#include <vector>
#include <cstddef>

extern "C" {

// ============================================================================
// Unordered Set Wrappers
// ============================================================================

/**
 * Creates a new unordered_set for integers
 * @return Pointer to the unordered_set
 */
void* unordered_set_int_create();

/**
 * Destroys an unordered_set
 * @param set Pointer to the unordered_set to destroy
 */
void unordered_set_int_destroy(void* set);

/**
 * Inserts an integer into the unordered_set
 * @param set Pointer to the unordered_set
 * @param value Integer value to insert
 * @return 1 if insertion happened, 0 if already existed
 */
int unordered_set_int_insert(void* set, int value);

/**
 * Checks if a value exists in the unordered_set
 * @param set Pointer to the unordered_set
 * @param value Value to check
 * @return 1 if exists, 0 if not
 */
int unordered_set_int_contains(void* set, int value);

/**
 * Gets the size of the unordered_set
 * @param set Pointer to the unordered_set
 * @return Number of elements
 */
size_t unordered_set_int_size(void* set);

/**
 * Removes a value from the unordered_set
 * @param set Pointer to the unordered_set
 * @param value Value to remove
 * @return 1 if removed, 0 if not found
 */
int unordered_set_int_remove(void* set, int value);

// ============================================================================
// Unordered Map Wrappers
// ============================================================================

/**
 * Creates a new unordered_map with int key and int value
 * @return Pointer to the unordered_map
 */
void* unordered_map_int_int_create();

/**
 * Destroys an unordered_map
 * @param map Pointer to the unordered_map to destroy
 */
void unordered_map_int_int_destroy(void* map);

/**
 * Inserts a key-value pair into the unordered_map
 * @param map Pointer to the unordered_map
 * @param key Integer key
 * @param value Integer value
 * @return 1 if inserted, 0 if key already existed (updated)
 */
int unordered_map_int_int_insert(void* map, int key, int value);

/**
 * Gets a value from the unordered_map by key
 * @param map Pointer to the unordered_map
 * @param key Integer key to look up
 * @param out_value Pointer to store the found value (if found)
 * @return 1 if found, 0 if not found
 */
int unordered_map_int_int_get(void* map, int key, int* out_value);

/**
 * Checks if a key exists in the unordered_map
 * @param map Pointer to the unordered_map
 * @param key Key to check
 * @return 1 if exists, 0 if not
 */
int unordered_map_int_int_contains(void* map, int key);

/**
 * Gets the size of the unordered_map
 * @param map Pointer to the unordered_map
 * @return Number of key-value pairs
 */
size_t unordered_map_int_int_size(void* map);

/**
 * Removes a key-value pair from the unordered_map
 * @param map Pointer to the unordered_map
 * @param key Key to remove
 * @return 1 if removed, 0 if not found
 */
int unordered_map_int_int_remove(void* map, int key);

// ============================================================================
// Priority Queue Wrappers
// ============================================================================

/**
 * Creates a new priority_queue (max-heap by default)
 * @return Pointer to the priority_queue
 */
void* priority_queue_int_create();

/**
 * Destroys a priority_queue
 * @param pq Pointer to the priority_queue to destroy
 */
void priority_queue_int_destroy(void* pq);

/**
 * Pushes a value onto the priority_queue
 * @param pq Pointer to the priority_queue
 * @param value Integer value to push
 */
void priority_queue_int_push(void* pq, int value);

/**
 * Gets the top element from the priority_queue without removing it
 * @param pq Pointer to the priority_queue
 * @return The largest element, or 0 if empty
 */
int priority_queue_int_top(void* pq);

/**
 * Removes the top element from the priority_queue
 * @param pq Pointer to the priority_queue
 */
void priority_queue_int_pop(void* pq);

/**
 * Checks if the priority_queue is empty
 * @param pq Pointer to the priority_queue
 * @return 1 if empty, 0 if not
 */
int priority_queue_int_empty(void* pq);

/**
 * Gets the size of the priority_queue
 * @param pq Pointer to the priority_queue
 * @return Number of elements
 */
size_t priority_queue_int_size(void* pq);

} // extern "C"

#endif // STL_WRAPPERS_HPP
