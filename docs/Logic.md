<!-- End-to-end execution and call-chain trace across the Archx compiler so bugs can be isolated immediately. -->

# Program Flow & Call-Chain Logic (`v0.7.0`)

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
   - Scans Python/Archx keywords (`def`/`func`, `class`/`struct`, `with`, `region`, `assert`, `pass`, `True`/`False`/`None`, etc.), `int` & `float` literals with `_` separators and exponents, and `f"..."` interpolated string token segments (`FStrPart::{Lit, ExprSrc}`).
2. **`Parser::parse_program` (`src/parser.rs`)**:
   - Collects `class`/`struct` definitions (fields + `def method(self, ...):`), `def`/`func` functions, and top-level statements (unwrapping `if __name__ == "__main__":` into synthesized `main()`).
   - `parse_stmt()` dispatches `let`, `x: T = expr`, `return`, `if`/`elif`/`else`, `while`, `for` (`range(...)` -> `StmtKind::For`, `enumerate(...)` -> `StmtKind::ForEnumerate`, `..`, or `StmtKind::ForEach`), `with region:` / `region:`, `assert`, `pass`, `break`, `continue`, or expression/assignment.
   - `parse_expr()` climbs precedence: `parse_ternary (a if c else b) -> parse_or -> parse_and -> parse_not -> parse_cmp (== != < <= > >= in not in) -> parse_add -> parse_mul (* / // %) -> parse_unary -> parse_power (**, right-assoc) -> parse_postfix (.method(), .field, [idx], ()) -> parse_primary`.

---

## 3. Codegen & Ownership Call Chain (`src/codegen/`)

```text
codegen::lower(program)                          [src/codegen/mod.rs]
 ├─ topo_sort_structs(&program.structs)          # rejects unknown types & struct cycles
 ├─ register MethodSig (`self_by_ptr` via stmts_mutate_self) & FuncSig maps
 ├─ emit_method / gen_func                       [methods.rs / mod.rs]
 │   ├─ collect_mutated_vars (2-state Pythonic first-binding vs mutation) [analysis.rs]
 │   ├─ gen_block(&func.body)                    [stmt.rs]
 │   │   ├─ StmtKind::Let / first StmtKind::Assign(Var) -> introduce_local_binding / try_emit_transparent_soa
 │   │   ├─ StmtKind::For / ForEnumerate / ForEach / While -> [loops.rs]
 │   │   ├─ StmtKind::Assert / Pass / Region / Return      -> [stmt.rs + ownership.rs]
 │   │   └─ eval_expr_typed -> [expr.rs -> calls.rs / io.rs / methods.rs / memory.rs]
 │   └─ splice entry-block `self.allocas` + scope/region exit drops
 ├─ finalize_runtime_flags()                     [runtime_py.rs]
 └─ emit_runtime_helpers(&mut out)               [runtime.rs -> runtime_py.rs]
```
