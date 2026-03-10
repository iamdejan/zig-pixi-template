/**
 * @file stl_wrappers.cpp
 * @brief Implementation of C++ STL container wrappers for Zig interop
 * 
 * This file implements the C functions that wrap STL containers (unordered_set,
 * unordered_map, priority_queue) to allow Zig to interact with them via C ABI.
 */

#include "stl_c_wrappers.h"

#include <unordered_set>
#include <unordered_map>
#include <queue>

// ============================================================================
// Unordered Set Implementation
// ============================================================================

void* unordered_set_int_create() {
    return new std::unordered_set<int>();
}

void unordered_set_int_destroy(void* set) {
    delete static_cast<std::unordered_set<int>*>(set);
}

int unordered_set_int_insert(void* set, int value) {
    auto* s = static_cast<std::unordered_set<int>*>(set);
    return s->insert(value).second ? 1 : 0;
}

int unordered_set_int_contains(void* set, int value) {
    auto* s = static_cast<std::unordered_set<int>*>(set);
    return s->count(value) > 0 ? 1 : 0;
}

size_t unordered_set_int_size(void* set) {
    auto* s = static_cast<std::unordered_set<int>*>(set);
    return s->size();
}

int unordered_set_int_remove(void* set, int value) {
    auto* s = static_cast<std::unordered_set<int>*>(set);
    return s->erase(value) > 0 ? 1 : 0;
}

// ============================================================================
// Unordered Map Implementation
// ============================================================================

void* unordered_map_int_int_create() {
    return new std::unordered_map<int, int>();
}

void unordered_map_int_int_destroy(void* map) {
    delete static_cast<std::unordered_map<int, int>*>(map);
}

int unordered_map_int_int_insert(void* map, int key, int value) {
    auto* m = static_cast<std::unordered_map<int, int>*>(map);
    return m->emplace(key, value).second ? 1 : 0;
}

int unordered_map_int_int_get(void* map, int key, int* out_value) {
    auto* m = static_cast<std::unordered_map<int, int>*>(map);
    auto it = m->find(key);
    if (it != m->end()) {
        if (out_value) {
            *out_value = it->second;
        }
        return 1;
    }
    return 0;
}

int unordered_map_int_int_contains(void* map, int key) {
    auto* m = static_cast<std::unordered_map<int, int>*>(map);
    return m->count(key) > 0 ? 1 : 0;
}

size_t unordered_map_int_int_size(void* map) {
    auto* m = static_cast<std::unordered_map<int, int>*>(map);
    return m->size();
}

int unordered_map_int_int_remove(void* map, int key) {
    auto* m = static_cast<std::unordered_map<int, int>*>(map);
    return m->erase(key) > 0 ? 1 : 0;
}

// ============================================================================
// Priority Queue Implementation
// ============================================================================

void* priority_queue_int_create() {
    return new std::priority_queue<int>();
}

void priority_queue_int_destroy(void* pq) {
    delete static_cast<std::priority_queue<int>*>(pq);
}

void priority_queue_int_push(void* pq, int value) {
    auto* q = static_cast<std::priority_queue<int>*>(pq);
    q->push(value);
}

int priority_queue_int_top(void* pq) {
    auto* q = static_cast<std::priority_queue<int>*>(pq);
    if (q->empty()) {
        return 0;
    }
    return q->top();
}

void priority_queue_int_pop(void* pq) {
    auto* q = static_cast<std::priority_queue<int>*>(pq);
    if (!q->empty()) {
        q->pop();
    }
}

int priority_queue_int_empty(void* pq) {
    auto* q = static_cast<std::priority_queue<int>*>(pq);
    return q->empty() ? 1 : 0;
}

size_t priority_queue_int_size(void* pq) {
    auto* q = static_cast<std::priority_queue<int>*>(pq);
    return q->size();
}
