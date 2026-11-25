# Suite 4 (Python 3 reference): floating-point central-field & pairwise N-body OOP physics.

from math import sqrt


class Body:
    def __init__(self, x: float, y: float, z: float, vx: float, vy: float, vz: float, mass: float):
        self.x = x
        self.y = y
        self.z = z
        self.vx = vx
        self.vy = vy
        self.vz = vz
        self.mass = mass

    def kinetic(self) -> float:
        return 0.5 * self.mass * (self.vx * self.vx + self.vy * self.vy + self.vz * self.vz)


def central_field_sim(n: int, steps: int) -> int:
    bodies: list[Body] = []
    for i in range(n):
        fi = float(i + 1)
        bodies.append(
            Body(fi * 0.001, fi * 0.002, fi * 0.0005, 0.01, -0.02, 0.005, 1.0 + fi * 0.0001)
        )

    dt = 0.01
    for _s in range(steps):
        for i in range(n):
            b = bodies[i]
            bx = b.x
            by = b.y
            bz = b.z
            r2 = bx * bx + by * by + bz * bz + 1.0
            inv = dt / sqrt(r2)
            b.vx -= bx * inv
            b.vy -= by * inv
            b.vz -= bz * inv
            b.x += b.vx * dt
            b.y += b.vy * dt
            b.z += b.vz * dt

    ke = 0.0
    for b in bodies:
        ke += b.kinetic()
    return int(ke * 100.0)


def pairwise_nbody(n: int, steps: int) -> int:
    bodies: list[Body] = []
    for i in range(n):
        fi = float(i + 1)
        bodies.append(Body(fi * 0.1, fi * -0.07, fi * 0.03, 0.0, 0.0, 0.0, 0.5 + fi * 0.01))

    dt = 0.005
    for _s in range(steps):
        for i in range(n):
            xi = bodies[i].x
            yi = bodies[i].y
            zi = bodies[i].z
            dvx = 0.0
            dvy = 0.0
            dvz = 0.0
            for j in range(n):
                dx = bodies[j].x - xi
                dy = bodies[j].y - yi
                dz = bodies[j].z - zi
                d2 = dx * dx + dy * dy + dz * dz + 0.05
                inv = (dt * bodies[j].mass) / (d2 * sqrt(d2))
                dvx += dx * inv
                dvy += dy * inv
                dvz += dz * inv
            bodies[i].vx += dvx
            bodies[i].vy += dvy
            bodies[i].vz += dvz
        for i in range(n):
            bodies[i].x += bodies[i].vx * dt
            bodies[i].y += bodies[i].vy * dt
            bodies[i].z += bodies[i].vz * dt

    ke = 0.0
    for b in bodies:
        ke += b.kinetic()
    return int(ke * 10_000.0)


print(central_field_sim(100_000, 60))
print(pairwise_nbody(64, 2_000))
