/*
 * Archx 5-Way Full-Feature Comparison — Edition 4: Clang C (`clang -O2 -lm`)
 *
 * Idiomatic C implementation of the exact same 4-stage full-tour workload:
 *   1. AoS `Body*` central-field physics simulation (`simulate_field`)
 *   2. Open-addressing string hash table + integer set + string/slice ops (`dict_and_slicing_tour`)
 *   3. Struct out-tuple + tagged-optional search (`analyze_series` & `find_spike`)
 *   4. Tagged union `Event` + `switch` dispatch (`dispatch_events`)
 */

#include <ctype.h>
#include <math.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
    double x;
    double y;
    double vx;
    double vy;
    double mass;
} Body;

static inline double body_kinetic(const Body *b) {
    return 0.5 * b->mass * (b->vx * b->vx + b->vy * b->vy);
}

static int64_t simulate_field(int64_t n, int64_t steps) {
    Body *bodies = (Body *)malloc((size_t)n * sizeof(Body));
    if (!bodies) abort();

    for (int64_t i = 0; i < n; i++) {
        double fi = (double)(i + 1);
        bodies[i].x = fi * 0.001;
        bodies[i].y = fi * -0.002;
        bodies[i].vx = 0.02;
        bodies[i].vy = -0.015;
        bodies[i].mass = 1.0 + fi * 0.0002;
    }

    const double dt = 0.01;
    for (int64_t s = 0; s < steps; s++) {
        for (int64_t i = 0; i < n; i++) {
            double bx = bodies[i].x;
            double by = bodies[i].y;
            double r2 = bx * bx + by * by + 1.0;
            double inv = dt / sqrt(r2);
            bodies[i].vx -= bx * inv;
            bodies[i].vy -= by * inv;
            bodies[i].x += bodies[i].vx * dt;
            bodies[i].y += bodies[i].vy * dt;
        }
    }

    double ke = 0.0;
    for (int64_t i = 0; i < n; i++) {
        ke += body_kinetic(&bodies[i]);
    }
    free(bodies);
    return (int64_t)(ke * 1000.0);
}

/* Open-addressing AoS string->int64 hash table (cap = 1024) */
typedef struct {
    const char *key;
    uint64_t hash;
    int64_t val;
    bool used;
} StrEntry;

static inline uint64_t fnv1a_str(const char *s) {
    uint64_t h = 14695981039346656037ULL;
    for (const unsigned char *p = (const unsigned char *)s; *p; p++) {
        h ^= (uint64_t)(*p);
        h *= 1099511628211ULL;
    }
    return h;
}

static void strtab_upsert_add(StrEntry *tab, size_t mask, const char *key, int64_t delta, bool set_mode) {
    uint64_t h = fnv1a_str(key);
    size_t idx = (size_t)h & mask;
    for (;;) {
        if (!tab[idx].used) {
            tab[idx].used = true;
            tab[idx].key = key;
            tab[idx].hash = h;
            tab[idx].val = delta;
            return;
        }
        if (tab[idx].hash == h && strcmp(tab[idx].key, key) == 0) {
            if (set_mode) tab[idx].val = delta;
            else tab[idx].val += delta;
            return;
        }
        idx = (idx + 1) & mask;
    }
}

static int64_t strtab_get(const StrEntry *tab, size_t mask, const char *key, int64_t defval, bool *found) {
    uint64_t h = fnv1a_str(key);
    size_t idx = (size_t)h & mask;
    for (;;) {
        if (!tab[idx].used) {
            if (found) *found = false;
            return defval;
        }
        if (tab[idx].hash == h && strcmp(tab[idx].key, key) == 0) {
            if (found) *found = true;
            return tab[idx].val;
        }
        idx = (idx + 1) & mask;
    }
}

typedef struct {
    int64_t checksum;
    char banner[32];
} DictTourOut;

