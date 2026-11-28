<!-- Complete user manual and language reference for everything built in Archx up to Milestone 8 (v0.8.0). -->

# Archx Language & Usage Guide (`v0.8.0`)

Archx gives you **1:1 Pythonic syntax, zero-heap tuples & unpacking, stack-inline `T | None` optionals, algebraic `enum` sum types, exhaustive `match`/`case`, Planar SIMD `dict`/`set`, slicing, smart two-tier adaptive typing (`any`), and standard console I/O** (`def`, `class`, `def __init__`, `enum`, `match`/`case`, `dict`, `set`, `xs[a:b:step]`, `xs[-1]`, `range`, `enumerate`, `f"..."`, `print(..., sep=..., end=...)`, `input()`, `float`, `list[T]`) compiled directly to **native machine code via LLVM IR (`clang -O2`)** with **zero garbage collector**, **transparent AoS-to-SoA SIMD**, **16-byte prefix-SSO strings**, and **scoped `region:` bump arenas**.

---

## 1. Prerequisites & Building the Compiler

Archx requires:
- **Rust** `1.75+` (`cargo` and `rustc`)
- **Clang** `15+` (`clang` on `PATH`, or pointed to via `ARCHX_CC=/path/to/clang`)

Build the release compiler binary:

```sh
cargo build --release
# Binary is at ./target/release/archx (or target\release\archx.exe on Windows)
```

---

## 2. Command-Line Usage (`archx`)

### Valid source extensions

Every Archx source file must use one of four double extensions:
- `.archx.lang` (canonical)
- `.archx.lg`
- `.ax.lang`
- `.ax.lg`

The extension is only a hint for editors. It does **not** choose the language contract — see below.

### Declaring the dialect (required)

Archx has two contracts and a module must state which one it wants. The declaration is the **first
line** of the file:

```
# archx: dialect=native, version=1
```

* `dialect=native` — documented Archx semantics: trapping `i64` `int`, UTF-8 byte strings, IEEE
  `frem`, static dispatch, `struct`, `Result[T, E]` + `?`.
* `dialect=compat` — byte-identical stdout to CPython 3.12+: arbitrary-precision `int`, Unicode
  code-point strings, Python `%`/truthiness/`repr`.

A module **without** this line is a compile error (`E0100`) — the compiler never guesses, because a
program whose behaviour depends on a compiler default is not reproducible. A malformed or
unsupported directive is `E0101` and names the offending field.

`--dialect compat|native` overrides a directive that is present; it cannot substitute for a missing
one:

```sh
archx examples/pythonic.archx.lang --dialect compat --run
```

The chosen contract is recorded in the emitted IR, both as a comment and as an LLVM module flag, so
an object file can be attributed to a contract without the source:

```
; archx.dialect=native version=1 source=directive
!llvm.module.flags = !{!0, !1}
!0 = !{i32 1, !"archx.dialect", !"native"}
!1 = !{i32 1, !"archx.directive_version", !"1"}
```

Behaviour bit `1` (`Error`) means linking a compat module against a native one is an error rather
than a silent choice between two incompatible `int` definitions.

### CLI commands & flags

`-O <0|1|2|3|s>` selects the `clang` optimisation level (default `-O2`). Every level is
behaviour-preserving: the suite asserts identical stdout across `-O0`…`-O3`, and the bounds/overflow
checks survive all of them (`docs/OPTIMIZATION_AB.md` records why `-O2` is the default, and why
`-ffast-math` and `-march=native` are not options).

```sh
# 1. Compile to native executable in current directory (e.g. ./pythonic or .\pythonic.exe):
archx examples/pythonic.archx.lang

# 2. Compile to a custom output path (-o refuses to overwrite the input source file):
archx examples/pythonic.archx.lang -o build/app

# 3. Compile and immediately execute (propagating stdin/stdout and exit code):
archx examples/pythonic.archx.lang --run

# 4. Print the generated textual LLVM IR to stdout without invoking clang:
archx examples/pythonic.archx.lang --emit-ir

# 5. Show help or compiler version:
archx --help
archx --version

# 6. Machine-readable diagnostics (one JSON object per line on stderr):
archx examples/pythonic.archx.lang --message-format=json

# 7. Explain an error code, or list every code:
archx explain E0402
archx explain
```

