// Archx 5-Way Full-Feature Comparison — Edition 5: Rust (`rustc -O`)
//
// Idiomatic safe Rust implementation of the exact same 4-stage full-tour workload:
//   1. `Vec<Body>` central-field physics simulation (`simulate_field`)
//   2. `HashMap<String, i64>` + `HashSet<i64>` + string/slice ops (`dict_and_slicing_tour`)
//   3. `(i64, i64, i64)` tuple + `Option<i64>` (`analyze_series` & `find_spike`)
//   4. Algebraic `enum Event` + exhaustive `match` with `|` & `if` guards (`dispatch_events`)

use std::collections::{HashMap, HashSet};

#[derive(Clone, Copy)]
struct Body {
    x: f64,
    y: f64,
    vx: f64,
    vy: f64,
    mass: f64,
}

impl Body {
    #[inline]
    fn kinetic(&self) -> f64 {
        0.5 * self.mass * (self.vx * self.vx + self.vy * self.vy)
    }
}

enum Event {
    Circle(i64),
    Rect(i64, i64),
    Square(i64),
    Pulse(i64),
    Idle,
}

fn simulate_field(n: usize, steps: usize) -> i64 {
    let mut bodies = Vec::with_capacity(n);
    for i in 0..n {
        let fi = (i + 1) as f64;
        bodies.push(Body {
            x: fi * 0.001,
            y: fi * -0.002,
            vx: 0.02,
            vy: -0.015,
            mass: 1.0 + fi * 0.0002,
        });
    }

    let dt = 0.01_f64;
    for _ in 0..steps {
        for b in bodies.iter_mut() {
            let bx = b.x;
            let by = b.y;
            let r2 = bx * bx + by * by + 1.0;
            let inv = dt / r2.sqrt();
            b.vx -= bx * inv;
            b.vy -= by * inv;
            b.x += b.vx * dt;
            b.y += b.vy * dt;
        }
    }

    let mut ke = 0.0_f64;
    for b in &bodies {
        ke += b.kinetic();
    }
    (ke * 1000.0) as i64
}

fn dict_and_slicing_tour(rounds: i64) -> (i64, String) {
    let mut vocab = Vec::with_capacity(512);
    for i in 0..512 {
        if i % 2 == 0 {
            vocab.push(format!("tok_{i}"));
        } else {
            let raw = format!("   Telemetry_Channel_{i}  ");
            vocab.push(raw.trim().to_ascii_lowercase());
        }
    }

    let banner: String = "archx_systems_python".chars().rev().collect();
    let mut checksum: i64 = 0;
    let miss = "absent_channel_key";

    for r in 0..rounds {
        let mut counts: HashMap<String, i64> = HashMap::new();
        let mut seen: HashSet<i64> = HashSet::new();
        for tok in &vocab {
            counts.insert(tok.clone(), 1);
        }
        for step in 0..4096_i64 {
            let idx = ((step * 73 + r * 19) % 512) as usize;
            if let Some(v) = counts.get_mut(&vocab[idx]) {
                *v += (step % 5) + 1;
            }
            if step < 64 {
                seen.insert(idx as i64);
            }
        }
        for p in 0..1024_i64 {
            let pidx = ((p * 131 + r * 7) % 512) as usize;
            checksum += counts.get(&vocab[pidx]).copied().unwrap_or(0);
        }
        if !counts.contains_key(miss) {
            checksum += seen.len() as i64;
        }
        for v in counts.values() {
            checksum += *v;
        }
    }

    let nums = [10_i64, 25, 40, 55, 70, 85, 100, 115];
    let sliced: Vec<i64> = nums[1..7].iter().step_by(2).copied().collect();
    checksum += sliced[0] + sliced[sliced.len() - 1] + nums[nums.len() - 1];
    (checksum, banner)
}

fn analyze_series(xs: &[i64]) -> (i64, i64, i64) {
    let mut lo = xs[0];
    let mut hi = xs[0];
    let mut total = 0_i64;
    for &x in xs {
        if x < lo {
            lo = x;
        }
        if x > hi {
            hi = x;
        }
        total += x;
    }
    (lo, hi, total)
}

fn find_spike(xs: &[i64], threshold: i64) -> Option<i64> {
    for (i, &x) in xs.iter().enumerate() {
        if x >= threshold {
            return Some((i as i64) * 1000 + x);
        }
    }
    None
}

#[inline]
fn make_event(kind: i64, a: i64, b: i64) -> Event {
    match kind {
        0 => Event::Circle(a),
        1 => Event::Rect(a, b),
        2 => Event::Square(a),
        3 => Event::Pulse(a),
        _ => Event::Idle,
    }
}

fn dispatch_events(total_events: i64) -> i64 {
    let mut acc = 0_i64;
    for i in 0..total_events {
        let kind = i % 5;
        let a = (i * 17 + 3) % 40;
        let b = (i * 13 + 7) % 25;
        let ev = make_event(kind, a, b);
        match ev {
            Event::Circle(r) if r > 20 => acc += r * r + 7,
            Event::Circle(r) => acc += r * 3 + 1,
            Event::Rect(w, h) => acc += w * h,
            Event::Square(s) | Event::Pulse(s) => acc += s * 4 + 2,
            Event::Idle => acc += 1,
        }
    }
    acc
}

fn main() {
    let mode: i64 = 8;
    let sim_score = simulate_field(40_000, 30);
    let (dict_score, rev_banner) = dict_and_slicing_tour(60);

    let mut series = Vec::with_capacity(64);
    for i in 0..64_i64 {
        series.push(((i * 37 + 11) % 97) + mode);
    }
    let (lo, hi, total) = analyze_series(&series);

    let hit = find_spike(&series, 95);
    let miss = find_spike(&series, 999);
    let hit_out = match hit {
        Some(v) => v + 1,
        None => -1,
    };
    let miss_label = match miss {
        None => "empty".to_string(),
        Some(v) => format!("val_{v}"),
    };

    let dispatch_score = dispatch_events(200_000);

    println!("sim={sim_score}");
    println!("dict_slice={dict_score},{rev_banner}");
    println!("tuple_opt={lo},{hi},{total},{hit_out},{miss_label}");
    println!("match_dispatch={dispatch_score}");
}
