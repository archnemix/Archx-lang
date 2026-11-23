<!-- Log of user-requested project additions, architectural rules, and scope updates that feed into Roadmap.md. -->

# Requested Changes & Scope Log

| Date | Request Summary | Impact on Repo / `Roadmap.md` | Status |
|---|---|---|---|
| 2026-11-22 | Audit everything built, determine the next logical step, maintain clear usage documentation (`docs/USAGE.md`), and adopt standing engineering/governance rules (`prompt.txt`). | Modularized `src/codegen/` into focused files; added `docs/USAGE.md`, `docs/*` governance docs, `internals/skills/`, and Linux/macOS/Windows CI matrix. | **Completed** (`v0.5.0`) |
| 2026-11-22 | Make Archx syntax and I/O (`print`, `input`, formatting, loops, classes, methods, functions, variables) 1:1 Python-compatible while preserving native LLVM speed, safety, and backward compatibility (`v0.6.0`). | Delivered full 1:1 Pythonic syntax (`def`, `class`, `self` methods, script mode, implicit variable binding, `float`, `range`, `enumerate`, `f"..."`, `print(sep, end)`, `input()`, `//`, `**`, `in`/`not in`, list/string methods, soft built-ins) + Suite 4 `nbody_float` benchmark (**Archx `52 ms` vs C `56 ms` / Rust `56 ms`**). | **Completed** (`v0.6.0`) |
