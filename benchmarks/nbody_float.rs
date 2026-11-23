//! Suite 4 floating-point & OOP method benchmark — safe Rust (`Vec<Body>`, `f64`, `rustc -O`).

#[derive(Clone, Copy)]
struct Body {
    x: f64,
    y: f64,
    z: f64,
    vx: f64,
    vy: f64,
    vz: f64,
    mass: f64,
}

impl Body {
    #[inline]
    fn kinetic(&self) -> f64 {
        0.5 * self.mass * (self.vx * self.vx + self.vy * self.vy + self.vz * self.vz)
    }
}

fn central_field_sim(n: usize, steps: usize) -> i64 {
    let mut bodies = vec![
        Body {
            x: 0.0,
            y: 0.0,
            z: 0.0,
            vx: 0.0,
            vy: 0.0,
            vz: 0.0,
            mass: 0.0,
        };
        n
    ];

    for i in 0..n {
        let fi = (i + 1) as f64;
        bodies[i].x = fi * 0.001;
        bodies[i].y = fi * 0.002;
        bodies[i].z = fi * 0.0005;
        bodies[i].vx = 0.01;
        bodies[i].vy = -0.02;
        bodies[i].vz = 0.005;
        bodies[i].mass = 1.0 + fi * 0.0001;
    }

    let dt = 0.01_f64;
    for _ in 0..steps {
        for i in 0..n {
            let bx = bodies[i].x;
            let by = bodies[i].y;
            let bz = bodies[i].z;
            let r2 = bx * bx + by * by + bz * bz + 1.0;
            let inv = dt / r2.sqrt();
            bodies[i].vx -= bx * inv;
            bodies[i].vy -= by * inv;
            bodies[i].vz -= bz * inv;
            bodies[i].x += bodies[i].vx * dt;
            bodies[i].y += bodies[i].vy * dt;
            bodies[i].z += bodies[i].vz * dt;
        }
    }

    let mut ke = 0.0_f64;
    for i in 0..n {
        ke += bodies[i].kinetic();
    }
    (ke * 100.0) as i64
}

fn pairwise_nbody(n: usize, steps: usize) -> i64 {
    let mut bodies = vec![
        Body {
            x: 0.0,
            y: 0.0,
            z: 0.0,
            vx: 0.0,
            vy: 0.0,
            vz: 0.0,
            mass: 0.0,
        };
        n
    ];

    for i in 0..n {
        let fi = (i + 1) as f64;
        bodies[i].x = fi * 0.1;
        bodies[i].y = fi * -0.07;
        bodies[i].z = fi * 0.03;
        bodies[i].vx = 0.0;
        bodies[i].vy = 0.0;
        bodies[i].vz = 0.0;
        bodies[i].mass = 0.5 + fi * 0.01;
    }

    let dt = 0.005_f64;
    for _ in 0..steps {
        for i in 0..n {
            let xi = bodies[i].x;
            let yi = bodies[i].y;
            let zi = bodies[i].z;
            let mut dvx = 0.0_f64;
            let mut dvy = 0.0_f64;
            let mut dvz = 0.0_f64;
            for j in 0..n {
                let dx = bodies[j].x - xi;
                let dy = bodies[j].y - yi;
                let dz = bodies[j].z - zi;
                let d2 = dx * dx + dy * dy + dz * dz + 0.05;
                let inv = (dt * bodies[j].mass) / (d2 * d2.sqrt());
                dvx += dx * inv;
                dvy += dy * inv;
                dvz += dz * inv;
            }
            bodies[i].vx += dvx;
            bodies[i].vy += dvy;
            bodies[i].vz += dvz;
        }
        for i in 0..n {
            bodies[i].x += bodies[i].vx * dt;
            bodies[i].y += bodies[i].vy * dt;
            bodies[i].z += bodies[i].vz * dt;
        }
    }

    let mut ke = 0.0_f64;
    for i in 0..n {
        ke += bodies[i].kinetic();
    }
    (ke * 10000.0) as i64
}

fn main() {
    println!("{}", central_field_sim(100_000, 60));
    println!("{}", pairwise_nbody(64, 2_000));
}
