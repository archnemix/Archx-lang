/* Array & loop benchmark — C with bounds-checked slice structs (same safety
 * contract as Rust and Archx: every read/write verifies 0 <= i < len).
 *
 * Build: clang -O2 -o arrays_c_checked benchmarks/arrays_checked.c
 */

#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

typedef struct {
    long *data;
    long len;
} IntVec;

typedef struct {
    bool *data;
    long len;
} BoolVec;

static inline long get_int(const IntVec *v, long i) {
    if (i < 0 || i >= v->len) {
        exit(101);
    }
    return v->data[i];
}

static inline void set_int(IntVec *v, long i, long val) {
    if (i < 0 || i >= v->len) {
        exit(101);
    }
    v->data[i] = val;
}

static inline bool get_bool(const BoolVec *v, long i) {
    if (i < 0 || i >= v->len) {
        exit(101);
    }
    return v->data[i];
}

static inline void set_bool(BoolVec *v, long i, bool val) {
    if (i < 0 || i >= v->len) {
        exit(101);
    }
    v->data[i] = val;
}

static void vec_step(IntVec *dst, const IntVec *a, const IntVec *b, long r) {
    for (long i = 0; i < dst->len; i++) {
        set_int(dst, i, get_int(a, i) * 3 + get_int(b, i) + r);
    }
}

static long vec_kernel(long n, long rounds) {
    IntVec a = {calloc((size_t)n, sizeof(long)), n};
    IntVec b = {calloc((size_t)n, sizeof(long)), n};
    IntVec dst = {calloc((size_t)n, sizeof(long)), n};

    for (long i = 0; i < n; i++) {
        set_int(&a, i, (i * 7 + 3) % 1000);
        set_int(&b, i, (i * 13 + 5) % 1000);
    }

    long checksum = 0;
    for (long r = 0; r < rounds; r++) {
        vec_step(&dst, &a, &b, r);
        long idx = r % n;
        checksum = (checksum + get_int(&dst, idx) + get_int(&dst, (n - 1) - idx)) % 1000000007L;
    }

    long total = checksum;
    for (long i = 0; i < n; i++) {
        total = (total + get_int(&dst, i)) % 1000000007L;
    }

    free(a.data);
    free(b.data);
    free(dst.data);
    return total;
}

static long sieve_count(long limit) {
    BoolVec is_prime = {malloc((size_t)limit), limit};
    for (long i = 0; i < limit; i++) {
        set_bool(&is_prime, i, true);
    }
    set_bool(&is_prime, 0, false);
    set_bool(&is_prime, 1, false);

    long p = 2;
    while (p * p < limit) {
        if (get_bool(&is_prime, p)) {
            long j = p * p;
            while (j < limit) {
                set_bool(&is_prime, j, false);
                j += p;
            }
        }
        p += 1;
    }

    long count = 0;
    for (long i = 2; i < limit; i++) {
        if (get_bool(&is_prime, i)) {
            count += 1;
        }
    }

    free(is_prime.data);
    return count;
}

int main(void) {
    printf("%ld\n", vec_kernel(1000000L, 60L));
    printf("%ld\n", sieve_count(5000000L));
    return 0;
}
