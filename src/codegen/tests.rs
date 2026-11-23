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
        assert!(ir.contains("sub i64"));
        assert!(ir.contains("add i64"));
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
