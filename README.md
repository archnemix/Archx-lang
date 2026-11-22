# Archx

**Archx** is a small programming language with one goal: **readable like Python, fast like C**.

Archx compiles to **LLVM IR**, so it uses the same optimizer and backends as C, Rust, Swift, Zig, and Julia. One frontend, every architecture LLVM supports: x86-64, ARM64, RISC-V, WASM, and more.

> Status: milestone 3 — `while` / `for` loops, `break` / `continue`, assignment,
> `if`/`else`, booleans, comparisons, short-circuit `and`/`or`/`not`, user
> functions, `let`/`return`, arithmetic, and `print`.
>
> Benchmarked against C and Rust — see [Benchmarks](#benchmarks).

## Why LLVM?

Hand-written assembly is architecture-specific: x86-64 assembly is useless on ARM64 or RISC-V, so you would rewrite the backend for every target. Emitting **LLVM IR** instead means one frontend and LLVM handles optimization and code generation everywhere. That is how Clang, Rust, Swift, Zig, and Julia reach C-class performance.

QBE is a lighter alternative with faster compiles, but its optimizer is far less mature than LLVM's. Archx uses LLVM and keeps the door open for a second backend behind the same IR interface.

## Install

You need:

- **Rust** 1.75+ — <https://rustup.rs>
- **clang** 15+ — Archx emits LLVM IR and uses clang as the LLVM compiler driver.

```sh
cargo build --release
```

The compiler binary is `target/release/archx`.

## Usage

```sh
archx examples/hello.archx.lang              # compile to ./examples/hello
archx examples/hello.archx.lang --run        # compile and run
archx examples/hello.archx.lang --emit-ir    # print the generated LLVM IR
archx examples/hello.archx.lang -o hello     # choose the output name
```

## Syntax

```archx
func sign(n: int) -> int:
    if n > 0:
        return 1
    else:
        return -1

func sum_to(n: int) -> int:
    let total = 0
    for i in 1..n + 1:
        total = total + i
    return total

func main():
    let x = 7
    if x > 5 and x < 10:
        print("big")
    else:
        print("small")

    print(sign(5))
    print(sign(-5))
    print(sum_to(10))

    let n = 5
    let fact = 1
    while n > 1:
        fact = fact * n
        n = n - 1
    print(fact)
```

Rules so far:

- Blocks are indentation-based (4 spaces per level; a tab counts as 4 columns).
- No semicolons.
- `#` starts a comment.
- Strings use `'single'` or `"double"` quotes.
- `int` is a 64-bit signed integer; `bool` is `true`/`false`; `string` is an immutable UTF-8 string.
- Arithmetic: `+`, `-`, `*`, `/`, `%`. Comparisons: `==`, `!=`, `<`, `>`, `<=`, `>=`.
- Logical operators: `and`, `or`, `not` — `and`/`or` short-circuit.
- `while cond:` repeats while `cond` is true.
- `for i in a..b:` counts `a, a+1, … b-1` — the end is **exclusive**, like Rust's `a..b`. Both bounds are evaluated once, up front.
- `break` leaves the innermost loop; `continue` starts its next iteration.
- `name = value` assigns to an existing variable.
- `print(...)` is a builtin; it prints `int`, `bool`, or `string`.
- `func main():` is the executable entry point.
- Files use a double extension: `.archx.lang`, `.archx.lg`, `.ax.lang`, or `.ax.lg`.

## Why `main`?

It is not about speed. Python is interpreted, so the interpreter can start executing top-level statements anywhere. A compiled binary is raw machine code: the operating system loader needs **one exact entry address** to jump to. That address is `main`. It is a linking convention, not a performance feature.

## How memory works today

- Every local variable is a **stack slot** (`alloca`) created in the function's entry block.
- `let` stores into the slot; reads load from it. Parameters are spilled to stack slots too.
- Strings are interned global constants.
- There is **no heap** yet.
- At `-O2`, LLVM's `mem2reg`/SROA passes promote allocas to SSA registers, so locals usually disappear from the final machine code.

See `docs/OPTIMIZATION.md` for the before/after IR, the optimization strategy, and the research behind it.

## Optimization

Archx optimizes at four layers:

1. **Language design** — value semantics, no hidden allocations, monomorphized generics (later), defined overflow, no UB-driven surprises.
2. **Frontend** — clean IR, entry-block allocas, string interning, constant folding (next), no unnecessary loads.
3. **LLVM middle-end** — `-O2` by default (SROA, GVN, inlining, loop unrolling, vectorization).
4. **Backend/runtime** — instruction selection, register allocation, and later custom allocators/arenas.

`-O3`, LTO, PGO, and custom passes are available later once there is a benchmark suite to measure them. See `docs/OPTIMIZATION.md`.

## Benchmarks

`benchmarks/` holds **the same two workloads in C, Rust and Archx**:

1. **Sum of squares** — 20,000,000 iterations of `total = (total + i*i) % 1_000_007`. A tight arithmetic loop.
2. **Prime counting** — trial division up to 400,000. Nested loop, a branch, and an early `break`.

Both are compiled with `-O2` and timed best-of-5. All three must print the same
numbers or the run fails.

```sh
bash benchmarks/run.sh
```

Results land in `ci/out/benchmarks.txt` and are committed back to the repo by CI.
The point of the exercise: because Archx emits LLVM IR, it is optimized by the
*same* optimizer as C and Rust, so it lands in the same speed class — with a
binary the size of C's. See `benchmarks/README.md` for how to read the numbers.

## Architecture

```
.archx.lang source
    │
    ▼
lexer (indentation-aware)
    │
    ▼
parser → AST
    │
    ▼
type checks + codegen → LLVM IR (text)
    │
    ▼
clang -O2 → native executable
```

The frontend is written in Rust with **zero external crates**. LLVM IR is emitted as text, so you can inspect it with `--emit-ir`, and clang handles optimization and code generation.

## Development

```sh
cargo test
cargo run -- examples/hello.archx.lang --emit-ir
```

### CI

GitHub Actions builds and tests on every push, and saves its logs and generated IR in `ci/logs/` and `ci/out/`. The optimized IR (`*.opt.ll`) is saved too, so you can see what `-O2` does to the code, and the C/Rust/Archx benchmark table is saved to `ci/out/benchmarks.txt`. To force a run, touch `ci/trigger` and push.

## Roadmap

- [x] Lexer with indentation, comments, single/double-quoted strings
- [x] Parser for functions, `let`, `return`, arithmetic, calls
- [x] `if` / `else`, comparisons, short-circuit `and` / `or` / `not`
- [x] LLVM IR codegen + clang linking
- [x] `while` / `for` loops, `break` / `continue`, assignment
- [x] Benchmarks against C and Rust
- [ ] Arrays and indexing
- [ ] Structs and methods
- [ ] Generics (monomorphized)
- [ ] Ownership / RAII memory model
- [ ] String interpolation
- [ ] Modules and a standard library

## License

MIT
