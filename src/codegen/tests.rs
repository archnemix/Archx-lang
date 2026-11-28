//! Unit tests for LLVM IR lowering, bounds-check elision, SoA structs, SSO strings, and region escape rules.

    use super::*;
    use crate::lexer::Lexer;
    use crate::parser::Parser;

    fn lower_src(src: &str) -> Result<String> {
        let toks = Lexer::new(src).tokenize()?;
        let prog = Parser::new(toks).parse_program()?;
        lower(&prog)
    }

    #[test]
    fn lowers_hello_world_to_llvm_ir() {
        let ir = lower_src("func main():\n    print(\"Hello, Archx!\")\n").unwrap();
        assert!(ir.contains("define i32 @main()"));
        assert!(ir.contains("Hello, Archx!"));
        assert!(ir.contains("call i32 (ptr, ...) @printf"));
    }

    #[test]
    fn lowers_recursion_and_arithmetic_with_fastcc() {
        let src = "\
func fib(n: int) -> int:
    if n <= 1:
        return n
    return fib(n - 1) + fib(n - 2)

func main():
    print(fib(10))
";
        let ir = lower_src(src).unwrap();
        assert!(ir.contains("define internal fastcc i64 @archx_fn_fib(i64 %arg.n)"));
        assert!(ir.contains("icmp sle i64"));
        // AX-002: integer arithmetic is trapping. `n - 1` and the `+` in `fib(n-1) + fib(n-2)`
        // must go through the overflow-checking intrinsics, never a bare wrapping `add`/`sub`.
        assert!(ir.contains("@llvm.ssub.with.overflow.i64"));
        assert!(ir.contains("@llvm.sadd.with.overflow.i64"));
        assert!(ir.contains("@archx_int_overflow_fail"));
        assert!(!ir.contains(" = sub i64 "));
    }

    #[test]
    fn bounds_checks_elided_for_proven_range_and_sized_arrays() {
        let src = "\
func sum_slice(xs: [int]) -> int:
    let total = 0
    for i in 0..len(xs):
        total += xs[i]
    return total

func combine(n: int) -> int:
    let a = [1; n]
    let b = [0; n]
    for i in 0..n:
        b[i] = a[i] * 3
    return sum_slice(b)

func main():
    let lit = [10, 20, 30]
    print(lit[2] + combine(16))
";
        let ir = lower_src(src).unwrap();
        assert!(
            !ir.contains("@archx_bounds_fail"),
            "all array accesses in proven loops and literal constants must elide bounds checks:\n{ir}"
        );
    }

    #[test]
    fn bounds_check_emitted_for_unproven_dynamic_index() {
        let src = "\
func get_at(xs: [int], k: int) -> int:
    return xs[k]

func main():
    let xs = [1, 2, 3]
    print(get_at(xs, 1))
";
        let ir = lower_src(src).unwrap();
        assert!(ir.contains("@archx_bounds_fail"));
    }

    #[test]
    fn compile_time_rejects_constant_oob_and_negative_repeat() {
        let oob = lower_src("func main():\n    let xs = [1, 2]\n    print(xs[2])\n").unwrap_err();
        assert!(oob.message.contains("out of bounds"));

        let neg = lower_src("func main():\n    let xs = [0; -3]\n    print(len(xs))\n").unwrap_err();
        assert!(neg.message.contains("negative"));
    }

    #[test]
    fn sso_strings_and_soa_structs_lower_cleanly() {
        let src = "\
struct Body:
    x: int
    vx: int

func main():
    let s = \"hello\"
    let bodies = [Body(1, 2); 64]
    for i in 0..64:
        bodies[i].x += bodies[i].vx
    print(s)
    print(bodies[0].x)
";
        let ir = lower_src(src).unwrap();
        assert!(
            !ir.contains("@archx_str_clone"),
            "short SSO literal must not heap-allocate:\n{ir}"
        );
        assert!(
            !ir.contains("%ArchxVec"),
            "non-escaping [Body; 64] should lower to transparent SoA planes without %ArchxVec:\n{ir}"
        );
    }

    #[test]
    fn region_rejects_escape_to_outer_variable() {
        let src = "\
func main():
    let outer = [1, 2]
    region:
        let tmp = [3, 4]
        outer = tmp
    print(len(outer))
";
        let err = lower_src(src).unwrap_err();
        assert!(err.message.contains("region"));
    }

    #[test]
    fn pythonic_float_soa_range_methods_and_io_lower_cleanly() {
        let src = "\
class Body:
    x: float
    vx: float

    def speed(self) -> float:
        return abs(self.vx)

def step_bodies(n: int) -> float:
    bodies = [Body(0.0, 1.5)] * n
    total = 0.0
    for i in range(n):
        bodies[i].x += bodies[i].speed()
        total += bodies[i].x
    return total

line = input()
val = step_bodies(16)
print(f\"{line}:{val}\", end=\"\\n\")
";
        let ir = lower_src(src).unwrap();
        assert!(
            !ir.contains("%ArchxVec"),
            "Pythonic `[Body(0.0, 1.5)] * n` with read-only method should use SoA float planes:\n{ir}"
        );
        assert!(
            !ir.contains("@archx_bounds_fail"),
            "Pythonic `for i in range(n):` over `[Body(...)] * n` must elide bounds checks:\n{ir}"
        );
        assert!(ir.contains("@archx_input"));
    }

/// One program per runtime subsystem (AX-009).
///
/// The v0.9.1 `%` bug and the `%ArchxAny` binop bug were both *shape* bugs: the emitted text was
/// plausible but ill-formed, and nothing fed it to an IR verifier until a program happened to
/// exercise that path. This corpus is lowered by the unit test below; the emitted modules are written
/// to `ci/out/runtime-corpus/` so `ci/verify_ir.sh` can verify the same sources with a real frontend.
const RUNTIME_CORPUS: [(&str, &str); 9] = [
    (
        "ints_and_floats",
        "func main():\n    let a = 6\n    let b = 4\n    print(a % b, a / b, 2 ** 10, 1.5 % 1.0)\n",
    ),
    (
        "lists_and_strings",
        "func main():\n    let xs = [3, 1, 2]\n    push(xs, 9)\n    print(xs, len(xs), \"ab\" + \"cd\", \"ab\" == \"cd\")\n",
    ),
    (
        "dict_and_set",
        "def main():\n    counts = {}\n    counts[\"a\"] = 1\n    counts[\"b\"] = 2\n    seen = {1, 2}\n    seen.add(3)\n    print(counts[\"a\"], len(seen), 1 in seen)\n",
    ),
    (
        "any_engine",
        "def inspect_val(x):\n    if isinstance(x, int):\n        return x + 1\n    return x\n\ndef main():\n    hello = {\"data\": [\"Archx\", 18], \"age\": 18}\n    name = \"Abdullah\"\n    name = 18\n    print(hello[\"age\"], name, type(name), inspect_val(name))\n",
    ),
    (
        "regions",
        "func main():\n    with region:\n        let xs = [1, 2, 3]\n        print(len(xs))\n",
    ),
    (
        "structs_and_soa",
        "struct Body:\n    x: float\n    y: float\n\nfunc main():\n    let bodies = [Body(1.0, 2.0); 4]\n    let total = 0.0\n    for i in 0..len(bodies):\n        total += bodies[i].x + bodies[i].y\n    print(total)\n",
    ),
    (
        "tuples_optionals_enums_match",
        "enum Shape:\n    Circle(float)\n    Rect(float, float)\n\ndef area(s: Shape) -> float:\n    match s:\n        case Shape.Circle(r):\n            return 3.0 * r * r\n        case Shape.Rect(w, h):\n            return w * h\n        case _:\n            return 0.0\n\nfunc main():\n    print(area(Shape.Circle(2.0)), area(Shape.Rect(2.0, 3.0)))\n",
    ),
    (
        "comprehensions_sort_zip_generics",
        "def ident[T](x: T) -> T:\n    return x\n\nfunc main():\n    let squares = [x * x for x in range(6) if x % 2 == 0]\n    let total = sum(x * 2 for x in range(4))\n    let pairs = zip([1, 2], [3, 4])\n    print(squares, total, len(pairs), ident(7))\n",
    ),
    (
        "input_and_errors",
        "func main():\n    let line = input(\"prompt: \")\n    assert len(line) >= 0\n    print(line)\n",
    ),
];

    #[test]
    fn every_runtime_feature_lowers_to_ir() {
        let dir = std::path::Path::new("ci/out/runtime-corpus");
        std::fs::create_dir_all(dir).expect("create the runtime corpus directory");
        for (name, src) in RUNTIME_CORPUS {
            let ir = lower_src(src).unwrap_or_else(|e| panic!("`{name}` must lower to IR: {e}"));
            assert!(
                ir.contains("define i32 @main()"),
                "`{name}` must produce a main entry point:\n{ir}"
            );
            assert!(
                ir.contains("; archx.dialect=native"),
                "`{name}` must carry the dialect flag:\n{ir}"
            );
            std::fs::write(dir.join(format!("{name}.ll")), ir).expect("write the corpus module");
        }
    }

    #[test]
    fn adaptive_engine_specializes_static_dict_without_any_overhead() {
        let src = "\
counts = {}
counts[\"archx\"] = 10
counts[\"llvm\"] = 20
counts[\"archx\"] += 5
seen = {1, 2, 3}
seen.add(4)
xs = [10, 20, 30, 40, 50]
sub = xs[1:4]
print(counts[\"archx\"], len(seen), sub[-1])
";
        let ir = lower_src(src).unwrap();
        assert!(
            ir.contains("@archx_dict_upsert_str"),
            "homogeneous str->int dict must specialize to Planar SIMD str SwissTable:\n{ir}"
        );
        assert!(
            !ir.contains("%ArchxAny"),
            "statically specialized dict/set/slice code must emit zero %ArchxAny overhead:\n{ir}"
        );
    }

    #[test]
    fn adaptive_engine_promotes_mixed_literals_and_rebinding_to_any() {
        let src = "\
def inspect_val(x):
    if isinstance(x, int):
        return x + 1
    return x

hello = {\"data\": [\"Archx\", 18, \"legal\"], \"age\": 18}
name = \"Abdullah\"
name = 18
print(hello[\"data\"][0], hello[\"age\"], name, type(name), inspect_val(name))
";
        let ir = lower_src(src).unwrap();
        assert!(
            ir.contains("@archx_dict_upsert_str"),
            "`hello` has homogeneous `str` keys so keys stay specialized `dict[str, any]`:\n{ir}"
        );
        assert!(
            ir.contains("%ArchxAny"),
            "mixed-value dict + type-rebound `name` + untyped `def` must lower via %ArchxAny:\n{ir}"
        );
    }

    #[test]
    fn tuples_optionals_enums_and_match_compile_without_any_overhead() {
        let src = "\
enum Shape:
    Circle(float)
    Rect(float, float)
    Empty

def div_opt(a: int, b: int) -> int | None:
    if b == 0:
        return None
    return a // b

def area(s: Shape) -> float:
    match s:
        case Shape.Circle(r) if r > 0.0:
            return 3.0 * r * r
        case Shape.Circle(_):
            return 0.0
        case Shape.Rect(w, h):
            return w * h
        case Shape.Empty:
            return 0.0

def main():
    pair = (10, 20)
    x, y = pair
    q = div_opt(x + y, 3)
    if q is not None:
        print(q + 1, area(Shape.Rect(2.0, 5.0)))
";
        let ir = lower_src(src).unwrap();
        assert!(ir.contains("%ArchxEnum_Shape = type { i64, [2 x i64] }"), "{ir}");
        assert!(ir.contains("{ i1, i64 }"), "int | None must lower to stack {{ i1, i64 }}:\n{ir}");
        assert!(
            !ir.contains("%ArchxAny"),
            "static tuples, T | None, enums, and match must emit zero %ArchxAny overhead:\n{ir}"
        );
    }

    #[test]
    fn non_exhaustive_enum_match_and_oob_tuple_index_are_rejected() {
        let non_exh = "\
enum Cmd:
    Start(int)
    Stop

def run(c: Cmd) -> int:
    match c:
        case Cmd.Start(x):
            return x
    return 0

def main():
    print(run(Cmd.Stop))
";
        let err = lower_src(non_exh).unwrap_err();
        assert!(
            err.message.contains("non-exhaustive") && err.message.contains("Cmd.Stop"),
            "got: {}",
            err.message
        );

        let oob_tup = "\
def main():
    t = (1, \"hi\")
    print(t[2])
";
        let err2 = lower_src(oob_tup).unwrap_err();
        assert!(err2.message.contains("out of range"), "got: {}", err2.message);
    }
