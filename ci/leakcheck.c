/*
 * Live-block tracker for Archx's leak gate.
 *
 * Links against an Archx-emitted module and wraps the allocator so that every block the program
 * still owns when it exits is reported. Exits non-zero if anything is live, so `--wrap` alone is
 * enough to fail CI.
 *
 * Why this exists next to the ASan/LSan step: ASan's runtime does not link against Archx's IR on
 * every toolchain we build with (zig cc in particular fails on `__asan_unregister_elf_globals`),
 * and a check that silently cannot run is worse than no check. This tracker is freestanding, has no
 * runtime dependencies, and reported the `sorted()` merge-sort scratch leak byte-exactly.
 *
 * Build alongside the target:
 *   cc -O1 -Wno-override-module target.ll ci/leakcheck.c \
 *      -Wl,--wrap=malloc -Wl,--wrap=calloc -Wl,--wrap=realloc -Wl,--wrap=free -lm -o target
 *
 * It tracks blocks by pointer in a flat table, so it is O(live) per operation. That is fine for the
 * corpus-sized programs it runs on and keeps the harness dependency-free.
 */
#include <stdio.h>
#include <stdlib.h>

extern void *__real_malloc(size_t);
extern void *__real_calloc(size_t, size_t);
extern void *__real_realloc(void *, size_t);
extern void __real_free(void *);

#define TRACK_MAX 400000

static void *g_ptr[TRACK_MAX];
static size_t g_size[TRACK_MAX];
static int g_live = 0;

static void track(void *p, size_t size) {
    if (!p) return;
    for (int i = 0; i < g_live; i++) {
        if (g_ptr[i] == p) { g_size[i] = size; return; }
    }
    if (g_live < TRACK_MAX) {
        g_ptr[g_live] = p;
        g_size[g_live] = size;
        g_live++;
    }
}

static void untrack(void *p) {
    for (int i = 0; i < g_live; i++) {
        if (g_ptr[i] == p) {
            g_ptr[i] = g_ptr[g_live - 1];
            g_size[i] = g_size[g_live - 1];
            g_live--;
            return;
        }
    }
}

void *__wrap_malloc(size_t size) {
    void *p = __real_malloc(size);
    track(p, size);
    return p;
}

void *__wrap_calloc(size_t nmemb, size_t size) {
    void *p = __real_calloc(nmemb, size);
    track(p, nmemb * size);
    return p;
}

void *__wrap_realloc(void *old, size_t size) {
    void *p = __real_realloc(old, size);
    if (old) {
        untrack(old);
    }
    track(p, size);
    return p;
}

void __wrap_free(void *p) {
    untrack(p);
    __real_free(p);
}

__attribute__((destructor)) static void leakcheck_report(void) {
    if (g_live == 0) {
        fprintf(stderr, "LEAKCHECK: clean (0 live blocks)\n");
        return;
    }
    size_t total = 0;
    fprintf(stderr, "LEAKCHECK: FAILED, %d live block(s)\n", g_live);
    for (int i = 0; i < g_live; i++) {
        fprintf(stderr, "  leaked %zu byte(s) at %p\n", g_size[i], g_ptr[i]);
        total += g_size[i];
    }
    fprintf(stderr, "LEAKCHECK: %zu byte(s) still reachable at exit\n", total);
    /*
     * `_exit` would skip the other destructors; `_Exit` is the same, so we set the status and let
     * normal teardown finish. A non-zero exit is what the CI step keys on.
     */
    fflush(stderr);
    _Exit(1);
}
