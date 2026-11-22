# Archx Fundamentals

Archx is built around a simple premise: **you should not have to choose between code a human enjoys reading and code a CPU enjoys executing.**

Most languages pick a side early and spend the next twenty years trying to bolt the other side on. Dynamic languages start friendly and later add JITs, type hints, C extensions, and native bundlers. Systems languages start close to the metal and accumulate punctuation, footguns, or lifetime ceremony that every line of ordinary logic has to pay for.

This document sets down the five fundamentals guiding Archx:

1. **What is broken in existing languages** — the specific trade-offs Archx refuses to inherit.
2. **Memory** — how data lives in registers, on the stack, and (next) on the heap without a garbage collector.
3. **Binary size** — why an Archx executable is 14 KB stripped while doing the same work at the same speed as C and Rust.
4. **Readability** — concrete syntax choices that keep code scannable.
5. **Straightforwardness** — no hidden control flow, no implicit conversions, no compiler magic you cannot inspect.

---

## 1. The problem with current languages

Every mainstream language solves a real problem well, and each leaves a specific tax on the programmer or the machine:

| Language | What it gets right | The tax you pay |
|---|---|---|
| **Python** | Clean indentation, minimal ceremony, immediately readable | Every `int` is a heap-allocated PyObject; interpreter dispatch + refcounting make tight loops 30–100× slower than native code; shipping a program means shipping a runtime |
| **C / C++** | Zero forced runtime, tiny binaries, full hardware reach | **Undefined behavior** (signed overflow, buffer overruns, use-after-free, uninitialized reads), implicit conversions (`int` ↔ `bool`, narrowing), headers/macros, arcane declarations |
| **Rust** | Memory safety without a GC, C-tier speed, strong tooling | Heavy syntactic density (`&'a mut`, turbofish, `Box<dyn ...>`), borrow-checker friction on straightforward graphs/arenas, slow builds, multi-megabyte default binaries |
| **Go** | Fast builds, simple mental model, easy deployment | Mandatory garbage collector (latency tail + ~2× live-heap headroom), hidden heap escapes across interfaces/closures, ~2 MB minimum binary for the runtime |
| **Zig** | Explicit control, tiny binaries, no hidden allocations | C-family low-level ceremony everywhere — ideal for writing kernels and allocators, noisier than necessary for everyday application and algorithmic code |

Archx sits in the gap between **Python's surface** and **C/Zig's compiled output**:

- **Surface**: indentation-scoped blocks, words instead of symbol soup (`and`, `or`, `not`), local type inference, zero semicolons.
- **Underneath**: ahead-of-time compilation to LLVM IR, unboxed machine types in CPU registers, zero garbage collector, zero VM, and a binary linked straight against the OS `libc`.

---

## 2. Memory

### Why memory layout is the whole game

On a modern CPU, arithmetic is nearly free and **moving bytes is expensive**:

| Where the value lives | Typical access cost | What puts data there |
|---|---|---|
| CPU register | ~0–1 cycle | Local scalars promoted to SSA (`int`, `bool`, loop counters) |
| L1 cache / stack frame | ~3–5 cycles | Current function's stack slots, small local structs/arrays |
| L3 cache | ~30–40 cycles | Contiguous arrays, arena slabs |
| Main memory (DRAM) | ~150–250 cycles | Pointer-chasing heap objects (boxed ints, linked nodes, GC heaps) |

When Python runs `total = total + i`, it dereferences heap pointers, checks types, allocates a new integer object, and updates reference counts. When Archx runs `total = total + i`, both `total` and `i` live in 64-bit hardware registers — not a single byte of heap memory is touched.

### How Archx memory works today (Milestone 3)

1. **Entry-block stack slots (`alloca`), promoted to registers.**
   Every parameter and `let` binding starts life as a typed stack slot in the function's entry block:
   ```llvm
   %var.total.0 = alloca i64
   store i64 0, ptr %var.total.0
   ```
   Emitting allocas in the entry block is the canonical pattern LLVM's `mem2reg` / SROA passes expect. At `-O2`, LLVM rewrites those loads and stores into pure SSA registers (`phi` nodes and register values), eliminating stack traffic in loops completely.

