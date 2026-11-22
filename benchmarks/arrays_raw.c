/* Array & loop benchmark — C with raw unchecked pointers (no bounds checks).
 *
 *   1. vec_kernel: 60 rounds of 1,000,000-element vector math (dst[i] = a[i]*3 + b[i] + r)
 *   2. sieve_count: Sieve of Eratosthenes below 5,000,000
 *
 * Build: clang -O2 -o arrays_c_raw benchmarks/arrays_raw.c
 */

#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

static void vec_step(long *dst, const long *a, const long *b, long n, long r) {
    for (long i = 0; i < n; i++) {
        dst[i] = a[i] * 3 + b[i] + r;
    }
}

static long vec_kernel(long n, long rounds) {
    long *a = calloc((size_t)n, sizeof(long));
    long *b = calloc((size_t)n, sizeof(long));
    long *dst = calloc((size_t)n, sizeof(long));
    for (long i = 0; i < n; i++) {
        a[i] = (i * 7 + 3) % 1000;
        b[i] = (i * 13 + 5) % 1000;
    }

    long checksum = 0;
    for (long r = 0; r < rounds; r++) {
        vec_step(dst, a, b, n, r);
        long idx = r % n;
        checksum = (checksum + dst[idx] + dst[(n - 1) - idx]) % 1000000007L;
    }

    long total = checksum;
    for (long i = 0; i < n; i++) {
        total = (total + dst[i]) % 1000000007L;
    }

    free(a);
    free(b);
    free(dst);
    return total;
}

static long sieve_count(long limit) {
    bool *is_prime = malloc((size_t)limit);
    for (long i = 0; i < limit; i++) {
        is_prime[i] = true;
    }
    is_prime[0] = false;
    is_prime[1] = false;

    long p = 2;
    while (p * p < limit) {
        if (is_prime[p]) {
            long j = p * p;
            while (j < limit) {
                is_prime[j] = false;
                j += p;
            }
        }
        p += 1;
    }

    long count = 0;
    for (long i = 2; i < limit; i++) {
        if (is_prime[i]) {
            count += 1;
        }
    }

    free(is_prime);
    return count;
}

int main(void) {
    printf("%ld\n", vec_kernel(1000000L, 60L));
    printf("%ld\n", sieve_count(5000000L));
    return 0;
}
