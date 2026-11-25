# Suite 3 (Python 3 reference): 100,000 6-field `Body` structs (120 timesteps)
# + 40,000 rounds of temporary buffer allocation & string concat/equality.


class Body:
    def __init__(self, x: int, y: int, z: int, vx: int, vy: int, vz: int):
        self.x = x
        self.y = y
        self.z = z
        self.vx = vx
        self.vy = vy
        self.vz = vz


def particle_sim(n: int, steps: int) -> int:
    bodies: list[Body] = []
    for i in range(n):
        bodies.append(Body(i * 3, i * 5, i * 7, (i % 7) + 1, (i % 5) + 1, (i % 3) + 1))

    for t in range(steps):
        imp = (t % 3) - 1
        for i in range(n):
            b = bodies[i]
            b.x += b.vx
            b.y -= b.vy
        for i in range(0, n, 8):
            bodies[i].z += bodies[i].vz + imp

    acc = 0
    for b in bodies:
        acc = (acc + b.x + b.y + b.z) % 1000000007
    return acc


def arena_and_strings(rounds: int, base_len: int) -> int:
    total = 0
    for r in range(rounds):
        sz = base_len + (r % 16)
        buf = [0] * sz
        for k in range(0, sz, 4):
            buf[k] = r + k * 3
        probe = (r * 7) % sz
        s_acc = buf[0] + buf[probe] + buf[sz - 1]

        s_rhs = "beta99"
        if r % 2 == 0:
            s_rhs = "alpha0"
        s1 = "id_" + s_rhs

        l_rhs = "other_kind_b"
        if r % 4 == 0:
            l_rhs = "payload_v2_a"
        s2 = "packet_header_" + l_rhs

        if s1 == "id_alpha0":
            s_acc += 17
        if s2 == "packet_header_payload_v2_a":
            s_acc += 43
        if s2 == "packet_header_never_match!":
            s_acc += 99

        total = (total + s_acc + len(s1) + len(s2)) % 1000000007
    return total


def main():
    print(particle_sim(100000, 120))
    print(arena_and_strings(40000, 256))


if __name__ == "__main__":
    main()
