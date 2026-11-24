<!-- Product architecture, compiler pipeline, runtime ABI layouts, and module boundaries for Archx. -->

# Archx Architecture (`v0.7.0`)

## 1. Product Goal & Design Boundary

Archx compiles **1:1 Python-compatible** source code (as well as classic Archx syntax) directly into native machine executables via **LLVM IR** and `clang -O2`:
- **Frontend**: 100% safe Rust, **zero external crate dependencies**.
- **Runtime model**: Zero garbage collector, zero VM, zero C++ unwinding tables; links only system C (`libc` / `-lm` on Unix, UCRT + `legacy_stdio_definitions` on Windows MSVC), keeping stripped binaries around **14 KB**.
- **Safety contract**: Zero undefined behavior — all `int` arithmetic is overflow/div-zero checked, `int(float)` uses saturating `@llvm.fptosi.sat.i64.f64`, all array/string indexing is bounds-safe, and all heap/region lifetimes are enforced by compile-time escape rules + deterministic RAII drops.

---

## 2. Compiler Pipeline

```text
  source (.archx.lang / .archx.lg / .ax.lang / .ax.lg)
    │
    ▼  src/lexer.rs
  Vec<Token>          (4-space INDENT/DEDENT, f"..." segments, float/_ literals, Python keywords)
    │
    ▼  src/parser.rs
  ast::Program        (StructDef[methods], Func[], synthesized top-level script `main()`)
    │
    ▼  src/codegen/
  LLVM IR (String)    (topo-sorted structs, SoA/Region/SSO lowering, Pythonic I/O & methods)
    │
    ▼  clang -O2      (invoked by src/main.rs; -lm on Unix, -llegacy_stdio_definitions on MSVC)
  Native Executable   (ELF on Linux, Mach-O on macOS, PE .exe on Windows)
```

---

## 3. Core Memory & ABI Representations

| Archx Construct | LLVM IR Representation | Key Invariants |
|---|---|---|
| `int` | `i64` (`align 8`) | Checked `+ - *` (`@llvm.s*.with.overflow.i64`); `add nuw nsw` when proven bounded |
| `float` | `double` (`align 8`) | IEEE-754 binary64; `[0.0] * n` uses zero-page `@calloc`; saturating `int(x)` |
| `bool` | `i1` in SSA, `i8` in `list[bool]` | `True`/`False` (`true`/`false`); 8× denser boolean arrays |
| `str` (`string`) | `%ArchxStr = type { i64, i64 }` (`16 B`) | Word 0 = `(len:u32) \| (prefix4 << 32)`; Word 1 = inline `bytes[4..12]` if `len <= 12`, else `(ptr & -4) \| tag` (`0` static, `1` heap, `2` region) |
| `list[T]` (`[T]`) | `%ArchxVec = type { i64, i64, ptr }` (`24 B`) | `{ len, cap, data }`; `0 <= len <= 2^47`; `data` is `noalias align 16` |
| `dict[K, V]` / `set[T]` | `i64` (`%ArchxDictHdr* \| tag`) | 64B `%ArchxDictHdr { len, used, mask, meta, ctrl, keys, vals }`; `<16 x i8>` SIMD `ctrl` + dense insertion-ordered `keys[]` & `vals[]` (`v_sz = 0` for `set`); `tag = 1` heap, `2` region |
| `any` (Tier-2 Dynamic) | `%ArchxAny = type { i64, i64, i64 }` (`24 B`) | Unboxed stack/register tagged value: `0 = None`, `1 = bool`, `2 = int`, `3 = float`, `4 = str` (`%ArchxStr` inline in `w1, w2`!), `5 = list`, `6 = dict`, `7 = set` |
| `list[Class]` (local scalar) | `VarStorage::Soa { len_val, planes }` | One `noalias align 16` buffer per `int`/`bool`/`float` field; `<2 x double>` / `<2 x i64>` SIMD |
| `class` / `struct` | `%ArchxStruct_Name = type { ... }` | Unboxed topological value layout; mutating `self` methods pass `ptr`, read-only pass value |
| `with region:` | `%ArchxRegion = type { ptr, ptr, ptr, ptr }` | `{ cur, end, head, tail }` over 64 KB `align 16` slabs; outermost exit rewinds `cur` to `head + 16` |

---

## 4. Modular Source Layout (`src/`)

- `src/main.rs` — CLI argument parser, extension/clobber guards, exclusive temp `.ll` creation, cross-platform `clang` invocation (`-lm` / MSVC flags), and `--run` execution.
- `src/diag.rs` — `Span` (`line`, `col`) and `Diagnostic` error type.
- `src/token.rs` — `TokenKind` (`FStrPart`, `Float`, `SlashSlash`, `StarStar`, `Is`, `Assert`, `Pass`, `With`, `NoneLit`, etc.).
- `src/lexer.rs` — Indentation-aware scanner, `f"..."` brace-balanced interpolation scanner, float/exponent/`_` number scanner, and unit tests.
- `src/ast.rs` — `Program`, `StructDef` (with `methods`), `Func`, `StmtKind`, `ExprKind` (`DictLit`, `SetLit`, `Slice`, etc.), `CallArg`, `AssignTarget`, and `Type` (`Dict`, `Set`, `Any`, etc.).
- `src/parser.rs` — Recursive-descent parser supporting 1:1 Python syntax (`def`, `class`, `{k: v}`, `{a, b}`, `xs[a:b:step]`, `is`/`is not`, `range`, `enumerate`, `with region:`, script synthesis) and classic Archx syntax.
- `src/codegen/` — 16-file modular LLVM IR backend (`mod.rs`, `analysis.rs`, `any.rs`, `collections.rs`, `stmt.rs`, `loops.rs`, `expr.rs`, `calls.rs`, `io.rs`, `methods.rs`, `ownership.rs`, `memory.rs`, `runtime.rs`, `runtime_py.rs`, `runtime_hash_any.rs`, `tests.rs`).
