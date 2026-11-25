# Suite 2 (Python 3 reference): 1,000,000-element vector kernel (60 rounds)
# + Sieve of Eratosthenes below 5,000,000.


def vec_step(dst: list[int], a: list[int], b: list[int], r: int):
    for i in range(len(dst)):
        dst[i] = a[i] * 3 + b[i] + r


def vec_kernel(n: int, rounds: int) -> int:
    a = [0] * n
    b = [0] * n
    dst = [0] * n

    for i in range(n):
        a[i] = (i * 7 + 3) % 1000
        b[i] = (i * 13 + 5) % 1000

    checksum = 0
    for r in range(rounds):
        vec_step(dst, a, b, r)
        idx = r % n
        checksum = (checksum + dst[idx] + dst[(n - 1) - idx]) % 1000000007

    total = checksum
    for i in range(n):
        total = (total + dst[i]) % 1000000007
    return total


def sieve_count(limit: int) -> int:
    is_prime = [True] * limit
    is_prime[0] = False
    is_prime[1] = False

    p = 2
    while p * p < limit:
        if is_prime[p]:
            j = p * p
            while j < limit:
                is_prime[j] = False
                j += p
        p += 1

    count = 0
    for i in range(2, limit):
        if is_prime[i]:
            count += 1
    return count


def main():
    print(vec_kernel(1000000, 60))
    print(sieve_count(5000000))


if __name__ == "__main__":
    main()
