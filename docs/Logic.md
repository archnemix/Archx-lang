<!-- End-to-end execution and call-chain trace across the Archx compiler so bugs can be isolated immediately. -->

# Program Flow & Call-Chain Logic (`v0.8.0`)

Use this call chain whenever diagnosing a compiler bug, wrong codegen, or a memory leak.

---

## 1. Top-Level Driver Flow (`src/main.rs`)

```text
main()
 └─ run(args)
     ├─ has_valid_archx_extension(&input)       # enforces .archx.lang / .archx.lg / .ax.lang / .ax.lg
     ├─ fs::read_to_string(&input)
     ├─ lexer::Lexer::new(&source).tokenize()   # -> Vec<Token>
     ├─ parser::Parser::new(tokens).parse_program() # -> ast::Program (synthesizes main() if top-level stmts exist)
     ├─ codegen::lower(&program)                # -> String LLVM IR
     ├─ [if --emit-ir] print!("{ir}") -> return Ok(0)
     ├─ paths_refer_to_same_file(&input, &output)
     ├─ find_clang()                            # ARCHX_CC -> PATH -> Windows LLVM path
     ├─ write_exclusive_temp_ir(&ir)            # O_EXCL archx-<pid>-<seq>.ll
     ├─ Command::new(clang).args([-O2, ...])    # + -lm on Unix, -llegacy_stdio_definitions on windows-msvc
     └─ [if --run] Command::new(run_path)       # ./<exe> for bare relative outputs
```

---

## 2. Frontend Call Chain (`src/lexer.rs` → `src/parser.rs`)

1. **`Lexer::tokenize` (`src/lexer.rs`)**:
   - Emits `Indent`/`Dedent` at 4-space boundaries when `bracket_depth == 0`.
   - Scans Python/Archx keywords (`def`/`func`, `class`/`struct`, `with`, `region`, `assert`, `pass`, `is`, `True`/`False`/`None`), `|` (`TokenKind::Pipe`), `int` & `float` literals with `_` separators and exponents, and `f"..."` interpolated string token segments.
2. **`Parser::parse_program` (`src/parser.rs`)**:
   - Collects `class`/`struct` definitions (fields + `def __init__` field inference + `def method(self, ...):`), contextual `enum` definitions (`parse_enum`), `def`/`func` functions, and top-level statements (unwrapping `if __name__ == "__main__":` and rewriting user `main()` to `__archx_user_main` when script statements follow).
   - `parse_stmt()` dispatches `let` (including `let a, b = ...`), `x: T = expr`, `return` (including bare `return a, b`), contextual `match subject:` (`parse_match_tail` -> `parse_pattern` supporting `|`, tuples, `Enum.Variant(...)`, and `if` guards), `if`/`elif`/`else`, `while`, `for` (`range`, `enumerate`, `d.items()`, tuple destructuring `for k, v in pairs:`, `..`, `ForEach`), `with region:` / `region:`, `assert`, `pass`, `break`, `continue`, or tuple unpacking / assignment / expression.

---

## 3. Codegen & Ownership Call Chain (`src/codegen/`)

```text
codegen::lower(raw_program)                      [src/codegen/mod.rs]
 ├─ resolve_program_types(raw_program, enum_names) # distinguishes Type::Enum vs Type::Struct
 ├─ topo_sort_structs(&program.structs) & compute_enum_layouts(&program.enums)
 ├─ register MethodSig (`__init__` + `self_by_ptr`) & FuncSig maps
 ├─ emit_method / gen_func                       [methods.rs / mod.rs]
 │   ├─ compute_adaptive_hints & collect_mutated_vars [analysis.rs]
 │   ├─ gen_block(&func.body)                    [stmt.rs]
 │   │   ├─ StmtKind::Let / TupleAssign / Assign -> [stmt.rs + tuples_enums.rs]
 │   │   ├─ StmtKind::If (detect_optional_narrowing) / StmtKind::Match (check_enum_exhaustiveness) -> [tuples_enums.rs + pattern_match.rs]
 │   │   ├─ StmtKind::For / ForEnumerate / ForDictItems / ForEach / While -> [loops.rs]
 │   │   ├─ StmtKind::Assert / Pass / Region / Return -> [stmt.rs + ownership.rs]
 │   │   └─ eval_expr_with_expected -> [expr.rs -> tuples_enums.rs / collections.rs / any.rs / calls.rs / io.rs / methods.rs]
 │   └─ splice entry-block `self.allocas` + scope/region exit drops
 ├─ finalize_runtime_flags()                     [runtime_py.rs]
 └─ emit_runtime_helpers(&mut out)               [runtime.rs -> runtime_py.rs -> runtime_hash_any.rs]
```
