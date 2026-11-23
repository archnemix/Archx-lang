<!-- End-to-end execution and call-chain trace across the Archx compiler so bugs can be isolated immediately. -->

# Program Flow & Call-Chain Logic

Use this call chain whenever diagnosing a compiler bug, wrong codegen, or a memory leak.

---

## 1. Top-Level Driver Flow (`src/main.rs`)

```text
main()
 └─ run(args)
     ├─ has_valid_archx_extension(&input)       # enforces .archx.lang / .archx.lg / .ax.lang / .ax.lg
     ├─ fs::read_to_string(&input)
     ├─ lexer::Lexer::new(&source).tokenize()   # -> Vec<Token> (or render_error)
     ├─ parser::Parser::new(tokens).parse_program() # -> ast::Program (or render_error)
     ├─ codegen::lower(&program)                # -> String LLVM IR (or render_error)
     ├─ [if --emit-ir] print!("{ir}") -> return Ok(0)
     ├─ paths_refer_to_same_file(&input, &output) # blocks -o source clobbering
     ├─ find_clang()                            # ARCHX_CC -> PATH -> Windows LLVM path
     ├─ write_exclusive_temp_ir(&ir)            # O_EXCL archx-<pid>-<seq>.ll
     ├─ Command::new(clang).args([-O2, ...])    # + -llegacy_stdio_definitions on windows-msvc
     └─ [if --run] Command::new(run_path)       # ./<exe> for bare relative outputs
```

---

## 2. Frontend Call Chain (`src/lexer.rs` → `src/parser.rs`)

1. **`Lexer::tokenize` (`src/lexer.rs`)**:
   - At line start (`at_line_start && bracket_depth == 0`): counts leading spaces (`\t` errors), compares against `indent_stack`, and emits `TokenKind::Indent` or one-or-more `TokenKind::Dedent` tokens.
   - Scans identifiers/keywords (`func`, `struct`, `region`, `let`, `return`, `if`, `elif`, `else`, `while`, `for`, `in`, `break`, `continue`, `and`, `or`, `not`, `true`, `false`), integer literals (`u64` magnitude up to `9223372036854775808`), string literals with escapes (`\0`, `\n`, etc.), and operators.
2. **`Parser::parse_program` (`src/parser.rs`)**:
   - Loops until `Eof`, dispatching `TokenKind::Struct -> parse_struct_def()` and `TokenKind::Func -> parse_func()`.
   - `parse_stmt()` dispatches `let`, `return`, `if`/`elif`/`else`, `while`, `for` (checking `..` for range + contextual `Ident("step")` vs `ForEach`), `region:`, `break`, `continue`, or expression/assignment (`AssignTarget::Var | Index | Field`).
   - `parse_expr()` climbs precedence: `parse_or -> parse_and -> parse_cmp -> parse_add -> parse_mul -> parse_unary (iterative Vec stack) -> parse_postfix (.field, [idx]) -> parse_primary`.

---

## 3. Codegen & Ownership Call Chain (`src/codegen/`)

```text
codegen::lower(program)                          [src/codegen/mod.rs]
 ├─ topo_sort_structs(&program.structs)          # rejects unknown types & struct cycles
 ├─ collect FuncSig map                          # rejects duplicate funcs & validates main()
 ├─ for func in &program.funcs:
 │   └─ Codegen::gen_func(func)                  [src/codegen/mod.rs]
 │       ├─ collect_mutated_vars / collect_returned_vars  [analysis.rs]
 │       ├─ stmts_use_region(&func.body)         # allocates %func.region slot if needed
 │       ├─ bind params (VarStorage::Imm if unmutated, else entry-block Slot)
 │       ├─ gen_block(&func.body)                [stmt.rs]
 │       │   └─ gen_stmt_inner(stmt, rest_in_block)
 │       │       ├─ StmtKind::Let
 │       │       │   ├─ try_emit_transparent_soa(...)     [stmt.rs + analysis.rs::var_escapes_soa]
 │       │       │   ├─ eval_expr_typed(...)              [expr.rs -> calls.rs / memory.rs]
 │       │       │   ├─ claim_stmt_temp(&val)             [ownership.rs]
 │       │       │   └─ register DropTarget (if heap-owned outside region:)
 │       │       ├─ StmtKind::Assign -> gen_assign / gen_field_assign [stmt.rs]
 │       │       │   └─ check_region_escape_target(...)   # blocks region -> outer var escape
 │       │       ├─ StmtKind::For -> gen_for              [loops.rs + memory.rs::derive_for_bound]
 │       │       ├─ StmtKind::ForEach -> gen_foreach      [loops.rs]
 │       │       ├─ StmtKind::While -> gen_while          [loops.rs + memory.rs::analyze_strided_while]
 │       │       ├─ StmtKind::Region -> gen_region        [stmt.rs -> runtime.rs::@archx_region_rewind_root]
 │       │       ├─ StmtKind::Return
 │       │       │   ├─ [if inside region:] emit_promote_to_heap(...) [ownership.rs]
 │       │       │   └─ emit_func_exit_cleanup(...)       # drops all scopes + frees region slabs
 │       │       └─ flush_stmt_temps(out)                 [ownership.rs]
 │       └─ splice entry-block `self.allocas` + implicit return cleanup
 └─ emit_runtime_helpers(&mut out)               [src/codegen/runtime.rs]
     └─ emits only used @archx_region_*, @archx_str_*, @archx_vec_*, panic handlers, & libc declares
```
