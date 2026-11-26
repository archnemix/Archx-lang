// Suite 7 (Rust reference, `rustc -O`): comprehension/generator pipelines, `zip`, and sorting.
//
// The Python edition of this suite is written entirely with comprehensions, generator folds
// (`sum`/`min`/`max`/`any`/`all`), `zip`, and `sorted(..., key=...)`. Rust has no comprehension
// syntax, so the same pipeline is spelled with `map`/`filter`/`collect` chains and `sort_by_key`
// (which is stable, like Archx and Python's `sorted`). The Archx edition consumes the Python
// source verbatim and lowers each stage inline: no closure objects, no boxed comparators, and a
// single pre-sized allocation per stage.

fn sweep(n: usize) -> i64 {
    let mut acc: i64 = 0;
    for i in 0..n {
        acc += ((i as i64) * 7919) % 10007;
    }
    acc
}

fn pipeline_a(n: usize) -> i64 {
    let data: Vec<i64> = (0..n as i64).collect();
    let squares: Vec<i64> = data.iter().map(|x| x * x).collect();
    let evens: Vec<i64> = squares.iter().copied().filter(|x| x % 2 == 0).collect();
    let total: i64 = evens.iter().sum();
    total + data.len() as i64 + squares.len() as i64 + evens.len() as i64
}

fn pipeline_b(n: usize) -> i64 {
    let scaled: Vec<i64> = (0..n as i64).map(|x| x * 3).collect();
    let picked: Vec<i64> = scaled.into_iter().filter(|x| x % 5 != 0).collect();
    let mut ordered = picked.clone();
    ordered.sort_unstable();
    let mut rev = picked.clone();
    rev.sort_unstable_by(|a, b| b.cmp(a));
    let mut chk: i64 = 0;
    for i in 0..16 {
        chk += ordered[i] + rev[i];
    }
    chk + picked.len() as i64
}

fn pipeline_c(n: usize) -> i64 {
    let a: Vec<i64> = (0..n as i64).collect();
    let b: Vec<i64> = (0..n as i64).map(|i| n as i64 - i).collect();
    let mut zsum: i64 = 0;
    for (x, y) in a.iter().zip(b.iter()) {
        zsum += x * y;
    }
    let mut psum: i64 = 0;
    let mut npairs: i64 = 0;
    for (x, y) in a.iter().zip(b.iter()) {
        if (x + y) % 7 == 0 {
            psum += x - y;
            npairs += 1;
        }
    }
    zsum + psum + npairs
}

fn pipeline_d(n: usize) -> i64 {
    let raw: Vec<i64> = (0..n).map(|i| ((i as i64) * 37) % 1000).collect();
    let mut by_mod = raw.clone();
    by_mod.sort_by_key(|v| v % 13);
    let mut by_neg = raw.clone();
    by_neg.sort_by_key(|v| -*v);
    let mut by_diff = raw.clone();
    by_diff.sort_by_key(|v| (v % 10) * 1000 + (v % 3));
    let mut chk: i64 = 0;
    for i in 0..8 {
        chk += by_mod[i] + by_neg[i] + by_diff[i];
    }
    // Fold the whole reordered buffer back in, so the entire permutation is observed.
    for v in &by_neg {
        chk += v % 7;
    }
    chk + raw.len() as i64
}

fn pipeline_e(n: usize) -> i64 {
    let total: i64 = (0..n as i64).map(|x| x * x).sum();
    let evens: i64 = (0..n as i64).filter(|x| x % 2 == 0).sum();
    let mx = (0..n as i64).map(|x| x * 3).max().unwrap();
    let mn = (0..n as i64).map(|x| x * 2 + 1).min().unwrap();
    let has_big = (0..n as i64).any(|x| x > n as i64);
    let all_pos = (0..n as i64).all(|x| x >= 0);
    let mut flag = 0;
    if has_big {
        flag += 1;
    }
    if all_pos {
        flag += 2;
    }
    total + evens + mx + mn + flag
}

fn pipeline_f(n: usize) -> i64 {
    let words: Vec<String> = (0..n).map(|i| "w".repeat(i % 5)).collect();
    let lens: Vec<i64> = words.iter().map(|w| w.len() as i64).collect();
    let lsum: i64 = lens.iter().sum();
    let mut ordered = words.clone();
    ordered.sort();
    let mut bylen = words.clone();
    bylen.sort_by_key(|w| w.len());
    let mut chk: i64 = 0;
    for i in 0..12 {
        chk += ordered[i].len() as i64 + bylen[i].len() as i64;
    }
    for w in &bylen {
        chk += w.len() as i64 * 2;
    }
    lsum + chk
}

fn pipeline_g(n: usize) -> i64 {
    let grid: Vec<Vec<i64>> = (0..n as i64)
        .map(|r| (0..16i64).map(|c| r * c).collect())
        .collect();
    let mut chk: i64 = 0;
    for row in &grid {
        for v in row {
            chk += v;
        }
    }
    let mut flat: Vec<i64> = grid.iter().flatten().copied().collect();
    flat.sort_unstable();
    for i in 0..16 {
        chk += flat[i];
    }
    for v in &flat {
        chk += v % 11;
    }
    chk
}

fn pipeline_h(n: usize) -> i64 {
    use std::collections::BTreeMap;
    let mut counts: BTreeMap<i64, i64> = BTreeMap::new();
    for i in 0..n {
        let k = (i % 512) as i64;
        *counts.entry(k).or_insert(0) += (i % 9) as i64;
    }
    let keys: Vec<i64> = counts.keys().copied().collect();
    let mut chk: i64 = 0;
    for i in 0..16 {
        chk += keys[i];
    }
    for v in counts.values() {
        chk += v;
    }
    chk
}

fn main() {
    let n = 20000usize;
    let mut acc: i64 = 0;
    acc += sweep(n);
    acc += pipeline_a(n);
    acc += pipeline_b(n);
    acc += pipeline_c(n);
    acc += pipeline_d(n);
    acc += pipeline_e(n);
    acc += pipeline_f(n);
    acc += pipeline_g(320);
    acc += pipeline_h(n);
    println!("{}", acc);
}
