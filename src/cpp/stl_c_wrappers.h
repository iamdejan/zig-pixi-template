/**
 * @file stl_c_wrappers.h
 * @brief Pure C header for STL container wrappers (C ABI)
 * 
 * This header provides C-compatible function declarations that wrap
 * C++ STL containers. It can be used with Zig's @cImport without
 * requiring C++ header parsing.
 */

#ifndef STL_C_WRAPPERS_H
#define STL_C_WRAPPERS_H

#include <stddef.h>

#ifdef __cplusplus
extern "C" {
#endif

// ============================================================================
// Unordered Set Wrappers
// ============================================================================

void* unordered_set_int_create(void);
void unordered_set_int_destroy(void* set);
int unordered_set_int_insert(void* set, int value);
int unordered_set_int_contains(void* set, int value);
size_t unordered_set_int_size(void* set);
int unordered_set_int_remove(void* set, int value);

// ============================================================================
// Unordered Map Wrappers
// ============================================================================

void* unordered_map_int_int_create(void);
void unordered_map_int_int_destroy(void* map);
int unordered_map_int_int_insert(void* map, int key, int value);
int unordered_map_int_int_get(void* map, int key, int* out_value);
int unordered_map_int_int_contains(void* map, int key);
size_t unordered_map_int_int_size(void* map);
int unordered_map_int_int_remove(void* map, int key);

// ============================================================================
// Priority Queue Wrappers
// ============================================================================

void* priority_queue_int_create(void);
void priority_queue_int_destroy(void* pq);
void priority_queue_int_push(void* pq, int value);
int priority_queue_int_top(void* pq);
void priority_queue_int_pop(void* pq);
int priority_queue_int_empty(void* pq);
size_t priority_queue_int_size(void* pq);

#ifdef __cplusplus
}
#endif

#endif // STL_C_WRAPPERS_H