### Diagnostics and error codes

Every error carries a stable code, printed as `error[E0402]: …` with the source line and a caret:

```
error[E0402]: type mismatch: expected `int`, found `str`
  --> demo.archx.lang:3:14
   |
 3 |     x: int = "hello"
   |              ^
```

The code is the part to script against: messages get reworded, codes do not. `--message-format=json`
turns that report into one object per line, which is what editors and build systems should consume:

```json
{"code":"E0402","severity":"error","message":"type mismatch: expected `int`, found `str`","summary":"type mismatch","file":"demo.archx.lang","line":3,"column":14,"internal":false}
```

`internal: true` means the `E09xx` range: the compiler broke an invariant. Those are Archx bugs and
the message says so. The full registry — one entry per code, each with an explanation — is
[`docs/ERROR_CODES.md`](ERROR_CODES.md), generated from the compiler itself.

---

## 3. Program Structure: Pythonic Script Mode & `def main():`

Archx supports **1:1 Python top-level scripts**, `if __name__ == "__main__":`, and explicit `def main():` / `func main():`:

```python
# Top-level statements run directly in native `main()` — no boilerplate needed!
def square(x: int) -> int:
    return x * x

if __name__ == "__main__":
    n = 12
    print(f"{n}^2 = {square(n)}")
```

Layout rules:
- **4-space indentation**: Blocks start after `:` and indent by 4 spaces per level (tabs in leading indentation are rejected with a line/column diagnostic).
- **No semicolons**: Statements end at a newline; newlines inside `(...)` and `[...]` are ignored.
- **Comments**: `#` starts a comment to end of line.
- **No-op blocks**: `pass` is supported in empty functions, classes, loops, and branches.

---

## 4. Types, Literals & Pythonic Variable Binding

### Built-in types

| Pythonic syntax | Legacy alias | Description | LLVM ABI representation |
|---|---|---|---|
| `int` | `int` | 64-bit signed integer (`1_000_000` underscores supported) | `i64` (overflow-checked) |
| `float` | `float` | 64-bit IEEE-754 double (`3.14`, `1e-5`, `2.5e3`) | `double` (`f64`) |
| `bool` | `bool` | `True` / `False` (also `true` / `false`) | `i1` in SSA, `i8` in `list[bool]` |
| `str` | `string` | Immutable UTF-8 16-byte prefix-SSO string | `%ArchxStr` (`{ i64, i64 }`) |
| `list[T]` | `[T]` | Homogeneous contiguous dynamic array (`list[int]`, `list[Body]`) | `%ArchxVec` or SoA planes |
| `dict[K, V]` | `dict` | Planar `<16 x i8>` SIMD SwissTable dictionary (`dict` = `dict[any, any]`) | `i64` tagged `%ArchxDictHdr*` |
| `set[T]` | `set` | Planar `<16 x i8>` SIMD SwissTable hash set (`set` = `set[any]`) | `i64` tagged `%ArchxDictHdr*` (`v_sz = 0`) |
| `any` | — | Unboxed 24-byte dynamic value (`None`, `bool`, `int`, `float`, `str`, `list`, `dict`, `set`) | `%ArchxAny` (`{ i64, i64, i64 }`) |
| `ClassName` | `StructName` | Value class / struct | `%ArchxStruct_Name` |
| `None` | `void` | Empty / unit return type (`-> None` or omitted `->`) or dynamic `None` value | `void` / `%ArchxAny` (`tag = 0`) |

### Variable assignment without `let` & Smart Adaptive Typing

