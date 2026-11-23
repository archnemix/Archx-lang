// Suite 4 floating-point & OOP method benchmark — C reference (`clang -O2 -lm`).
// Exercises 56-byte `Body` structs (`double`), `sqrt`, central-field particle integration,
// and all-pairs gravitational N-body steps.

#include <math.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

typedef struct {
    double x, y, z;
    double vx, vy, vz;
    double mass;
} Body;

static inline double body_kinetic(const Body *b) {
    return 0.5 * b->mass * (b->vx * b->vx + b->vy * b->vy + b->vz * b->vz);
}

static int64_t central_field_sim(int64_t n, int64_t steps) {
    Body *bodies = (Body *)malloc((size_t)n * sizeof(Body));
    if (!bodies) abort();

    for (int64_t i = 0; i < n; i++) {
        double fi = (double)(i + 1);
        bodies[i] = (Body){
            .x = fi * 0.001,
            .y = fi * 0.002,
            .z = fi * 0.0005,
            .vx = 0.01,
            .vy = -0.02,
            .vz = 0.005,
            .mass = 1.0 + fi * 0.0001,
        };
    }

    const double dt = 0.01;
    for (int64_t s = 0; s < steps; s++) {
        for (int64_t i = 0; i < n; i++) {
            double bx = bodies[i].x;
            double by = bodies[i].y;
            double bz = bodies[i].z;
            double r2 = bx * bx + by * by + bz * bz + 1.0;
            double inv = dt / sqrt(r2);
            bodies[i].vx -= bx * inv;
            bodies[i].vy -= by * inv;
            bodies[i].vz -= bz * inv;
            bodies[i].x += bodies[i].vx * dt;
            bodies[i].y += bodies[i].vy * dt;
            bodies[i].z += bodies[i].vz * dt;
        }
    }

    double ke = 0.0;
    for (int64_t i = 0; i < n; i++) {
        ke += body_kinetic(&bodies[i]);
    }
    free(bodies);
    return (int64_t)(ke * 100.0);
}

static int64_t pairwise_nbody(int64_t n, int64_t steps) {
    Body *bodies = (Body *)malloc((size_t)n * sizeof(Body));
    if (!bodies) abort();

    for (int64_t i = 0; i < n; i++) {
        double fi = (double)(i + 1);
        bodies[i] = (Body){
            .x = fi * 0.1,
            .y = fi * -0.07,
            .z = fi * 0.03,
            .vx = 0.0,
            .vy = 0.0,
            .vz = 0.0,
            .mass = 0.5 + fi * 0.01,
        };
    }

    const double dt = 0.005;
    for (int64_t s = 0; s < steps; s++) {
        for (int64_t i = 0; i < n; i++) {
            double xi = bodies[i].x;
            double yi = bodies[i].y;
            double zi = bodies[i].z;
            double dvx = 0.0, dvy = 0.0, dvz = 0.0;
            for (int64_t j = 0; j < n; j++) {
                double dx = bodies[j].x - xi;
                double dy = bodies[j].y - yi;
                double dz = bodies[j].z - zi;
                double d2 = dx * dx + dy * dy + dz * dz + 0.05;
                double inv = (dt * bodies[j].mass) / (d2 * sqrt(d2));
                dvx += dx * inv;
                dvy += dy * inv;
                dvz += dz * inv;
            }
            bodies[i].vx += dvx;
            bodies[i].vy += dvy;
            bodies[i].vz += dvz;
        }
        for (int64_t i = 0; i < n; i++) {
            bodies[i].x += bodies[i].vx * dt;
            bodies[i].y += bodies[i].vy * dt;
            bodies[i].z += bodies[i].vz * dt;
        }
    }

    double ke = 0.0;
    for (int64_t i = 0; i < n; i++) {
        ke += body_kinetic(&bodies[i]);
    }
    free(bodies);
    return (int64_t)(ke * 10000.0);
}

int main(void) {
    printf("%lld\n", (long long)central_field_sim(100000, 60));
    printf("%lld\n", (long long)pairwise_nbody(64, 2000));
    return 0;
}
