<!-- Complete user manual and language reference for everything built in Archx up to Milestone 5 (v0.5.0). -->

# Archx Language & Usage Guide (`v0.5.0`)

This guide documents **everything built in Archx so far** and **how to use every CLI option and language feature**.

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

Single extensions like `.archx` are rejected with an explicit error so non-Archx files are never compiled accidentally.

### CLI commands & flags

```sh
# 1. Compile to native executable in current directory (e.g. ./hello or .\hello.exe):
archx examples/hello.archx.lang

# 2. Compile to a custom output path (-o refuses to overwrite the input source file):
archx examples/hello.archx.lang -o build/hello

# 3. Compile and immediately execute (propagating the program's exit code):
archx examples/hello.archx.lang --run

# 4. Print the generated textual LLVM IR to stdout without invoking clang:
archx examples/hello.archx.lang --emit-ir

# 5. Show help or compiler version:
archx --help
archx --version
```

Environment variable override:
- `ARCHX_CC=/custom/path/to/clang archx app.archx.lang` — overrides compiler driver discovery.

---

## 3. Program Structure & Layout Rules

1. **Entry point**: Executable programs define `func main():` (or `func main() -> int:`).
2. **Top-level items**: A file contains `struct` definitions and `func` definitions in any order (functions and non-cyclic structs may reference declarations later in the file).
3. **4-space indentation**: Blocks start after `:` + newline and indent by **4 spaces per level**. Tabs in leading indentation are rejected with a line/column diagnostic.
4. **No semicolons**: Statements end at a newline. Inside `(...)` or `[...]`, newlines are ignored so long calls or array literals can span multiple lines. (`;` is only used inside `[value; count]` repeat arrays.)
5. **Comments**: `#` starts a comment running to the end of the line.

```archx
# Minimal Archx program
func main():
    print("Hello, Archx!")
```

---

## 4. Types & Variables

### Built-in types

| Type syntax | Description | Underlying representation |
|---|---|---|
| `int` | 64-bit signed integer (`-9223372036854775808` .. `9223372036854775807`) | `i64` (checked arithmetic) |
| `bool` | Boolean (`true` or `false`) | `i1` in SSA / `i8` in `[bool]` arrays |
| `string` or `str` | Immutable UTF-8 string (16-byte prefix-SSO) | `%ArchxStr` (`{ i64, i64 }`) |
| `[T]` | Contiguous homogeneous array (`[int]`, `[bool]`, `[str]`, `[[int]]`, `[Body]`) | `%ArchxVec` (`{ len, cap, ptr }`) or SoA planes |
| `StructName` | User-defined value struct | `%ArchxStruct_Name` (unboxed value) |
| `void` | Explicit empty return type (`-> void` or omitted `->`) | `void` |

### Declaring & updating variables

```archx
func main():
    let x = 42                  # inferred as int
    let limit: int = 100        # explicit type annotation
    let empty: [int] = []       # required for empty array literals so [T] is known

    x = x + 8                   # reassignment (must already be declared via `let`)
    x += 10                     # compound: +=, -=, *=, /=, %=
    x -= 5
    x *= 2
    x /= 3
    x %= 7
    print(x)
```

---

## 5. Checked Arithmetic, Comparisons & Booleans

### Checked integer arithmetic (`int`)

All `int` arithmetic is **100% free of C signed-overflow and division undefined behavior**:
- `+`, `-`, `*`, and unary `-` check for 64-bit signed overflow (`archx runtime panic` + exit code `101` on overflow; elided to `add/sub/mul nsw` when loop bounds prove safety).
- `/` and `%` check for division by zero (`exit 101`) and safely handle `i64::MIN / -1` and `i64::MIN % -1` without trapping (`SIGFPE`).

### Comparisons & logical operators