First assignment in a function/script introduces the variable automatically (`let` remains supported for backward compatibility). Archx's **Two-Tier Adaptive Type Engine** (`analyze_adaptive_types`) inspects the entire function body:
1. **Tier 1 (Zero-Tag Static Specialization)**: Variables whose types stay uniform — including empty `{}` and `[]` inferred from subsequent `scores["a"] = 1` or `xs.append(42)` — compile to **100% unboxed static registers and specialized Planar SIMD containers** with zero tag bits!
2. **Tier 2 (Automatic `%ArchxAny` Dynamic Promotion)**: Variables rebound across incompatible types (`name = "Abdullah"` then `name = 18` or `name = None`), mixed container literals (`{"data": ["Archx", 18, "legal"], "age": 18}`), or untyped parameters (`def describe(val):`) automatically promote to 24-byte stack-register `%ArchxAny`:

```python
x = 42                      # Tier 1: pure i64 SSA register
scores = {}                 # Tier 1: inferred as dict[str, int] from usage below!
scores["k0"] = 100

name = "Abdullah"           # Tier 2: promoted to %ArchxAny because rebound below!
name = 18
name = ["x", 42]
name = None
```

---

## 5. Console I/O (`print`, `input`) & `f"..."` Strings

### `print(*args, sep=" ", end="\n")`
Works just like Python's built-in `print()`:
- Zero, one, or arbitrarily many positional arguments of any type (`int`, `float`, `bool`, `str`, `None`, `list[T]`, `class`/`struct`).
- Keyword arguments `sep="..."` and `end="..."`.
- Whole-valued floats print with `.0` (`print(2.0)` → `2.0`), matching Python.

```python
print()                                 # prints a newline
print("score", 98.5, None, sep=" | ")   # score | 98.5 | None
print("loading...", end="")             # no trailing newline
```

### `input([prompt]) -> str`
Reads a line from `stdin` (stripping trailing `\n` or `\r\n`, returning `""` at `EOF`). If a prompt is passed, prints and flushes `stdout` before reading:

```python
name = input("Enter name: ")
count = int(input("Count: "))
tokens = input().split()
```

### `f"..."` String Interpolation
Arbitrary expressions may appear inside `{...}` (escape literal braces with `{{` and `}}`):

```python
a = 7
b = 2.5
print(f"result={{ok}}: {a} * {b} = {float(a) * b}")
```

---

## 6. Operators, Math & Built-in Conversions

### Arithmetic & comparisons
- `+`, `-`, `*`: checked 64-bit `int` or IEEE-754 `float` (plus `str + str`, `list + list`, `str * int`, `[val] * n`).
- `/`: `float / float` IEEE-754 division (`int / int` truncating division preserved for `v0.1–v0.5` compatibility; use `float(a) / float(b)` for float ratio).
- `//` and `//=`: **Python floor division** rounding toward $-\infty$ (`-7 // 2 == -4`, `-7.0 // 2.0 == -4.0`).
- `**`: **Exponentiation** (`2 ** 10 == 1024`, `2.0 ** 3.5`; negative integer exponents panic cleanly directing you to `float`).
- `%`: Overflow- and zero-safe remainder.
- Inline conditional expression: `val = a if cond else b` (short-circuiting).
- Membership: `sub in text`, `sub not in text`, `elem in xs`, `elem not in xs`.