2. **Unboxed scalar values.**
   - `int` → `i64` (8 bytes, register-resident).
   - `bool` → `i1` (1 bit in IR, single register/flag in machine code).
   - `string` → `ptr` pointing to a null-terminated UTF-8 constant in read-only static memory (`.rodata`). Identical string literals are **interned** so each distinct literal exists once in the binary.

3. **Zero heap, O(1) frame teardown.**
   Nothing allocates behind your back. When a function returns, its entire frame vanishes in a single stack-pointer instruction — no destructors to chase, no reference counts to decrement, no garbage collector to wake up.

### How heap memory will work as Archx grows

Loops and scalars never needed a heap, and future features will keep that discipline. When dynamic collections (`Array`, `Map`, owned `String` builders) land, Archx's memory plan avoids *both* a tracing GC and lifetime-annotation soup:

- **Values by default.** Structs and fixed-size aggregates sit inline on the stack or contiguous inside arrays — never silently boxed behind a pointer like Java or Python objects.
- **Single-owner RAII for growable buffers.** Heap-backed containers have one clear owner and free their buffer deterministically at the end of the owning scope.
- **Scoped arenas for phase/request work.** Many programs build a batch of nodes, transform them, emit an answer, and throw the whole batch away (compilers, parsers, web requests, game frames). A scoped arena allocates with a two-instruction pointer bump and frees everything at scope exit in O(1) — faster than `malloc`/`free`, cache-contiguous, and requiring zero per-field lifetime parameters.
- **Local borrows without viral `'a` annotations.** Passing a collection to a function borrows it for the duration of that call by default, without infecting struct definitions with lifetime generics.
- **Safety without C's undefined behavior.** Bounds checks stay unless LLVM proves the index is already within `0..len` (which a `for i in 0..arr.len:` header makes trivial for LLVM to prove).

---

## 3. Binary size

Small binaries are not a vanity metric. They mean faster linking, instant startup, tiny container images, less instruction-cache pressure, and nothing running inside your process that you did not ask for.

### Measured numbers (from `ci/out/benchmarks.txt`)

On the identical two-loop benchmark (`sum_squares` to 20,000,000 + `count_primes` below 400,000, all compiled at `-O2` on x86-64 Linux):

| Language | Compiler | Runtime (best of 5) | Binary (raw) | Binary (stripped) |
|---|---|---:|---:|---:|
| **C** | `clang 21 -O2` | **87 ms** | 16 KB | **14 KB** |
| **Rust** | `rustc 1.100 -O` | **87 ms** | 4,388 KB | **330 KB** |
| **Archx** | `archx` → `clang 21 -O2` | **87 ms** | 16 KB | **14 KB** |

All three print the exact same answers (`75517` and `33860`) and finish in **87 ms**. Yet the unstripped Rust executable is **274× larger** than Archx's (and still **23× larger** after `strip`).

### Why is Archx 14 KB?

An executable's size comes down to what is linked in before `main` even starts:

- **Rust** statically links `libstd`: panic formatting machinery, stack-unwinding tables, symbol demangling for backtraces, thread-local initialization, allocator shims, and debug info. You pay for that machinery even in a 30-line integer loop that never panics.
- **Go** statically embeds its goroutine scheduler and concurrent garbage collector (~2 MB floor).
- **Python / Node** either require a multi-tens-of-megabytes runtime preinstalled on the target machine or bundle one into a 40–100 MB archive.
- **Archx** emits only the functions in your program plus `private unnamed_addr` format strings, and dynamically links the system `libc` that every OS already has in memory. There is no Archx runtime library, no unwinder, and no GC.

As Archx adds a standard library, the rule stays **pay only for what you call**: unused stdlib functions will not be emitted (or will be marked `internal` so LLVM dead-strips them).

---

## 4. Readability