- Relational (`int`): `<`, `>`, `<=`, `>=` → `bool`
- Equality (`int`, `bool`, `str`, `Struct`): `==`, `!=` → `bool`
- Short-circuit boolean logic (`bool` only — no implicit `0` or `""` truthiness):
  - `a and b` (`b` is not evaluated if `a` is `false`)
  - `a or b` (`b` is not evaluated if `a` is `true`)
  - `not a`

---

## 6. Conditionals (`if` / `elif` / `else`)

```archx
func classify(score: int) -> str:
    if score >= 90:
        return "A"
    elif score >= 80:
        return "B"
    elif score >= 70:
        return "C"
    else:
        return "D"
```

---

## 7. Loops (`while`, `for`, `step`, `foreach`, `break`, `continue`)

Archx provides four clean loop forms:

### 1. Half-open range loop (`for i in start..end:`)
Counts `start, start + 1, ..., end - 1` (`end` is exclusive; both `start` and `end` evaluate once before the loop):

```archx
let total = 0
for i in 1..11:
    total += i      # sums 1..=10 -> 55
```

### 2. Strided range loop (`for i in start..end step k:`)
Advances by `k` on each iteration (`k` must be `> 0`; panics cleanly if `k <= 0` at runtime or rejects at compile time if constant `<= 0`):

```archx
for i in 0..100 step 8:
    print(i)        # 0, 8, 16, ..., 96
```

### 3. Element `foreach` loop (`for item in arr:`)
Iterates directly over every element of an array (or SoA struct array) with **zero bounds checks**:

```archx
let words = ["fast", "safe", "clean"]
for w in words:
    print(w)
```

### 4. Condition loop (`while cond:`) & `break` / `continue`

```archx
let n = 10
while n > 0:
    n -= 1
    if n == 5:
        continue    # skips printing 5
    if n == 2:
        break       # exits loop early
    print(n)
```

---

## 8. Functions

Parameter types and non-void return types are always written explicitly at function boundaries:

```archx
func gcd(a: int, b: int) -> int:
    while b != 0:
        let r = a % b
        a = b
        b = r
    return a

func log_banner(title: str):
    print("=== " + title + " ===")
```

---

## 9. Arrays (`[T]`)

Arrays are contiguous, bounds-safe buffers with automatic deterministic scope-exit cleanup:

```archx
func main():
    # 1. Element list literal:
    let nums = [10, 20, 30]
    nums[1] += 5
    print(nums)                 # [10, 25, 30]

    # 2. Repeat initializer [value; count]:
    let flags = [true; 1000]    # 1 byte per bool; [0; n] / [false; n] uses zero-page calloc
    print(len(flags))           # 1000

    # 3. Dynamic growth & shrink (push / pop):
    let stack: [int] = []
    push(stack, 7)
    push(stack, 9)
    let top = pop(stack)        # 9 (panics cleanly if stack is empty)
    print(top)

    # 4. Nested multi-dimensional arrays:
    let grid = [[1, 2], [3, 4]]
    grid[0][1] = 99
    print(grid[0][1])           # 99
```

**Bounds-check elision**: Indexing inside `for i in 0..len(arr):`, `for i in 0..len(arr) step k:`, `for x in arr:`, or monotonic `while j < len(arr):` (`j += step`) automatically proves `0 <= i < len(arr)` and removes per-element bounds branches so LLVM can SIMD-vectorize the loop.

---

## 10. Strings (`string` / `str`)

Strings are immutable UTF-8 values stored in a **16-byte German/Umbra prefix-SSO layout**:
- Both `'single'` and `"double"` quotes are supported.
- Supported escapes: `\n`, `\r`, `\t`, `\\`, `\'`, `\"`, and `\0` (embedded NUL bytes are preserved accurately).
- Strings `<= 12` bytes live **100% inline in CPU registers** with zero heap allocations.
- Strings `> 12` bytes store their byte length + first 4 bytes inline so `==` / `!=` rejects non-matching strings in a single register compare.

