//! Composite Milestone 5 benchmark — idiomatic safe Rust:
//!   1. particle_sim: 100,000 6-field `Body` structs (`Vec<Body>` AoS), 120 timesteps
//!      with full-slice integration + strided impulse (`step_by(8)`) + reduction.
//!   2. arena_and_strings: 40,000 rounds of variable-length `Vec<i64>` scratch
//!      allocation + owned `String` concatenation & equality checks.
//!
//! Build: rustc -O -o composite_rs benchmarks/composite.rs

const MOD: i64 = 1_000_000_007;

#[derive(Clone, Copy)]
struct Body {
    x: i64,
    y: i64,
    z: i64,
    vx: i64,
    vy: i64,
    vz: i64,
}

fn particle_sim(n: usize, steps: i64) -> i64 {
    let mut bodies = vec![
        Body {
            x: 0,
            y: 0,
            z: 0,
            vx: 1,
            vy: 2,
            vz: 3,
        };
        n
    ];

    for i in 0..n {
        let idx = i as i64;
        bodies[i].x = idx * 3;
        bodies[i].y = idx * 5;
        bodies[i].z = idx * 7;
        bodies[i].vx = (idx % 7) + 1;
        bodies[i].vy = (idx % 5) + 1;
        bodies[i].vz = (idx % 3) + 1;
    }

    for t in 0..steps {
        let imp = (t % 3) - 1;
        for i in 0..n {
            bodies[i].x += bodies[i].vx;
            bodies[i].y -= bodies[i].vy;
        }
        for i in (0..n).step_by(8) {
            bodies[i].z += bodies[i].vz + imp;
        }
    }

    let mut acc: i64 = 0;
    for b in &bodies {
        acc = (acc + b.x + b.y + b.z) % MOD;
    }
    acc
}

fn arena_and_strings(rounds: i64, base_len: i64) -> i64 {
    let mut total: i64 = 0;
    for r in 0..rounds {
        let sz = (base_len + (r % 16)) as usize;
        let mut buf = vec![0i64; sz];

        for k in (0..sz).step_by(4) {
            buf[k] = r + (k as i64) * 3;
        }
        let probe = ((r * 7) as usize) % sz;
        let mut s_acc = buf[0] + buf[probe] + buf[sz - 1];

        let s_rhs = if r % 2 == 0 { "alpha0" } else { "beta99" };
        let s1 = String::from("id_") + s_rhs;

        let l_rhs = if r % 4 == 0 {
            "payload_v2_a"
        } else {
            "other_kind_b"
        };
        let s2 = String::from("packet_header_") + l_rhs;

        if s1 == "id_alpha0" {
            s_acc += 17;
        }
        if s2 == "packet_header_payload_v2_a" {
            s_acc += 43;
        }
        if s2 == "packet_header_never_match!" {
            s_acc += 99;
        }

        total = (total + s_acc + (s1.len() as i64) + (s2.len() as i64)) % MOD;
    }
    total
}

fn main() {
    println!("{}", particle_sim(100_000, 120));
    println!("{}", arena_and_strings(40_000, 256));
}