Readability is treated as an engineering constraint, not an aesthetic preference. Code is read ten times more often than it is written; syntax noise slows down bug-hunting just as surely as bad naming.

### Concrete rules in Archx

1. **Indentation *is* block structure.**
   In brace languages (`C`, `Rust`, `Go`), humans read the indentation while the compiler reads `{ }`. Whenever the two disagree, bugs hide in plain sight (`goto fail;`). In Archx, 4-space indentation is the single source of truth — no closing-brace ladders (`} } }`) taking up vertical space.

2. **Words where symbols blur together.**
   `if x > 0 and not done:` reads at natural speed; `if (x > 0 && !done) {` mixes comparison symbols, logical symbols, unary negation, parentheses, and braces in seven characters. Archx uses `and`, `or`, `not`, `in` for word-shaped connectors and keeps math symbols (`+`, `-`, `*`, `/`, `%`, `==`, `!=`, `<`, `<=`, `>`, `>=`) for math.

3. **Explicit at boundaries, inferred inside.**
   Inside a function body, types are obvious from the right-hand side, so Archx infers them:
   ```archx
   let total = 0
   let label = "ready"
   ```
   At function boundaries, types are **always written out**:
   ```archx
   func count_primes(limit: int) -> int:
   ```
   You never have to read a 40-line body to learn what a function accepts or returns, and a type mistake stops at the call site instead of producing a distant inference puzzle.

4. **One clean way to write each loop.**
   - Counting over a half-open range: `for i in 0..n:`
   - Repeating until a condition changes: `while n > 1:`
   No C-style three-clause `for (int i = 0; i < n; ++i)` header where initialization, condition, and mutation cram onto one line.

---

## 5. Straightforwardness

A language can look clean on a slide and still be full of traps when you maintain real code. "Straightforward" in Archx means **local reasoning always works**: looking at ten lines of Archx tells you what those ten lines do and roughly what they cost.

### No implicit conversions or "truthiness"

In C, `if (x = 0)` compiles; in Python and JavaScript, `""`, `0`, `[]`, and `None` silently coerce to `false`, turning typos and empty data into wrong branches.

In Archx:
- `if`, `while`, `and`, `or`, and `not` require an actual `bool` — `if count:` is rejected at compile time; write `if count != 0:`.
- Arithmetic and comparisons never silently widen, narrow, or mix `bool` with `int`.
- Assignment `x = expr` requires `x` to already exist via `let` and have the exact same type — a typo in a variable name on the left-hand side cannot silently invent a new local variable (Python's classic loop-bug footgun).

### Predictable evaluation, zero hidden work

- **Range bounds run once.** In `for i in start()..finish():`, both `start()` and `finish()` execute once before the loop begins, not on every iteration.
- **Short-circuiting is guaranteed.** `a and b` never evaluates `b` if `a` is `false`; `a or b` never evaluates `b` if `a` is `true`.
- **No hidden allocations or copy constructors.** Assigning an `int` or `bool` copies bytes in registers. No operator call can secretly invoke an arbitrary user function or heap allocator.
- **No preprocessor or text macros.** Every identifier in a file obeys lexical scope.

### Transparent compilation (`--emit-ir`)

Straightforwardness applies to the compiler too. At any point you can ask Archx to show its exact output:

```sh
archx examples/loops.archx.lang --emit-ir
```

And you can watch what LLVM `-O2` turns that straightforward source into. For example, in `examples/loops.archx.lang`, the human writes the clearest possible loop:

```archx
func sum_to(n: int) -> int:
    let total = 0
    for i in 1..n + 1:
        total = total + i
    return total
```

And in `ci/out/loops.opt.ll`, LLVM recognizes the induction variable over Archx's clean `for` IR and replaces the **entire loop** with closed-form arithmetic (`n * (n + 1) / 2`) — zero loop iterations at runtime, and when called as `sum_to(10)` in `main`, folds the whole call down to `printf("%lld\n", 55)`.

That is the core bargain of Archx: **you write the straightforward code; the compiler writes the clever machine code.**