```archx
func main():
    let a: str = "archx"
    let b = "ar" + "chx"
    print(a == b)               # true (2 register compares, 0 memory loads)
    print(len(b))               # 5

    let msg = "status: "
    msg += "ready-for-production"
    print(msg)
    print(msg != "status: idle")
```

---

## 11. Value `struct`s & Transparent AoS-to-SoA Planarization

### Declaring and using `struct`s

Structs are unboxed value types constructed with **positional arguments in field declaration order**:

```archx
struct Vec2:
    x: int
    y: int

struct Entity:
    name: str
    pos: Vec2

func translate(v: Vec2, dx: int, dy: int) -> Vec2:
    return Vec2(v.x + dx, v.y + dy)

func main():
    let p = Vec2(10, 20)
    let q = p                   # value copy (mutating q does NOT mutate p)
    q.x += 5
    print(p)                    # Vec2(10, 20)
    print(q == Vec2(15, 20))    # true

    let e = Entity("player", translate(q, 1, -2))
    print(e.name)               # player
    print(e.pos.y)              # 18
```

### Automatic AoS-to-SoA Planarization (`[Struct]`)

When you create a local fixed-length array of a scalar-field struct (such as `let bodies = [Body(0, 0, 1, 2); n]`) and do not resize (`push`/`pop`), rebind, or pass the whole array to another function, Archx **transparently splits the array into separate 16-byte-aligned per-field planes** (`x[]`, `y[]`, `vx[]`, `vy[]`) behind the scenes. Your code stays clean `bodies[i].x += bodies[i].vx` and `for b in bodies:`, while the CPU gets 100% cache-line utilization and SIMD vectorization.

---

## 12. Scoped `region:` Bump Arenas

Wrap temporary batch/loop allocations inside `region:` to allocate `[T]` buffers and concatenated strings with a **2-instruction pointer bump** inside a reused 64 KB slab instead of calling `malloc`/`free` every iteration:

```archx
func summarize(rounds: int) -> str:
    let checksum = 0
    for r in 0..rounds:
        region:
            # Reuses the same 64 KB slab on every iteration (0 malloc/free after r=0)
            let scratch = [0; 256]
            for i in 0..len(scratch) step 4:
                scratch[i] = r + i
            let tag = "batch_header_" + "temporary_payload"
            if len(tag) > 10:
                checksum += scratch[0]

    region:
        let result = "done:" + "promoted_cleanly_on_return"
        if checksum >= 0:
            # Returning from inside `region:` automatically promotes `result` to the heap
            # before rewinding and freeing the region slabs!
            return result
    return "unreachable"
```

**Region safety rules**:
1. **Escape prevention**: Assigning a region-allocated owning value (`[T]`, `str`, owning `Struct`) into a variable declared *outside* the `region:` is rejected at compile time (`cannot store heap/region value ... into outer variable '...' inside 'region:'`).
2. **Scalar extraction**: Reading `int` or `bool` results (`checksum += scratch[0]`, `len(tag)`) into outer variables is always allowed and zero-cost.
3. **Return promotion**: `return expr` from inside `region:` automatically deep-promotes any region-backed string/array/struct to heap ownership before cleaning up the region.

---

## 13. Runtime Safety & Diagnostics

Compile-time errors report 1-based `line:col` spans with caret pointers:

```text
error: cannot store heap/region value of type `[int]` into outer variable `outer` inside `region:`
  --> 5:9
   |
  5 |         outer = tmp
   |         ^
```

Runtime panics print an explicit message and exit with status code **`101`** (never corrupting memory or invoking undefined behavior):
- Out-of-bounds array index (`archx runtime panic: index X out of bounds for length Y`)
- Signed 64-bit integer overflow (`archx runtime panic: integer overflow`)
- Division or modulo by zero (`archx runtime panic: division by zero`)
- Invalid repeat length or non-positive loop `step` (`archx runtime panic: invalid array/step size (N)`)
- `pop` on an empty array (`archx runtime panic: pop from an empty array`)
- Allocation failure (`archx runtime panic: out of memory`)