### Type conversions & math/sequence built-ins
- `int(x)` — parses `str` (trimmed base-10, panics on invalid text), saturates `float` (`@llvm.fptosi.sat.i64.f64`, zero UB on `NaN`/`Inf`), converts `bool` (`0`/`1`).
- `float(x)` — parses `str` via `strtod`, converts `int` or `bool`.
- `str(x)` — formats `int`, `float`, `bool`, `None`, or `str` directly into 16-byte SSO.
- `bool(x)` — Python truthiness at explicit conversion sites (`0`, `0.0`, `""`, `[]` → `False`).
- `len(x)` — element count of `list[T]` or byte length of `str`.
- `abs(x)`, `sqrt(x)`, `min(...)`, `max(...)`, `sum(xs)`, `ord(ch)`, `chr(code)` (resolved via Python's LEGB rule so user-defined functions with the same name cleanly shadow them).
- `assert cond` and `assert cond, "message"` — panics with `AssertionError` (`exit 101`) when `cond` is false.

---

## 7. Pythonic Loops (`range`, `enumerate`, `for`, `while`)

```python
# 1. range(stop), range(start, stop), range(start, stop, step) — positive OR negative step!
for i in range(10):             # 0..9 (bounds checks elided automatically!)
    pass

for k in range(10, 0, -2):      # 10, 8, 6, 4, 2
    print(k)

# 2. enumerate(xs) and enumerate(xs, start) — zero-allocation index + value unpacking!
names = ["ada", "grace", "linus"]
for idx, name in enumerate(names, 1):
    print(f"{idx}. {name}")

# 3. Direct element & character iteration:
for ch in "archx":              # yields 1-byte SSO strings with zero heap allocation!
    print(ch, end=" ")
print()
```

Legacy `for i in a..b:` and `for i in a..b step k:` remain fully supported.

---

## 8. Lists (`list[T]`) & Strings (`str`) Methods

### List operations & methods
```python
xs: list[int] = [1, 2]
xs.append(3)                    # in-place growth (alias for push(xs, 3))
last = xs.pop()                 # 3
combined = xs + [4, 5]          # [1, 2, 4, 5]
zeros = [0.0] * 1_000           # fast zero-page calloc!
xs.clear()                      # drops elements and resets len to 0
```

### String indexing & methods (16-byte SSO aware)
```python
s = "  Hello, Archx!  ".strip() # "Hello, Archx!"
print(s[0])                     # "H" (1-byte inline SSO string, zero heap alloc)
print(s.lower())                # "hello, archx!"
print(s.upper())                # "HELLO, ARCHX!"
print(s.startswith("Hello"))    # true
print(s.endswith("!"))          # true
print(s.find("Archx"))          # 7 (-1 if not found)
print(s.replace("Archx", "LLVM"))
words = "one two  three".split()
csv = "a,b,c".split(",")
```

---

## 9. `class` (Value Structs), `self` Methods & Automatic SoA SIMD

`class` (alias for `struct`) defines unboxed, zero-GC value objects with positional **or keyword** construction and `def method(self, ...):` methods:

```python
class Body:
    x: float
    vx: float
    mass: float

    # Mutating `self` automatically passes `ptr %self` under the hood!
    def integrate(self, dt: float) -> None:
        self.x += self.vx * dt

    # Read-only `self` passes unboxed value registers and inlines at -O2!
    def kinetic(self) -> float:
        return 0.5 * self.mass * self.vx * self.vx

b = Body(mass=2.0, x=0.0, vx=3.0)
b.integrate(0.5)
print(b.x, b.kinetic())         # 1.5 9.0
```

### Automatic AoS-to-SoA Planarization (`[Body(...)] * n`)
When a local array of scalar-field `class`/`struct` values (`bodies = [Body(0.0, 1.0, 2.0)] * n`) does not escape and only calls read-only methods or accesses fields, Archx **transparently splits it into separate 16-byte-aligned per-field SIMD planes** (`double* x`, `double* vx`, `double* mass`), beating `-O2` C and `-O` Rust on floating-point N-body simulations (`benchmarks/nbody_float.*`).

---

## 10. Scoped `with region:` Bump Arenas

Both `with region:` and `region:` activate a 64 KB bump-allocated arena slab (`O(1)` pointer bump, reused across loop iterations, compile-time escape-checked, with automatic heap promotion on `return`):

```python
def run_batches(rounds: int) -> str:
    acc = 0
    for r in range(rounds):
        with region:
            scratch = [0] * 512
            scratch[0] = r
            acc += scratch[0]
    with region:
        out = f"completed {rounds} rounds (acc={acc})"
        return out              # automatically promoted to heap before region unwind!
```

---

## 11. Planar SIMD Dictionaries (`dict`), Sets (`set`), Slicing & Dynamic `any`

### Planar `<16 x i8>` SIMD Dictionaries & Sets
Archx `dict[K, V]` and `set[T]` combine **16-wide `<16 x i8>` SwissTable SIMD control-byte probing** with **dense insertion-ordered planar `keys[]` and `vals[]` arrays** (like CPython's compact dict, without GC or PyObject pointer chasing) and full `with region:` arena support:

```python
scores = {"alpha": 10, "beta": 20}
scores["alpha"] += 5
print(scores.get("gamma", -1))      # -1
removed = scores.pop("beta")        # 20 (preserves insertion order!)

for k, v in scores.items():         # dense 0..len plane scan — skips 0 empty buckets!
    print(k, v)

uniq = set([5, 3, 5, 1, 9])         # or {5, 3, 1, 9}
uniq.add(7)
uniq.discard(99)
print(3 in uniq, len(uniq))         # true 5
```

### Pythonic Slicing & Negative Indexing (`xs[a:b:step]`, `xs[-1]`, `s[::-1]`)
Lists, strings, and dynamic `any` sequences support Python negative indices (`idx < 0` adds `len` once before bounds checking) and full `start:stop:step` clamping (including negative steps):

```python
nums = [10, 20, 30, 40, 50, 60]
nums[-1] = 66
print(nums[1:4])                    # [20, 30, 40] (contiguous memcpy fast path!)
print(nums[::-2])                   # [66, 40, 20]

s = "Archx-v0.7"
print(s[0:5], s[-4:], s[::-1])      # Archx v0.7 7.0v-xhcrA
```

### Dynamic Containers, Untyped Functions, `is None` & `type(x)`
```python
def describe(val):                  # untyped parameter defaults to %ArchxAny
    if val is None:
        return "empty"
    return f"{type(val)}:{val}"

hello = {"data": ["Archx", 18, "legal"], "age": 18}
hello["data"].append("fast")        # mutates nested list in place!
hello["age"] += 3
print(describe(hello["data"]), describe(None))
```

---

## 12. Tuples, `T | None` Optionals, Algebraic `enum`s & Structural `match` / `case` (`v0.8.0`)

### Zero-Heap Tuples & Unpacking (`(a, b)`, `tuple[T1, T2]`, `a, b = b, a`)
Tuples compile directly to unboxed LLVM register/stack aggregates (`{ i64, %ArchxStr }`) with **zero heap allocation**:

```python
def min_max_sum(xs: list[int]) -> tuple[int, int, int]:   # or `-> (int, int, int):`
    lo, hi, total = xs[0], xs[0], 0
    for x in xs:
        if x < lo:
            lo = x
        if x > hi:
            hi = x
        total += x
    return lo, hi, total

lo, hi, total = min_max_sum([12, 5, 42, 19])
a, b = 10, 99
a, b = b, a                                               # zero-temp register swap
pair = ("archx", 8, True)
print(lo, hi, total, a, b, pair[0], pair[-1], len(pair))

for k, v in [("x", 2), ("y", 5)]:
    print(k, v)
```

### Stack-Inline `T | None` Optionals & Flow-Sensitive Narrowing
`T | None` lowers to `{ i1, T }` on the stack/in registers (zero heap boxing!), automatically coercing `T` and `None` on assignment/return and narrowing `x` to `T` after `if x is not None:`, `if x is None: return`, or `x + 1 if x is not None else -1`:

```python
def find_spike(xs: list[int], threshold: int) -> int | None:
    for i, x in enumerate(xs):
        if x >= threshold:
            return i
    return None

idx = find_spike([4, 9, 25, 11], 20)
if idx is not None:
    print(idx + 100)                                      # `idx` narrowed to `int`!
```

### Algebraic `enum` Sum Types & Exhaustive `match` / `case`
`enum` declares stack-inline tagged sum types (`%ArchxEnum_Name = type { i64, [W x i64] }`) supporting unit and payload-carrying variants (including heap/SSO `str`, `list`, `dict`, tuples, and `with region:` return promotion). `match` / `case` supports literals, bindings, `_`, tuple patterns, `Enum.Variant(...)` destructuring, `|` OR-patterns, and `if` guards — and **rejects non-exhaustive `enum` matches at compile time**:

```python
enum Event:
    Circle(float)
    Rect(float, float)
    Tag(str)
    Idle

def score(ev: Event) -> float:
    match ev:
        case Event.Circle(r) if r >= 10.0:
            return 3.14159 * r * r
        case Event.Circle(r):
            return 2.0 * 3.14159 * r
        case Event.Rect(w, h):
            return w * h
        case Event.Tag(s):
            return float(len(s))
        case Event.Idle:
            return 0.0
```

### Python `def __init__(self, ...):` Constructors
Classes can declare fields either PEP-526 style (`x: float`) or standard Python `def __init__(self, x: float, y: float): self.x = x; self.y = y` (or both). See [`examples/comparison/`](../examples/comparison/README.md) for a complete **byte-for-byte identical** Python 3.10+ vs Archx 1:1 Pythonic vs Archx Speed vs C vs Rust comparison!

## 13. Comprehensions, Generator Folds, Generics, `lambda` & Inline Sorting (`v0.9.0`)

### List / set / dict comprehensions & nested comprehensions
Each comprehension lowers to a fused loop nest over a **single pre-sized buffer**, so an
unfiltered map never reallocates (`range(...)` is resolved to a length before the buffer is
allocated) and filters only ever shrink the result:

```python
squares = [x * x for x in range(10)]                    # one allocation, no growth
evens = [x for x in squares if x % 2 == 0]
flat = [v for row in grid for v in row]                 # multiple `for` clauses
pairs = [(a, b) for a in range(n) for b in range(n) if (a + b) % 7 == 0]
tags = {x % 5 for x in range(100)}                      # set comprehension
table = {k: k * k for k in range(16)}                   # dict comprehension
grid = [[r * c for c in range(4)] for r in range(4)]    # nested comprehension
```

### Generator reductions — no intermediate list at all
`sum`, `min`, `max`, `any`, `all`, and `len` accept a generator expression and fold it in a
**single pass**, evaluating the element expression exactly once. `any`/`all` short-circuit;
`min`/`max` are a branch-free `select` scan with no calls:

```python
print(sum(x * x for x in range(101)))                    # 338350
print(sum(x for x in range(1000) if x % 3 == 0))
print(max(x * 2 for x in range(50)))
print(any(x > 99 for x in xs))
print(all(x >= 0 for x in xs))
```

### PEP 695 generic functions & classes
Type parameters are **monomorphized**: one concrete function or struct is emitted per set of
type arguments, so a generic is exactly as fast as a hand-specialized copy. Instantiation can be
**explicit** (`add[int](7, 8)`) or **implicit** — the type arguments are resolved from the
static types of the arguments (`add(3, 4)` → `T = int`):

```python
def add[T](a: T, b: T) -> T:
    return a + b

def total[T](xs: list[T]) -> list[T]:  # works for every element type
    ...

class Box[T]:
    def __init__(self, value: T):
        self.value = value

    def get(self) -> T:
        return self.value

print(add(3, 4))              # 7        (implicit T = int)
print(add("a", "b"))          # ab       (implicit T = str)
print(add[int](7, 8))         # 15       (explicit)
b = Box[int](41)
print(b.get() + 1)            # 42
```

### Zero-heap `lambda`
A `lambda` is lifted to a `fastcc` function whose captures become leading scalar arguments — no
heap-allocated closure object, no indirect call — and is used either bound to a name or inlined
as `key=`:

```python
double = lambda x: x * 2
print(double(21))                                  # 42
print(sorted(xs, key=lambda v: -v))
```

### `zip(...)`
`zip` is a fused loop header (`for a, b in zip(xs, ys)`) *and* a value materialized as
`list[tuple[...]]` in one pre-sized buffer:

```python
for a, b in zip([1, 2, 3], [4, 5, 6]):
    print(a + b)

print(list(zip([1, 2], [3, 4])))                  # [(1, 3), (2, 4)]
```

### Inline monomorphized sorting: `sorted(...)` and `list.sort(...)`
Both forms compile to an inline **stable bottom-up merge sort**: `O(N log N)` compares and moves
with no quadratic worst case, no recursion, and no comparator callback. `key=` is inlined into
the record-fill loop (evaluated exactly `N` times) with a planar `{ key, orig_idx }` Schwartzian
transform, and `reverse=True` stays **stable** — only the key ordering is inverted:

```python
xs = [5, 3, 9, 1, 7]
print(sorted(xs))                          # [1, 3, 5, 7, 9]
print(sorted(xs, reverse=True))            # [9, 7, 5, 3, 1]
print(sorted(words, key=lambda w: len(w)))
print(sorted(fs, key=lambda v: -v))        # descending without `reverse=`
xs.sort()                                  # in place
xs.sort(key=lambda v: v % 3, reverse=True)
```

Keyless element types are `int`, `float`, `bool`, `str`, and **tuples of comparable components**
(`sorted(pairs)` orders `(name, count)` tuples lexicographically, component by component, with
`reverse=True` reversing that order). Strings compare through an SSO-aware three-way compare, so
short strings cost no heap traffic. Any other element type needs a `key=` that returns one of those.

> **Printing note.** Archx has no `repr` layer: `print` on a container renders `str` elements
> unquoted (`[a, apple]`) whereas CPython prints `['a', 'apple']`. Iterate and quote explicitly if
> you need byte-identical output. Everything else — ordering, `zip` contents, `sorted` results —
> matches CPython exactly.

See [`examples/comprehensions_and_sorting.archx.lang`](../examples/comprehensions_and_sorting.archx.lang)
for a complete file whose output is verified byte-identical to CPython in the test suite.


---

## 14. Pythonic Call & Loop Semantics (`v0.9.1`)

### Default parameters and keyword arguments
```python
def greet(name: str, punct: str = "!", loud: bool = false) -> str:
    return name + punct + punct if loud else name + punct

def rect(w: int, h: int = 2) -> int:
    return w * h

print(greet("hi"))                     # hi!
print(greet("hi", punct="?"))          # hi?
print(greet(loud=true, name="hey"))    # hey!!
print(rect(h=3, w=4), rect(5))         # 12 10
```
Defaults bind at the call site, keywords are matched against the declared parameter names,
and unknown or duplicated keywords are compile errors.

### `for ... else`
The `else` body runs only when the loop finished **without** `break` — the idiomatic Python
search loop needs no sentinel variable:

```python
def find(target: int) -> str:
    for i in range(4):
        if i == target:
            return "found"
    else:
        return "missing"
```
Both `for i in 0..n:` and `for x in iterable:` forms accept `else:`. The completion flag is only
materialized when the body can actually `break`, so the common loop pays nothing for it.

### Loop variables are function-scoped, like CPython
```python
for j in range(2):
    pass
print(j)                                   # 1  (the last value the body saw)

for row in range(2):
    for col in range(3):
        pass
print(row, col)                            # 1 2
```
This holds for `range`, list, `str`, `enumerate`, `dict.items` and `zip` headers, including nested
loops and `for c in "ab"`.

### `map` / `filter`
Both lower to a pre-sized comprehension loop: a named function becomes a direct `fastcc` call,
an inline `lambda` is inlined, and soft builtins work too — no function values, no boxing.

```python
nums = [1, 2, 3, 4, 5]
print(list(map(lambda x: x * x, nums)))     # [1, 4, 9, 16, 25]
print(list(filter(lambda x: x % 2 == 1, nums)))  # [1, 3, 5]
print(sum(map(sq, nums)))                   # named function, same inlining
print(list(map(str, nums)))                 # ['1', ...] (printed unquoted)
```
