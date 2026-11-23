/*
 * Composite Milestone 5 benchmark — idiomatic C:
 *   1. particle_sim: 100,000 6-field `Body` structs (48B AoS), 120 timesteps
 *      with full-array integration + strided impulse (`i += 8`) + reduction.
 *   2. arena_and_strings: 40,000 rounds of variable-length scratch buffer
 *      allocation + dynamic short/long string concatenation & equality checks.
 *
 * Build: clang -O2 -o composite_c benchmarks/composite.c
 */

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MOD 1000000007LL

typedef struct {
    int64_t x;
    int64_t y;
    int64_t z;
    int64_t vx;
    int64_t vy;
    int64_t vz;
} Body;

static int64_t particle_sim(int64_t n, int64_t steps) {
    Body *bodies = (Body *)malloc((size_t)n * sizeof(Body));
    if (!bodies) abort();

    for (int64_t i = 0; i < n; i++) {
        bodies[i].x = i * 3;
        bodies[i].y = i * 5;
        bodies[i].z = i * 7;
        bodies[i].vx = (i % 7) + 1;
        bodies[i].vy = (i % 5) + 1;
        bodies[i].vz = (i % 3) + 1;
    }

    for (int64_t t = 0; t < steps; t++) {
        int64_t imp = (t % 3) - 1;
        for (int64_t i = 0; i < n; i++) {
            bodies[i].x += bodies[i].vx;
            bodies[i].y -= bodies[i].vy;
        }
        for (int64_t i = 0; i < n; i += 8) {
            bodies[i].z += bodies[i].vz + imp;
        }
    }

    int64_t acc = 0;
    for (int64_t i = 0; i < n; i++) {
        acc = (acc + bodies[i].x + bodies[i].y + bodies[i].z) % MOD;
    }

    free(bodies);
    return acc;
}

static char *concat_cstr(const char *a, const char *b, size_t *out_len) {
    size_t la = strlen(a);
    size_t lb = strlen(b);
    size_t tot = la + lb;
    char *buf = (char *)malloc(tot + 1);
    if (!buf) abort();
    memcpy(buf, a, la);
    memcpy(buf + la, b, lb + 1);
    *out_len = tot;
    return buf;
}

static int64_t arena_and_strings(int64_t rounds, int64_t base_len) {
    int64_t total = 0;
    for (int64_t r = 0; r < rounds; r++) {
        int64_t sz = base_len + (r % 16);
        int64_t *buf = (int64_t *)calloc((size_t)sz, sizeof(int64_t));
        if (!buf) abort();

        for (int64_t k = 0; k < sz; k += 4) {
            buf[k] = r + k * 3;
        }
        int64_t probe = (r * 7) % sz;
        int64_t s_acc = buf[0] + buf[probe] + buf[sz - 1];

        const char *s_rhs = (r % 2 == 0) ? "alpha0" : "beta99";
        size_t len1 = 0;
        char *s1 = concat_cstr("id_", s_rhs, &len1);

        const char *l_rhs = (r % 4 == 0) ? "payload_v2_a" : "other_kind_b";
        size_t len2 = 0;
        char *s2 = concat_cstr("packet_header_", l_rhs, &len2);

        if (strcmp(s1, "id_alpha0") == 0) {
            s_acc += 17;
        }
        if (strcmp(s2, "packet_header_payload_v2_a") == 0) {
            s_acc += 43;
        }
        if (strcmp(s2, "packet_header_never_match!") == 0) {
            s_acc += 99;
        }

        total = (total + s_acc + (int64_t)len1 + (int64_t)len2) % MOD;

        free(s2);
        free(s1);
        free(buf);
    }
    return total;
}

int main(void) {
    printf("%lld\n", (long long)particle_sim(100000, 120));
    printf("%lld\n", (long long)arena_and_strings(40000, 256));
    return 0;
}
