<!-- Ordered milestone roadmap for Archx: completed Milestones 1–5 and detailed next logical steps (Milestones 6–9). -->

# Archx Roadmap

Each milestone must be **100% implemented, leak-checked, and tested across Linux, macOS, and Windows** before advancing to the next milestone.

---

## Completed Milestones

### Milestone 1 (`v0.1.0`) — Core Frontend & Native LLVM Backend [DONE]
- [x] Indentation-aware lexer (`4` spaces, `#` comments, single/double-quoted strings, spans)
- [x] Recursive-descent parser (`func`, `let`, `return`, `+ - * / %`, calls, `print`)
- [x] Textual LLVM IR backend + `clang -O2` driver (`14 KB` stripped binaries)

### Milestone 2 (`v0.2.0`) — Booleans & Control Flow [DONE]
- [x] `bool` (`true`, `false`), `if` / `else`
- [x] Comparisons (`==`, `!=`, `<`, `>`, `<=`, `>=`)
- [x] Short-circuit `and`, `or`, and `not` (strict `bool`, zero implicit truthiness)

### Milestone 3 (`v0.3.0`) — Loops & Scalar Benchmarks [DONE]
- [x] `while cond:`, `for i in a..b:`, `break`, `continue`, variable reassignment
- [x] Direct SSA (`VarStorage::Imm`) for immutable bindings + constant folding
- [x] Suite 1 (`primes`) head-to-head C vs Rust vs Archx benchmark (`1.00×` C/Rust parity)

### Milestone 4 (`v0.4.0`) — Safe Arrays & Bounds-Check Elision [DONE]
- [x] Homogeneous `[T]` arrays (`[a, b]`, `[val; count]`, nested `[[int]]`, `len`, `push`, `pop`)
- [x] `elif` chains and compound assignments (`+=`, `-=`, `*=`, `/=`, `%=`)
- [x] Range-guarded `for` versioning, monotonic strided `while` versioning, `2^47` size guard
- [x] Suite 2 (`arrays`) C raw / C checked / Rust / Archx benchmark (`1.00×` parity, 0 UB)

### Milestone 5 (`v0.5.0`) — Structs (SoA), Regions, Prefix-SSO Strings & Modular Hardening [DONE]
- [x] Checked `i64` overflow (`sadd`/`ssub`/`smul.with.overflow`) & safe `/` and `%`
- [x] Value `struct`s + **transparent AoS-to-SoA planarization** for local scalar `[Struct]` arrays
- [x] Scoped `region:` 64 KB bump arenas + root cursor rewind + escape checker + `return` promotion
- [x] 16-byte German/Umbra **prefix-SSO `string` / `str`** (`+`, `==`, `!=`, `len`, embedded NULs)
- [x] `for x in arr:` foreach iteration & contextual `for i in a..b step k:` strided loops
- [x] Recursive deterministic RAII ownership (`0` leaks verified by ASan + LSan in CI)
- [x] Suite 3 (`composite`) benchmark (**Archx `14 ms` beats C `16 ms` and Rust `18 ms`**)
- [x] Modular `src/codegen/` architecture + Linux/macOS/Windows CI matrix

---

## Next Logical Steps (Ordered Implementation Plan)

### Milestone 6 (`v0.6.0`) — `float` (`f64`), Struct Methods (`impl`), and String Interpolation **[NEXT STEP]**
*Why this is next*: Real scientific, graphics, simulation, DSP, and application workloads immediately need 64-bit IEEE-754 floating-point numbers (`float`), ergonomic conversions/formatting (`str(x)` / `f"x={x}"`), and methods attached to `struct` types (`v.norm_sq()`, `Vec2.zero()`).
- [ ] **`float` (`f64` / LLVM `double`)**:
  - Literals (`3.14`, `1.0e-6`), `+ - * /`, `-x`, `< > <= >= == !=`, `+= -= *= /=`, `print(f)`, `[float]` arrays, and `float` fields inside transparent SoA `[Struct]` planes (`<2 x double>` / `<4 x double>` SIMD!).
  - Explicit lossless/defined casts: `float(n)` (`sitofp i64 to double`) and saturating `int(x)` (`@llvm.fptosi.sat.i64.f64` — zero UB on `NaN`/`Inf`/out-of-range floats!).
- [ ] **Struct methods & associated functions (`impl Vec2:`)**:
  - Value receiver methods (`func dot(self, other: Vec2) -> int:`), mutating field receivers or functional updates, and static constructors (`Vec2.zero()`), lowered directly to `internal fastcc` functions with zero vtable overhead.
- [ ] **String conversions & zero-overhead interpolation (`f"score: {score}"`, `str(x)`)**:
  - Stack-buffered integer/bool/float formatting directly into 16-byte SSO (`<= 12 B` results never allocate!) or active `region:`.
- [ ] **Suite 4 (`nbody_float`) benchmark**: 3D floating-point N-body / SIMD integration vs C and Rust.

### Milestone 7 (`v0.7.0`) — Algebraic `enum`s, `Option` / `Result`, and Exhaustive `match`
- [ ] Payload-carrying `enum`s (`enum Shape:`, `Option`, `Result`) lowered as compact unboxed `{ i8/i32 tag, payload }` values.
- [ ] Exhaustive `match expr:` statement/expression with compile-time missing-arm diagnostics and RAII payload drops.
- [ ] `?` early-return propagation for `Result` / `Option` (executing scope RAII drops and `region:` unwinds cleanly).

### Milestone 8 (`v0.8.0`) — Monomorphized Generics & Slices
- [ ] Type-parameterized functions (`func sum[T](xs: [T]) -> T:`) and structs (`struct Pair[A, B]:`), monomorphized before LLVM IR lowering so every specialization optimizes identically to hand-written concrete types.
- [ ] Zero-copy read-only array/string slices (`xs[a..b]`).

### Milestone 9 (`v0.9.0`) — Multi-File Modules (`import`) & Zero-Bloat Standard Library
- [ ] `import math` / `from fs import read_text` module resolver with cycle detection and cross-module `internal` linkage so whole-program dead-code elimination keeps binaries tiny (`~14–20 KB`).
- [ ] Pay-only-for-what-you-call standard library:
  - `math` (`sqrt`, `sin`, `cos`, `abs`, `min`, `max` via LLVM intrinsics)
  - `io` / `fs` / `env` (`args()`, `read_file()`, `write_file()`, `read_line()`)
  - `map` / `set` (SwissTable / Robin Hood open-addressed hash table compatible with `region:` and RAII)
