# Suite 5 (Python 3 reference & 1:1 Pythonic Archx source):
# String & integer dictionary insertion, updates, `.get()`, `.pop()`, `in`, and `.items()`.


def run_str_bench(vocab: list[str], rounds: int) -> int:
    str_checksum = 0
    miss = "missing_token_xyz"
    for r in range(rounds):
        counts = {}
        for i in range(1024):
            counts[vocab[i]] = 1
        for step in range(8192):
            idx = (step * 73 + r * 19) % 1024
            k = vocab[idx]
            counts[k] += (step % 7) + 1
        for p in range(2048):
            pidx = (p * 131 + r * 7) % 1024
            pk = vocab[pidx]
            str_checksum += counts.get(pk, 0)
        if miss not in counts:
            str_checksum += counts.get(miss, 3)
        for _k, v in counts.items():
            str_checksum += v
    return str_checksum


def run_int_bench() -> int:
    tab = {}
    for i in range(32768):
        k = i * 17 + 3
        tab[k] = (i * 31 + 7) % 100000
    popped_sum = 0
    for i in range(0, 32768, 4):
        k = i * 17 + 3
        popped_sum += tab.pop(k)
    for j in range(8192):
        nk = 1000000 + j * 13
        tab[nk] = j * 5 + 1

    int_checksum = popped_sum + len(tab)
    for _pass in range(40):
        for _k, v in tab.items():
            int_checksum += (_k % 997) * v
    return int_checksum


vocab: list[str] = []
for i in range(1024):
    if i % 2 == 0:
        vocab.append(f"tok_{i}")
    else:
        vocab.append(f"identifier_token_{i}")

print(run_str_bench(vocab, 120))
print(run_int_bench())