static DictTourOut dict_and_slicing_tour(int64_t rounds) {
    char *vocab[512];
    for (int i = 0; i < 512; i++) {
        if (i % 2 == 0) {
            vocab[i] = (char *)malloc(24);
            snprintf(vocab[i], 24, "tok_%d", i);
        } else {
            char raw[64];
            snprintf(raw, sizeof(raw), "   Telemetry_Channel_%d  ", i);
            const char *start = raw;
            while (*start && isspace((unsigned char)*start)) start++;
            const char *end = raw + strlen(raw);
            while (end > start && isspace((unsigned char)*(end - 1))) end--;
            size_t len = (size_t)(end - start);
            vocab[i] = (char *)malloc(len + 1);
            for (size_t k = 0; k < len; k++) {
                vocab[i][k] = (char)tolower((unsigned char)start[k]);
            }
            vocab[i][len] = '\0';
        }
    }

    DictTourOut out;
    const char *src_banner = "archx_systems_python";
    size_t blen = strlen(src_banner);
    for (size_t i = 0; i < blen; i++) {
        out.banner[i] = src_banner[blen - 1 - i];
    }
    out.banner[blen] = '\0';

    int64_t checksum = 0;
    const char *miss = "absent_channel_key";

    for (int64_t r = 0; r < rounds; r++) {
        StrEntry *counts = (StrEntry *)calloc(1024, sizeof(StrEntry));
        bool *seen_slots = (bool *)calloc(512, sizeof(bool));
        int64_t seen_len = 0;

        for (int64_t i = 0; i < 512; i++) {
            strtab_upsert_add(counts, 1023, vocab[i], 1, true);
        }
        for (int64_t step = 0; step < 4096; step++) {
            int64_t idx = (step * 73 + r * 19) % 512;
            strtab_upsert_add(counts, 1023, vocab[idx], (step % 5) + 1, false);
            if (step < 64 && !seen_slots[idx]) {
                seen_slots[idx] = true;
                seen_len++;
            }
        }
        for (int64_t p = 0; p < 1024; p++) {
            const char *pk = vocab[(p * 131 + r * 7) % 512];
            checksum += strtab_get(counts, 1023, pk, 0, NULL);
        }
        bool has_miss = false;
        (void)strtab_get(counts, 1023, miss, 0, &has_miss);
        if (!has_miss) {
            checksum += seen_len;
        }
        for (size_t slot = 0; slot < 1024; slot++) {
            if (counts[slot].used) checksum += counts[slot].val;
        }
        free(counts);
        free(seen_slots);
    }

    for (int i = 0; i < 512; i++) free(vocab[i]);

    const int64_t nums[8] = {10, 25, 40, 55, 70, 85, 100, 115};
    int64_t sliced[3];
    size_t slen = 0;
    for (size_t i = 1; i < 7; i += 2) {
        sliced[slen++] = nums[i];
    }
    checksum += sliced[0] + sliced[slen - 1] + nums[7];
    out.checksum = checksum;
    return out;
}

typedef struct {
    int64_t lo;
    int64_t hi;
    int64_t total;
} Stats3;

static Stats3 analyze_series(const int64_t *xs, size_t n) {
    Stats3 s = {xs[0], xs[0], 0};
    for (size_t i = 0; i < n; i++) {
        if (xs[i] < s.lo) s.lo = xs[i];
        if (xs[i] > s.hi) s.hi = xs[i];
        s.total += xs[i];
    }
    return s;
}

typedef struct {
    bool has_value;
    int64_t value;
} OptInt;

static OptInt find_spike(const int64_t *xs, size_t n, int64_t threshold) {
    for (size_t i = 0; i < n; i++) {
        if (xs[i] >= threshold) {
            OptInt ok = {true, (int64_t)i * 1000 + xs[i]};
            return ok;
        }
    }
    OptInt none = {false, 0};
    return none;
}

typedef enum {
    EV_CIRCLE = 0,
    EV_RECT = 1,
    EV_SQUARE = 2,
    EV_PULSE = 3,
    EV_IDLE = 4
} EventTag;

typedef struct {
    EventTag tag;
    int64_t a;
    int64_t b;
} Event;

static int64_t dispatch_events(int64_t total_events) {
    int64_t acc = 0;
    for (int64_t i = 0; i < total_events; i++) {
        int64_t kind = i % 5;
        int64_t a = (i * 17 + 3) % 40;
        int64_t b = (i * 13 + 7) % 25;
        Event ev = {(EventTag)kind, a, b};
        switch (ev.tag) {
            case EV_CIRCLE:
                if (ev.a > 20) acc += ev.a * ev.a + 7;
                else acc += ev.a * 3 + 1;
                break;
            case EV_RECT:
                acc += ev.a * ev.b;
                break;
            case EV_SQUARE:
            case EV_PULSE:
                acc += ev.a * 4 + 2;
                break;
            case EV_IDLE:
                acc += 1;
                break;
        }
    }
    return acc;
}

int main(void) {
    int64_t mode = 8;
    int64_t sim_score = simulate_field(40000, 30);
    DictTourOut dt = dict_and_slicing_tour(60);

    int64_t series[64];
    for (int64_t i = 0; i < 64; i++) {
        series[i] = ((i * 37 + 11) % 97) + mode;
    }
    Stats3 st = analyze_series(series, 64);

    OptInt hit = find_spike(series, 64, 95);
    OptInt miss = find_spike(series, 64, 999);
    int64_t hit_out = hit.has_value ? (hit.value + 1) : -1;
    char miss_label[32];
    if (!miss.has_value) {
        snprintf(miss_label, sizeof(miss_label), "empty");
    } else {
        snprintf(miss_label, sizeof(miss_label), "val_%lld", (long long)miss.value);
    }

    int64_t dispatch_score = dispatch_events(200000);

    printf("sim=%lld\n", (long long)sim_score);
    printf("dict_slice=%lld,%s\n", (long long)dt.checksum, dt.banner);
    printf("tuple_opt=%lld,%lld,%lld,%lld,%s\n",
           (long long)st.lo, (long long)st.hi, (long long)st.total,
           (long long)hit_out, miss_label);
    printf("match_dispatch=%lld\n", (long long)dispatch_score);
    return 0;
}
