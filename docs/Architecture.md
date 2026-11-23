<!-- Product architecture, compiler pipeline, runtime ABI layouts, and module boundaries for Archx. -->

# Archx Architecture

## 1. Product Goal & Design Boundary

Archx compiles Python-clean, indentation-structured source code into native machine executables via **LLVM IR** and `clang -O2`:
- **Frontend**: 100% safe Rust, **zero external crate dependencies** (instant clean builds, zero supply-chain bloat).
- **Runtime model**: Zero garbage collector, zero VM, zero C++ unwinding tables; links only the system C library (`libc` / UCRT), keeping stripped binaries around **14 KB**.
- **Safety contract**: Zero undefined behavior — all `int` arithmetic is overflow/div-zero checked, all array indexing is bounds-safe, and all heap/region lifetimes are enforced by compile-time escape rules + deterministic RAII drops.

---

## 2. Compiler Pipeline

```text
  source (.archx.lang / .archx.lg / .ax.lang / .ax.lg)
    │
    ▼  src/lexer.rs
  Vec<Token>          (4-space INDENT/DEDENT tokens, contextual identifiers, 1-based Spans)
    │
    ▼  src/parser.rs
  ast::Program        (StructDef[], Func[]; bounded MAX_NESTING=128 + iterative unary chains)
    │
    ▼  src/codegen/
  LLVM IR (String)    (topo-sorted structs, SSA/SoA/Region/SSO lowering, internal fastcc helpers)
    │
    ▼  clang -O2      (invoked by src/main.rs; -llegacy_stdio_definitions on Windows MSVC)
  Native Executable   (ELF on Linux, Mach-O on macOS, PE .exe on Windows)
```

---

## 3. Core Memory & ABI Representations

| Archx Construct | LLVM IR Representation | Key Invariants |
|---|---|---|
| `int` | `i64` (`align 8`) | Checked `+ - *` (`@llvm.s*.with.overflow.i64`); `add nuw nsw` when proven bounded |
| `bool` | `i1` in SSA, `i8` in `[bool]` (`align 1`) | Strict boolean conditions; 8× denser `[bool]` arrays |
| `string` / `str` | `%ArchxStr = type { i64, i64 }` (`16 B`) | Word 0 = `len:u32 \| prefix4:[u8;4]`; Word 1 = inline `bytes[4..12]` if `len <= 12`, else `ptr \| tag` (`00` static, `01` heap, `10` region) |
| `[T]` (general AoS) | `%ArchxVec = type { i64, i64, ptr }` (`24 B`) | `{ len, cap, data }`; `0 <= len <= 2^47`; `data` is `noalias align 16` |
| `[Struct]` (local scalar) | `VarStorage::Soa { len_val, planes }` | One `noalias align 16` buffer per field; 100% cache-line streaming & `<2 x i64>` SIMD |
| `struct Name` | `%ArchxStruct_Name = type { ... }` | Topological value layout; cyclic definitions rejected at compile time |
| `region:` arena | `%ArchxRegion = type { ptr, ptr, ptr, ptr }` | `{ cur, end, head, tail }` over 64 KB `align 16` slabs; outermost exit rewinds `cur` to `head + 16` |

---

## 4. Modular Source Layout (`src/`)

- `src/main.rs` — CLI argument parser, extension/clobber guards, exclusive temp `.ll` creation, cross-platform `clang` invocation, and `--run` execution.
- `src/diag.rs` — `Span` (`line`, `col`) and `Diagnostic` error type.
- `src/token.rs` — `TokenKind` enum and human-readable token formatting.
- `src/lexer.rs` — Indentation-aware scanner, string escape decoder, and lexer unit tests.
- `src/ast.rs` — `Program`, `StructDef`, `Func`, `Stmt`, `Expr`, `AssignTarget`, and `Type`.
- `src/parser.rs` — Recursive-descent parser (contextual `step` in `for`, `string`/`str` aliases, iterative unary operators) and parser unit tests.
- `src/codegen/` — Modular LLVM IR backend:
  - `mod.rs` — `lower(&Program)` entry point, struct layout validation/sorting, `Codegen` state, function frame setup, and IR formatting helpers.
  - `analysis.rs` — Pure AST static analyses (SoA escape analysis, monotonic `while` stride verification, mutated/returned variable sets, constant int folding).
  - `stmt.rs` — Statement dispatch, `let`, `region:` watermark management, transparent AoS-to-SoA allocation, and variable/index/field assignments.
  - `loops.rs` — `while`, `for i in a..b`, `for i in a..b step k`, and `for x in arr` lowering with preheader range guards.
  - `expr.rs` — Literals, SSO string packing/concatenation/equality, checked `i64` arithmetic, struct field access, and short-circuit boolean logic.
  - `calls.rs` — User `fastcc` calls, positional struct constructors, and builtins (`print`, `len`, `push`, `pop`).
  - `ownership.rs` — Statement-temporary claiming/flushing, recursive RAII drops, deep value cloning, and `region:` return heap promotion.
  - `memory.rs` — Checked `malloc`/`calloc`/`realloc`, element load/store/fill loops, `2^47` length checks, and bounds-check elision proofs.
  - `runtime.rs` — On-demand LLVM IR runtime functions (`@archx_region_*`, `@archx_str_*`, cold panic handlers) and `libc`/intrinsic declarations.
  - `tests.rs` — Codegen unit test suite.
