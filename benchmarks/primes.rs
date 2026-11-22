//! Benchmark workload, shared by C, Rust and Archx.
//!
//!   1. sum of squares, reduced mod 1_000_007 so the accumulator stays small
//!   2. prime counting by trial division (nested loops, branch, early break)
//!
//! Build:  rustc -O2 -o primes_rs primes.rs

const SUM_N: i64 = 20_000_000;
const PRIME_LIMIT: i64 = 400_000;

fn sum_squares(n: i64) -> i64 {
    let mut total: i64 = 0;
    for i in 0..n {
        total = (total + i * i) % 1_000_007;
    }
    total
}

fn count_primes(limit: i64) -> i64 {
    let mut count: i64 = 0;
    for n in 2..limit {
        let mut is_prime = true;
        let mut d: i64 = 2;
        while d * d <= n {
            if n % d == 0 {
                is_prime = false;
                break;
            }
            d += 1;
        }
        if is_prime {
            count += 1;
        }
    }
    count
}

fn main() {
    println!("{}", sum_squares(SUM_N));
    println!("{}", count_primes(PRIME_LIMIT));
}
