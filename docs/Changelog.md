<!-- Concise version-by-version changelog tracking features added, changed, and hardened across Archx releases. -->

# Changelog

## `v0.5.0` — Milestone 5 + Safety Hardening & Multi-OS Modularization (Current)
- **Added**:
  - Value `struct` declarations, positional constructors, field reads/writes (`arr[i].field += v`), `==`/`!=`, and `print(s)`.
  - **Transparent AoS-to-SoA planarization** for local fixed-length scalar `[Struct]` arrays (`align 16` per-field planes).
  - Scoped `region:` 64 KB bump arenas with nested watermarks, root-slab fast cursor rewind, compile-time escape checking, and automatic heap promotion on `return`.
  - 16-byte German/Umbra **prefix-SSO strings** (`string` and `str` alias): `<= 12 B` inline register storage, `+` / `+=` concatenation, `==` / `!=`, `len(s)`, and embedded NUL (`\0`) support.
  - `for x in arr:` element foreach loops and contextual `for i in a..b step k:` strided loops.
  - Suite 3 (`benchmarks/composite.*`) C vs Rust vs Archx benchmark (**Archx `14 ms` vs C `16 ms` and Rust `18 ms`**) and ASan+LSan CI gate (`0` leaks).
  - Cross-platform Linux + macOS + Windows CI matrix and versioned test history (`ci/test-history/v0.5.0/`).
- **Changed / Hardened**:
  - Split monolithic `src/codegen.rs` into 10 single-responsibility modules under `src/codegen/`.
  - Checked `i64` arithmetic (`sadd`/`ssub`/`smul.with.overflow`, safe `/` & `%` handling `0` and `i64::MIN / -1`).
  - Iterative unary parsing + `MAX_NESTING = 128`, strict double-extension check, `-o` source-clobber guard, exclusive temp `.ll` creation, and Windows MSVC `-llegacy_stdio_definitions` linking.

## `v0.4.0` — Milestone 4: Safe Arrays & Bounds-Check Elision
- **Added**: `[T]` arrays (`[a, b]`, `[val; n]`, nested `[[int]]`, `len`, `push`, `pop`), `elif`, compound assignments (`+= -= *= /= %=`), range-guarded `for` versioning, monotonic strided `while` versioning, deterministic scope-exit array `free`, and Suite 2 (`benchmarks/arrays*`).

## `v0.3.0` — Milestone 3: Loops & Scalar Benchmarks
- **Added**: `while`, `for i in a..b:`, `break`, `continue`, variable reassignment, direct SSA (`VarStorage::Imm`), frontend constant folding, and Suite 1 (`benchmarks/primes.*`).

## `v0.2.0` — Milestone 2: Booleans & Conditionals
- **Added**: `bool` (`true`, `false`), `if` / `else`, `== != < > <= >=`, and short-circuit `and`, `or`, `not`.

## `v0.1.0` — Milestone 1: Core Compiler
- **Added**: Indentation-aware lexer, recursive-descent parser, span diagnostics, `func`, `let`, `return`, `print`, textual LLVM IR emission, and `clang -O2` native binary compilation (`14 KB` stripped).
