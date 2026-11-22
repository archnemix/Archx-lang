//! Array & loop benchmark — safe Rust (`Vec<i64>` / `Vec<bool>`, bounds-checked).
//!
//! Build: rustc -O -o arrays_rs benchmarks/arrays.rs

fn vec_step(dst: &mut [i64], a: &[i64], b: &[i64], r: i64) {
    for i in 0..dst.len() {
        dst[i] = a[i] * 3 + b[i] + r;
    }
}

fn vec_kernel(n: usize, rounds: i64) -> i64 {
    let mut a = vec![0i64; n];
    let mut b = vec![0i64; n];
    let mut dst = vec![0i64; n];

    for i in 0..n {
        let idx = i as i64;
        a[i] = (idx * 7 + 3) % 1000;
        b[i] = (idx * 13 + 5) % 1000;
    }

    let mut checksum: i64 = 0;
    for r in 0..rounds {
        vec_step(&mut dst, &a, &b, r);
        let idx = (r as usize) % n;
        checksum = (checksum + dst[idx] + dst[(n - 1) - idx]) % 1_000_000_007;
    }

    let mut total = checksum;
    for i in 0..n {
        total = (total + dst[i]) % 1_000_000_007;
    }
    total
}

fn sieve_count(limit: usize) -> i64 {
    let mut is_prime = vec![true; limit];
    is_prime[0] = false;
    is_prime[1] = false;

    let mut p: usize = 2;
    while p * p < limit {
        if is_prime[p] {
            let mut j = p * p;
            while j < limit {
                is_prime[j] = false;
                j += p;
            }
        }
        p += 1;
    }

    let mut count: i64 = 0;
    for i in 2..limit {
        if is_prime[i] {
            count += 1;
        }
    }
    count
}

fn main() {
    println!("{}", vec_kernel(1_000_000, 60));
    println!("{}", sieve_count(5_000_000));
}
