# Archx 5-Way Full-Feature Comparison — Edition 1 & 2:
#   - `full_tour.py`                  (Python 3.10+)
#   - `full_tour_pythonic.archx.lang` (Archx 1:1 Pythonic — byte-for-byte identical source!)
#
# Exercises every milestone (v0.1.0 - v0.8.0):
#   classes & float N-body physics, strings & slicing, lists/dicts/sets,
#   adaptive dynamic rebinding, multiple-return tuples, `T | None` optionals
#   with flow-sensitive narrowing, and `match`/`case` with `|` & `if` guards.


class Body:
    def __init__(self, x: float, y: float, vx: float, vy: float, mass: float):
        self.x = x
        self.y = y
        self.vx = vx
        self.vy = vy
        self.mass = mass

    def kinetic(self) -> float:
        return 0.5 * self.mass * (self.vx * self.vx + self.vy * self.vy)


def simulate_field(n: int, steps: int) -> int:
    bodies: list[Body] = []
    for i in range(n):
        fi = float(i + 1)
        bodies.append(Body(fi * 0.001, fi * -0.002, 0.02, -0.015, 1.0 + fi * 0.0002))

    dt = 0.01
    for _s in range(steps):
        for i in range(n):
            bx = bodies[i].x
            by = bodies[i].y
            r2 = bx * bx + by * by + 1.0
            inv = dt / (r2 ** 0.5)
            bodies[i].vx -= bx * inv
            bodies[i].vy -= by * inv
            bodies[i].x += bodies[i].vx * dt
            bodies[i].y += bodies[i].vy * dt

    ke = 0.0
    for i in range(n):
        ke += bodies[i].kinetic()
    return int(ke * 1000.0)


def dict_and_slicing_tour(rounds: int) -> tuple[int, str]:
    vocab: list[str] = []
    for i in range(512):
        if i % 2 == 0:
            vocab.append(f"tok_{i}")
        else:
            raw = f"   Telemetry_Channel_{i}  "
            vocab.append(raw.strip().lower())

    banner = "archx_systems_python"[::-1]
    checksum = 0
    miss = "absent_channel_key"

    for r in range(rounds):
        counts = {}
        seen = set()
        for i in range(512):
            counts[vocab[i]] = 1
        for step in range(4096):
            idx = (step * 73 + r * 19) % 512
            key = vocab[idx]
            counts[key] += (step % 5) + 1
            if step < 64:
                seen.add(idx)
        for p in range(1024):
            pk = vocab[(p * 131 + r * 7) % 512]
            checksum += counts.get(pk, 0)
        if miss not in counts:
            checksum += len(seen)
        for _k, v in counts.items():
            checksum += v

    nums = [10, 25, 40, 55, 70, 85, 100, 115]
    sliced = nums[1:7:2]
    checksum += sliced[0] + sliced[-1] + nums[-1]
    return checksum, banner


def analyze_series(xs: list[int]) -> tuple[int, int, int]:
    lo = xs[0]
    hi = xs[0]
    total = 0
    for x in xs:
        if x < lo:
            lo = x
        if x > hi:
            hi = x
        total += x
    return lo, hi, total


def find_spike(xs: list[int], threshold: int) -> int | None:
    for i, x in enumerate(xs):
        if x >= threshold:
            return i * 1000 + x


def dispatch_events(total_events: int) -> int:
    acc = 0
    for i in range(total_events):
        kind = i % 5
        a = (i * 17 + 3) % 40
        b = (i * 13 + 7) % 25
        ev = (kind, a, b)
        match ev:
            case (0, r, _) if r > 20:
                acc += r * r + 7
            case (0, r, _):
                acc += r * 3 + 1
            case (1, w, h):
                acc += w * h
            case (2, s, _) | (3, s, _):
                acc += s * 4 + 2
            case _:
                acc += 1
    return acc


def main():
    # Adaptive dynamic variable (valid Python + Archx Tier-2 `%ArchxAny`)
    mode = "initializing"
    mode = 8

    sim_score = simulate_field(40000, 30)
    dict_score, rev_banner = dict_and_slicing_tour(60)

    series: list[int] = []
    for i in range(64):
        series.append(((i * 37 + 11) % 97) + mode)
    lo, hi, total = analyze_series(series)

    hit = find_spike(series, 95)
    miss = find_spike(series, 999)
    hit_out = hit + 1 if hit is not None else -1
    miss_label = "none"
    match miss:
        case None:
            miss_label = "empty"
        case v:
            miss_label = f"val_{v}"

    dispatch_score = dispatch_events(200000)

    print(f"sim={sim_score}")
    print(f"dict_slice={dict_score},{rev_banner}")
    print(f"tuple_opt={lo},{hi},{total},{hit_out},{miss_label}")
    print(f"match_dispatch={dispatch_score}")


if __name__ == "__main__":
    main()
