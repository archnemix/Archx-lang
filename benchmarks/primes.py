# Suite 1 (Python 3 reference): scalar loops & trial-division prime count
# Identical algorithm and inputs to `primes.c`, `primes.rs`, and `primes.archx.lang`.


def sum_squares(n: int) -> int:
    total = 0
    for i in range(n):
        total = (total + i * i) % 1000007
    return total


def count_primes(limit: int) -> int:
    count = 0
    for n in range(2, limit):
        is_prime = True
        d = 2
        while d * d <= n:
            if n % d == 0:
                is_prime = False
                break
            d += 1
        if is_prime:
            count += 1
    return count


def main():
    print(sum_squares(20000000))
    print(count_primes(400000))


if __name__ == "__main__":
    main()
