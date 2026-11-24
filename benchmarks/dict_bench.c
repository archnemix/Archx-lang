/* Suite 5 (C): Open-addressed AoS hash tables for string->i64 and i64->i64.
 * Mirrors benchmarks/dict_bench.{rs,archx.lang} and dict_dynamic.archx.lang. */

#include <inttypes.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static uint64_t fnv1a_str(const char *s) {
    uint64_t h = 14695981039346656037ULL;
    for (const unsigned char *p = (const unsigned char *)s; *p; ++p) {
        h ^= (uint64_t)(*p);
        h *= 1099511628211ULL;
    }
    return h;
}

static uint64_t hash_i64(int64_t k) {
    uint64_t x = (uint64_t)k;
    x ^= x >> 33;
    x *= 0xff51afd7ed558ccdULL;
    x ^= x >> 33;
    return x;
}

/* --- String -> int64 AoS open-addressing table --- */
typedef struct {
    char *key;
    int64_t val;
    uint8_t state; /* 0 = empty, 1 = full */
} StrEntry;

typedef struct {
    StrEntry *entries;
    size_t cap;
    size_t len;
} StrMap;

static void strmap_init(StrMap *m, size_t cap) {
    m->cap = cap;
    m->len = 0;
    m->entries = (StrEntry *)calloc(cap, sizeof(StrEntry));
}

static void strmap_free(StrMap *m) {
    for (size_t i = 0; i < m->cap; ++i) {
        if (m->entries[i].state == 1) {
            free(m->entries[i].key);
        }
    }
    free(m->entries);
}

static void strmap_rehash(StrMap *m, size_t ncap) {
    StrEntry *old = m->entries;
    size_t ocap = m->cap;
    m->entries = (StrEntry *)calloc(ncap, sizeof(StrEntry));
    m->cap = ncap;
    size_t mask = ncap - 1;
    for (size_t i = 0; i < ocap; ++i) {
        if (old[i].state == 1) {
            size_t pos = (size_t)fnv1a_str(old[i].key) & mask;
            while (m->entries[pos].state == 1) {
                pos = (pos + 1) & mask;
            }
            m->entries[pos] = old[i];
        }
    }
    free(old);
}

static int64_t *strmap_upsert(StrMap *m, const char *key) {
    if ((m->len + 1) * 10 >= m->cap * 7) {
        strmap_rehash(m, m->cap * 2);
    }
    size_t mask = m->cap - 1;
    size_t pos = (size_t)fnv1a_str(key) & mask;
    while (m->entries[pos].state == 1) {
        if (strcmp(m->entries[pos].key, key) == 0) {
            return &m->entries[pos].val;
        }
        pos = (pos + 1) & mask;
    }
    size_t klen = strlen(key);
    char *copy = (char *)malloc(klen + 1);
    memcpy(copy, key, klen + 1);
    m->entries[pos].key = copy;
    m->entries[pos].val = 0;
    m->entries[pos].state = 1;
    m->len++;
    return &m->entries[pos].val;
}

static const int64_t *strmap_find(const StrMap *m, const char *key) {
    size_t mask = m->cap - 1;
    size_t pos = (size_t)fnv1a_str(key) & mask;
    while (m->entries[pos].state == 1) {
        if (strcmp(m->entries[pos].key, key) == 0) {
            return &m->entries[pos].val;
        }
        pos = (pos + 1) & mask;
    }
    return NULL;
}

/* --- int64 -> int64 AoS open-addressing table with tombstones --- */
typedef struct {
    int64_t key;
    int64_t val;
    uint8_t state; /* 0 = empty, 1 = full, 2 = deleted */
} IntEntry;

typedef struct {
    IntEntry *entries;
    size_t cap;
    size_t len;
    size_t used;
} IntMap;

static void intmap_init(IntMap *m, size_t cap) {
    m->cap = cap;
    m->len = 0;
    m->used = 0;
    m->entries = (IntEntry *)calloc(cap, sizeof(IntEntry));
}

static void intmap_free(IntMap *m) { free(m->entries); }

static void intmap_rehash(IntMap *m, size_t ncap) {
    IntEntry *old = m->entries;
    size_t ocap = m->cap;
    m->entries = (IntEntry *)calloc(ncap, sizeof(IntEntry));
    m->cap = ncap;
    m->used = m->len;
    size_t mask = ncap - 1;
    for (size_t i = 0; i < ocap; ++i) {
        if (old[i].state == 1) {
            size_t pos = (size_t)hash_i64(old[i].key) & mask;
            while (m->entries[pos].state == 1) {
                pos = (pos + 1) & mask;
            }
            m->entries[pos] = old[i];
        }
    }
    free(old);
}

