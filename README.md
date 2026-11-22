# Archx

**Archx** is a small programming language with one goal: **readable like Python, fast like C**.

Archx compiles to **LLVM IR**, so it uses the same optimizer and backends as C, Rust, Swift, Zig, and Julia. One frontend, every architecture LLVM supports: x86-64, ARM64, RISC-V, WASM, and more.

> Status: milestone 2 — control flow (`if`/`else`), booleans, comparisons,
> short-circuit `and`/`or`/`not`, user functions, `let`/`return`, arithmetic,
> and `print`.

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

func main():
    let x = 7
    if x > 5 and x < 10:
        print("big")
    else:
        print("small")

    print(sign(5))
    print(sign(-5))
    print(true)
    print(not false)
```

Rules so far:

- Blocks are indentation-based (4 spaces per level; a tab counts as 4 columns).
- No semicolons.
- `#` starts a comment.
- Strings use `'single'` or `"double"` quotes.
- `int` is a 64-bit signed integer; `bool` is `true`/`false`; `string` is an immutable UTF-8 string.
- Comparisons: `==`, `!=`, `<`, `>`, `<=`, `>=`.
- Logical operators: `and`, `or`, `not` — `and`/`or` short-circuit.
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

GitHub Actions builds and tests on every push, and saves its logs and generated IR in `ci/logs/` and `ci/out/`. The optimized IR (`*.opt.ll`) is saved too, so you can see what `-O2` does to the code. To force a run, touch `ci/trigger` and push.

## Roadmap

- [x] Lexer with indentation, comments, single/double-quoted strings
- [x] Parser for functions, `let`, `return`, arithmetic, calls
- [x] `if` / `else`, comparisons, short-circuit `and` / `or` / `not`
- [x] LLVM IR codegen + clang linking
- [ ] `while` / `for` loops
- [ ] Arrays and indexing
- [ ] Structs and methods
- [ ] Generics (monomorphized)
- [ ] Ownership / RAII memory model
- [ ] String interpolation
- [ ] Modules and a standard library
- [ ] Benchmarks against C and Rust

## License

MIT
