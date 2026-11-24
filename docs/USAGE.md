<!-- Complete user manual and language reference for everything built in Archx up to Milestone 7 (v0.7.0). -->

# Archx Language & Usage Guide (`v0.7.0`)

Archx gives you **1:1 Pythonic syntax, Planar SIMD `dict`/`set`, slicing, negative indexing, smart two-tier adaptive typing (`any`), and standard console I/O** (`def`, `class`, `self`, `dict`, `set`, `xs[a:b:step]`, `xs[-1]`, `range`, `enumerate`, `f"..."`, `print(..., sep=..., end=...)`, `input()`, `float`, `list[T]`) compiled directly to **native machine code via LLVM IR (`clang -O2`)** with **zero garbage collector**, **transparent AoS-to-SoA SIMD**, **16-byte prefix-SSO strings**, and **scoped `region:` bump arenas**.

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

### CLI commands & flags

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
```

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
