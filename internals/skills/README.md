<!-- Directory overview for `internals/skills/`: reusable engineering playbooks for compiler optimization and verification. -->

# `internals/skills/` — Engineering Skills

Focused internal playbooks for recurring compiler tasks:

- [`llvm_ir_optimization.md`](llvm_ir_optimization.md) — Checklist for comparing `-O2` LLVM IR against C/Rust, eliminating vectorization/inlining blockers without UB, and verifying zero leaks under ASan + LSan.