static void intmap_put(IntMap *m, int64_t key, int64_t val) {
    if ((m->used + 1) * 10 >= m->cap * 7) {
        size_t ncap = (m->len * 2 < m->cap) ? m->cap : m->cap * 2;
        intmap_rehash(m, ncap);
    }
    size_t mask = m->cap - 1;
    size_t pos = (size_t)hash_i64(key) & mask;
    int64_t first_del = -1;
    while (m->entries[pos].state != 0) {
        if (m->entries[pos].state == 1 && m->entries[pos].key == key) {
            m->entries[pos].val = val;
            return;
        }
        if (m->entries[pos].state == 2 && first_del < 0) {
            first_del = (int64_t)pos;
        }
        pos = (pos + 1) & mask;
    }
    size_t dst = (first_del >= 0) ? (size_t)first_del : pos;
    if (first_del < 0) {
        m->used++;
    }
    m->entries[dst].key = key;
    m->entries[dst].val = val;
    m->entries[dst].state = 1;
    m->len++;
}

static int64_t intmap_pop(IntMap *m, int64_t key) {
    size_t mask = m->cap - 1;
    size_t pos = (size_t)hash_i64(key) & mask;
    while (m->entries[pos].state != 0) {
        if (m->entries[pos].state == 1 && m->entries[pos].key == key) {
            int64_t v = m->entries[pos].val;
            m->entries[pos].state = 2;
            m->len--;
            return v;
        }
        pos = (pos + 1) & mask;
    }
    abort();
}

int main(void) {
    char *vocab[1024];
    for (int i = 0; i < 1024; ++i) {
        vocab[i] = (char *)malloc(32);
        if ((i % 2) == 0) {
            sprintf(vocab[i], "tok_%d", i);
        } else {
            sprintf(vocab[i], "identifier_token_%d", i);
        }
    }

    int64_t str_checksum = 0;
    const char *miss = "missing_token_xyz";
    for (int64_t r = 0; r < 120; ++r) {
        StrMap counts;
        strmap_init(&counts, 8);
        for (int64_t i = 0; i < 1024; ++i) {
            *strmap_upsert(&counts, vocab[i]) = 1;
        }
        for (int64_t step = 0; step < 8192; ++step) {
            int64_t idx = (step * 73 + r * 19) % 1024;
            int64_t *slot = strmap_upsert(&counts, vocab[idx]);
            *slot = *slot + (step % 7) + 1;
        }
        for (int64_t p = 0; p < 2048; ++p) {
            int64_t pidx = (p * 131 + r * 7) % 1024;
            const int64_t *found = strmap_find(&counts, vocab[pidx]);
            if (found != NULL) {
                str_checksum += *found;
            }
        }
        if (strmap_find(&counts, miss) == NULL) {
            const int64_t *g = strmap_find(&counts, miss);
            str_checksum += (g != NULL) ? *g : 3;
        }
        for (size_t b = 0; b < counts.cap; ++b) {
            if (counts.entries[b].state == 1) {
                str_checksum += counts.entries[b].val;
            }
        }
        strmap_free(&counts);
    }

    IntMap tab;
    intmap_init(&tab, 8);
    for (int64_t i = 0; i < 32768; ++i) {
        int64_t k = i * 17 + 3;
        intmap_put(&tab, k, (i * 31 + 7) % 100000);
    }
    int64_t popped_sum = 0;
    for (int64_t i = 0; i < 32768; i += 4) {
        int64_t k = i * 17 + 3;
        popped_sum += intmap_pop(&tab, k);
    }
    for (int64_t j = 0; j < 8192; ++j) {
        int64_t nk = 1000000 + j * 13;
        intmap_put(&tab, nk, j * 5 + 1);
    }

    int64_t int_checksum = popped_sum + (int64_t)tab.len;
    for (int pass = 0; pass < 40; ++pass) {
        for (size_t b = 0; b < tab.cap; ++b) {
            if (tab.entries[b].state == 1) {
                int_checksum += (tab.entries[b].key % 997) * tab.entries[b].val;
            }
        }
    }

    intmap_free(&tab);
    for (int i = 0; i < 1024; ++i) {
        free(vocab[i]);
    }

    printf("%" PRId64 "\n%" PRId64 "\n", str_checksum, int_checksum);
    return 0;
}
