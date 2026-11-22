# Archx

**Archx** is a small programming language with one goal: **readable like Python, fast like C**.

Archx compiles to **LLVM IR**, so it uses the same optimizer and backends as C, Rust, Swift, Zig, and Julia. One frontend, every architecture LLVM supports: x86-64, ARM64, RISC-V, WASM, and more.

> Status: milestone 1 — the pipeline works end to end
> (`source → lexer → parser → LLVM IR → native binary`), with indentation-based
> syntax, `func`, `let`, `return`, arithmetic, user functions, and `print`.

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
# indentation defines blocks, like Python
func add(a: int, b: int) -> int:
    return a + b

func main():
    print("Hello, Archx!")
    print('single quotes work too')
    let answer = add(40, 2)
    print(answer)
```

Rules so far:

- Blocks are indentation-based (4 spaces per level; a tab counts as 4 columns).
- No semicolons.
- `#` starts a comment.
- Strings use `'single'` or `"double"` quotes.
- `int` is a 64-bit signed integer; `string` is an immutable UTF-8 string.
- `print(...)` is a builtin.
- `func main():` is the executable entry point. It is required, like `main` in C.
- Files use a double extension: `.archx.lang`, `.archx.lg`, `.ax.lang`, or `.ax.lg`.

## Why `main`?

It is not about speed. Python is interpreted, so the interpreter can start executing top-level statements anywhere. A compiled binary is raw machine code: the operating system loader needs **one exact entry address** to jump to. That address is `main`. It is a linking convention, not a performance feature.

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

GitHub Actions builds and tests on every push, and saves its logs and generated IR in `ci/logs/` and `ci/out/`. To force a run, touch `ci/trigger` and push.

## Roadmap

- [x] Lexer with indentation, comments, single/double-quoted strings
- [x] Parser for functions, `let`, `return`, arithmetic, calls
- [x] LLVM IR codegen + clang linking
- [ ] `if` / `else`, `while`, `for`
- [ ] Booleans and comparisons
- [ ] Structs and methods
- [ ] Generics (monomorphized)
- [ ] Ownership / RAII memory model
- [ ] String interpolation
- [ ] Modules and a standard library

## License

MIT
