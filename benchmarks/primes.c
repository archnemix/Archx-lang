/*
 * Benchmark workload, shared by C, Rust and Archx.
 *
 *   1. sum of squares, reduced mod 1_000_007 so the accumulator stays small
 *   2. prime counting by trial division (nested loops, branch, early break)
 *
 * Both are deliberately plain: no SIMD intrinsics, no unsafe, no clever
 * tricks. Whatever the compiler does with them, it has to do on its own.
 *
 * Build:  clang -O2 -o primes_c primes.c
 */

#include <stdio.h>

#define SUM_N 20000000
#define PRIME_LIMIT 400000

static long sum_squares(long n) {
    long total = 0;
    for (long i = 0; i < n; i++) {
        total = (total + i * i) % 1000007;
    }
    return total;
}

static long count_primes(long limit) {
    long count = 0;
    for (long n = 2; n < limit; n++) {
        int is_prime = 1;
        for (long d = 2; d * d <= n; d++) {
            if (n % d == 0) {
                is_prime = 0;
                break;
            }
        }
        if (is_prime) {
            count++;
        }
    }
    return count;
}

int main(void) {
    printf("%ld\n", sum_squares(SUM_N));
    printf("%ld\n", count_primes(PRIME_LIMIT));
    return 0;
}
