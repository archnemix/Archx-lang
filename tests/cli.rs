//! End-to-end CLI integration tests exercising compilation, execution, runtime panics, and CLI flags
//! across Linux, macOS, and Windows.

use std::fs;
use std::path::{Path, PathBuf};
use std::process::Command;

fn archx() -> PathBuf {
    PathBuf::from(env!("CARGO_BIN_EXE_archx"))
}

fn has_clang() -> bool {
    if Command::new("clang")
        .arg("--version")
        .output()
        .map(|output| output.status.success())
        .unwrap_or(false)
    {
        return true;
    }
    if cfg!(windows) {
        return Path::new(r"C:\Program Files\LLVM\bin\clang.exe").is_file();
    }
    false
}

fn exe_path(dir: &Path, stem: &str) -> PathBuf {
    let mut p = dir.join(stem);
    if cfg!(windows) {
        p.set_extension("exe");
    }
    p
}

/// Compiles `source` with the freshly built archx binary and returns the
/// program's stdout (with Windows CRLF normalized to LF). Panics if compilation fails.
fn build_and_run(tag: &str, source: &str) -> String {
    let dir = std::env::temp_dir().join(format!("archx-{tag}-{}", std::process::id()));
    fs::create_dir_all(&dir).unwrap();

    let src = dir.join(format!("{tag}.archx.lang"));
    fs::write(&src, source).unwrap();

    let exe = exe_path(&dir, tag);
    let build = Command::new(archx())
        .arg(&src)
        .arg("-o")
        .arg(&exe)
        .output()
        .unwrap();

    assert!(
        build.status.success(),
        "compiler stderr: {}",
        String::from_utf8_lossy(&build.stderr)
    );

    let run = Command::new(&exe).output().unwrap();
    assert!(
        run.status.success(),
        "program failed: {}",
        String::from_utf8_lossy(&run.stderr)
    );
    String::from_utf8_lossy(&run.stdout).replace("\r\n", "\n")
}

#[test]
fn emit_ir_works() {
    let dir = std::env::temp_dir().join(format!("archx-ir-{}", std::process::id()));
    fs::create_dir_all(&dir).unwrap();

    let src = dir.join("hello.archx.lang");
    fs::write(&src, "func main():\n    print(\"Hello, Archx!\")\n").unwrap();

    let output = Command::new(archx())
        .arg(&src)
        .arg("--emit-ir")
        .output()
        .unwrap();

    assert!(
        output.status.success(),
        "stderr: {}",
        String::from_utf8_lossy(&output.stderr)
    );

    let ir = String::from_utf8_lossy(&output.stdout);
    assert!(ir.contains("define i32 @main()"));
    assert!(ir.contains("@printf"));
}

#[test]
fn hello_world_runs() {
    if !has_clang() {
        eprintln!("skipping: clang not found");
        return;
    }

    let out = build_and_run(
        "hello",
        "func main():\n    print(\"Hello, Archx!\")\n    print('single quotes too')\n    let x = 6 * 7\n    print(x)\n",
    );
    assert_eq!(out, "Hello, Archx!\nsingle quotes too\n42\n");
}

#[test]
fn functions_run() {
    if !has_clang() {
        eprintln!("skipping: clang not found");
        return;
    }

    let out = build_and_run(
        "functions",
        "func add(a: int, b: int) -> int:\n    return a + b\n\nfunc main():\n    print(add(40, 2))\n",
    );
    assert_eq!(out, "42\n");
}

#[test]
fn if_else_runs() {
    if !has_clang() {
        eprintln!("skipping: clang not found");
        return;
    }

    let out = build_and_run(
        "if",
        "func sign(n: int) -> int:\n    if n > 0:\n        return 1\n    else:\n        return -1\n\nfunc main():\n    let x = 7\n    if x > 5:\n        print(\"big\")\n    else:\n        print(\"small\")\n    print(sign(5))\n    print(sign(-5))\n    print(true)\n    print(not false)\n    print(1 < 2 and 2 < 3)\n",
    );
    assert_eq!(out, "big\n1\n-1\ntrue\ntrue\ntrue\n");
}

#[test]
fn loops_run() {
    if !has_clang() {
        eprintln!("skipping: clang not found");
        return;
    }

    let out = build_and_run(
        "loops",
        "\
func main():
    let total = 0
    for i in 1..11:
        total = total + i
    print(total)

    let n = 5
    let fact = 1
    while n > 1:
        fact = fact * n
        n = n - 1
    print(fact)

    for i in 0..10:
        if i == 3:
            continue
        if i == 7:
            break
        print(i)

    let pairs = 0
    for i in 0..5:
        for j in 0..5:
            if i + j == 4:
                pairs = pairs + 1
    print(pairs)

    let k = 0
    while true:
        k = k + 1
        if k == 4:
            break
    print(k)

    let m = 0
    while m < 6:
        m = m + 1
        if m == 3:
            continue
        print(m)
",
    );
    assert_eq!(
        out,
        "55\n120\n0\n1\n2\n4\n5\n6\n5\n4\n1\n2\n4\n5\n6\n"
    );
}

#[test]
fn arrays_run() {
    if !has_clang() {
        eprintln!("skipping: clang not found");
        return;
    }

    let out = build_and_run(
        "arrays",
        "\
func build_squares(n: int) -> [int]:
    let out: [int] = []
    for i in 0..n:
        push(out, i * i)
    return out

func sum_slice(xs: [int]) -> int:
    let s = 0
    for i in 0..len(xs):
        s += xs[i]
    return s

func main():
    let sq = build_squares(5)
    print(sq)
    let last = pop(sq)
    print(last)
    print(sum_slice(sq))

    let zeros = [0; 4]
    zeros[2] = 99
    zeros[2] += 1
    print(zeros)

    let flags = [true, false, true]
    print(flags)

    let words = [\"fast\", \"clean\"]
    print(words)

    let grid = [[1, 2], [3, 4]]
    grid[0][1] = 20
    print(grid[0][1] + grid[1][0])
",
    );
    assert_eq!(
        out,
        "[0, 1, 4, 9, 16]\n16\n14\n[0, 0, 100, 0]\n[true, false, true]\n[fast, clean]\n23\n"
    );
}

#[test]
fn elif_and_compound_assign_run() {
    if !has_clang() {
        eprintln!("skipping: clang not found");
        return;
    }

    let out = build_and_run(
        "elif_ops",
        "\
func grade(n: int) -> string:
    if n >= 90:
        return \"A\"
    elif n >= 80:
        return \"B\"
    elif n >= 70:
        return \"C\"
    else:
        return \"D\"

func main():
    let x = 10
    x += 5
    x -= 3
    x *= 4
    x /= 6
    x %= 5
    print(x)
    print(grade(95))
    print(grade(82))
    print(grade(71))
    print(grade(50))
    let s = \"archx\"
    print(s == \"archx\")
    print(s != \"other\")
    print(len(s))
",
    );
    // x: 10 -> 15 -> 12 -> 48 -> 8 -> 3
    assert_eq!(out, "3\nA\nB\nC\nD\ntrue\ntrue\n5\n");
}

#[test]
fn out_of_bounds_panics_cleanly() {
    if !has_clang() {
        eprintln!("skipping: clang not found");
        return;
    }

    let dir = std::env::temp_dir().join(format!("archx-oob-{}", std::process::id()));
    fs::create_dir_all(&dir).unwrap();

    let src = dir.join("oob.archx.lang");
    fs::write(
        &src,
        "func read_at(xs: [int], idx: int) -> int:\n    return xs[idx]\n\nfunc main():\n    let xs = [10, 20, 30]\n    print(read_at(xs, 5))\n",
    )
    .unwrap();

    let exe = exe_path(&dir, "oob");
    let build = Command::new(archx())
        .arg(&src)
        .arg("-o")
        .arg(&exe)
        .output()
        .unwrap();
    assert!(build.status.success());

    let run = Command::new(&exe).output().unwrap();
    assert_eq!(run.status.code(), Some(101));
    let stdout = String::from_utf8_lossy(&run.stdout);
    assert!(
        stdout.contains("index 5 out of bounds for length 3"),
        "stdout was: {stdout}"
    );

    // Also verify versioned multi-array `for` loop still catches short second array
    // at the exact failing index (`2` for length `2`):
    let src2 = dir.join("oob_for.archx.lang");
    fs::write(
        &src2,
        "func step(dst: [int], a: [int], b: [int]):\n    for i in 0..len(dst):\n        dst[i] = a[i] + b[i]\n\nfunc main():\n    let dst = [0; 4]\n    let a = [1; 4]\n    let b = [2; 2]\n    step(dst, a, b)\n",
    )
    .unwrap();
    let exe2 = exe_path(&dir, "oob_for");
    assert!(
        Command::new(archx())
            .arg(&src2)
            .arg("-o")
            .arg(&exe2)
            .output()
            .unwrap()
            .status
            .success()
    );
    let run2 = Command::new(&exe2).output().unwrap();
    assert_eq!(run2.status.code(), Some(101));
    let stdout2 = String::from_utf8_lossy(&run2.stdout);
    assert!(
        stdout2.contains("index 2 out of bounds for length 2"),
        "stdout2 was: {stdout2}"
    );

    // And verify versioned strided `while` loop still catches negative starting index:
    let src3 = dir.join("oob_while.archx.lang");
    fs::write(
        &src3,
        "func bad_sieve(limit: int):\n    let flags = [true; limit]\n    let j = -2\n    while j < limit:\n        flags[j] = false\n        j += 3\n\nfunc main():\n    bad_sieve(10)\n",
    )
    .unwrap();
    let exe3 = exe_path(&dir, "oob_while");
    assert!(
        Command::new(archx())
            .arg(&src3)
            .arg("-o")
            .arg(&exe3)
            .output()
            .unwrap()
            .status
            .success()
    );
    let run3 = Command::new(&exe3).output().unwrap();
    assert_eq!(run3.status.code(), Some(101));
    let stdout3 = String::from_utf8_lossy(&run3.stdout);
    assert!(
        stdout3.contains("index -2 out of bounds for length 10"),
        "stdout3 was: {stdout3}"
    );
}

#[test]
fn break_outside_loop_is_an_error() {
    let dir = std::env::temp_dir().join(format!("archx-brk-{}", std::process::id()));
    fs::create_dir_all(&dir).unwrap();

    let src = dir.join("brk.archx.lang");
    fs::write(&src, "func main():\n    break\n").unwrap();

    let output = Command::new(archx())
        .arg(&src)
        .arg("--emit-ir")
        .output()
        .unwrap();

    assert!(!output.status.success());
    let err = String::from_utf8_lossy(&output.stderr);
    assert!(
        err.contains("only allowed inside a loop"),
        "stderr was: {err}"
    );
}

#[test]
fn cli_enforces_double_extensions_and_prevents_source_clobber() {
    let dir = std::env::temp_dir().join(format!("archx-ext-{}", std::process::id()));
    fs::create_dir_all(&dir).unwrap();

    // Plain `.archx` must be rejected:
    let bad = dir.join("prog.archx");
    fs::write(&bad, "func main():\n    print(1)\n").unwrap();
    let bad_out = Command::new(archx())
        .arg(&bad)
        .arg("--emit-ir")
        .output()
        .unwrap();
    assert!(!bad_out.status.success());
    let bad_err = String::from_utf8_lossy(&bad_out.stderr);
    assert!(
        bad_err.contains(".archx.lang") && bad_err.contains(".ax.lg"),
        "stderr was: {bad_err}"
    );

    // All 4 valid double extensions must work:
    for ext in ["archx.lang", "archx.lg", "ax.lang", "ax.lg"] {
        let p = dir.join(format!("ok.{ext}"));
        fs::write(&p, "func main():\n    print(7)\n").unwrap();
        let res = Command::new(archx())
            .arg(&p)
            .arg("--emit-ir")
            .output()
            .unwrap();
        assert!(
            res.status.success(),
            "extension .{ext} failed: {}",
            String::from_utf8_lossy(&res.stderr)
        );
    }

    // `-o` pointing at input source file must be refused before invoking clang:
    let src = dir.join("keep.archx.lang");
    let orig = "func main():\n    print(42)\n";
    fs::write(&src, orig).unwrap();
    let clobber = Command::new(archx())
        .arg(&src)
        .arg("-o")
        .arg(&src)
        .output()
        .unwrap();
    assert!(!clobber.status.success());
    assert!(
        String::from_utf8_lossy(&clobber.stderr).contains("refusing to overwrite source file")
    );
    assert_eq!(fs::read_to_string(&src).unwrap(), orig);
}

#[test]
fn safe_division_panics_on_zero_and_handles_int_min_neg_one() {
    if !has_clang() {
        eprintln!("skipping: clang not found");
        return;
    }

    // 1. i64::MIN / -1 and i64::MIN % -1 must NOT trap with SIGFPE:
    let out = build_and_run(
        "int_min_div",
        "\
func safe_ops(a: int, b: int) -> int:
    let q = a / b
    let r = a % b
    if q == a and r == 0:
        return 99
    return 0

func main():
    let min_val = -9223372036854775807 - 1
    print(safe_ops(min_val, -1))
",
    );
    assert_eq!(out, "99\n");

    // 2. Runtime division by zero must cleanly exit 101 with diagnostic:
    let dir = std::env::temp_dir().join(format!("archx-divz-{}", std::process::id()));
    fs::create_dir_all(&dir).unwrap();
    let src = dir.join("divz.archx.lang");
    fs::write(
        &src,
        "func divide(a: int, b: int) -> int:\n    return a / b\n\nfunc main():\n    print(divide(10, 0))\n",
    )
    .unwrap();
    let exe = exe_path(&dir, "divz");
    assert!(
        Command::new(archx())
            .arg(&src)
            .arg("-o")
            .arg(&exe)
            .output()
            .unwrap()
            .status
            .success()
    );
    let run = Command::new(&exe).output().unwrap();
    assert_eq!(run.status.code(), Some(101));
    assert!(String::from_utf8_lossy(&run.stdout).contains("division by zero"));
}

#[test]
fn strings_sso_heap_concat_equality_and_embedded_nul_work() {
    if !has_clang() {
        eprintln!("skipping: clang not found");
        return;
    }

    let out = build_and_run(
        "strings_m5",
        "\
func greet(who: string) -> string:
    let msg = \"Hello, \" + who
    msg += \"!\"
    return msg

func main():
    let short_a = \"archx\"
    let short_b = \"ar\" + \"chx\"
    print(short_a == short_b)
    print(len(short_b))

    let g = greet(\"fast-llvm-world\")
    print(g)
    print(len(g))
    print(g == \"Hello, fast-llvm-world!\")
    print(g == \"Hello, other-llvm-world!\")

    let words = [\"alpha\", \"beta-gamma-delta\", g]
    for w in words:
        print(w)

    let nul_s = \"ab\\0cd\"
    print(len(nul_s))
    print(nul_s == \"ab\\0cd\")
    print(nul_s == \"ab\\0ce\")
    print(nul_s)
",
    );
    assert_eq!(
        out,
        "true\n5\nHello, fast-llvm-world!\n23\ntrue\nfalse\nalpha\nbeta-gamma-delta\nHello, fast-llvm-world!\n5\ntrue\nfalse\nab\0cd\n"
    );
}

#[test]
fn structs_value_semantics_aos_and_transparent_soa_work() {
    if !has_clang() {
        eprintln!("skipping: clang not found");
        return;
    }

    let out = build_and_run(
        "structs_m5",
        "\
struct Vec2:
    x: int
    y: int

struct LabeledVec:
    tag: string
    pos: Vec2

func shift(v: Vec2, dx: int, dy: int) -> Vec2:
    return Vec2(v.x + dx, v.y + dy)

func run_soa(n: int) -> int:
    let pts = [Vec2(1, 2); n]
    for i in 0..n:
        pts[i].x += i * 3
        pts[i].y += i
    let sum = 0
    for p in pts:
        sum += p.x + p.y
    return sum

func main():
    let a = Vec2(10, 20)
    let b = a
    b.x += 5
    print(a.x)
    print(b.x)
    let c = shift(b, 1, -4)
    print(c == Vec2(16, 16))

    let lv = LabeledVec(\"origin-plus-more\", c)
    print(lv.tag)
    print(lv.pos.y)

    let arr = [Vec2(1, 1), Vec2(2, 3)]
    arr[1].x += 10
    print(arr[1].x + arr[0].y)

    print(run_soa(100))
",
    );
    // run_soa(100): sum_{i=0..99} ((1 + 3i) + (2 + i)) = 100*3 + 4*(99*100/2) = 300 + 19800 = 20100
    assert_eq!(out, "10\n15\ntrue\norigin-plus-more\n16\n13\n20100\n");
}

#[test]
fn regions_step_loops_foreach_and_ownership_churn_work() {
    if !has_clang() {
        eprintln!("skipping: clang not found");
        return;
    }

    let out = build_and_run(
        "regions_m5",
        "\
func build_summary(rounds: int) -> string:
    let total = 0
    for r in 0..rounds:
        region:
            let scratch = [1; 256]
            for i in 0..256 step 4:
                scratch[i] = r + i
            for v in scratch:
                total += v
            let banner = \"round-\" + \"arena-scratch-string\"
            if len(banner) == 26:
                total += 1
    region:
        let res = \"ok:\" + \"region-promoted-result\"
        if total > 0:
            return res
    return \"bad\"

func main():
    let step_sum = 0
    for k in 1..20 step 3:
        step_sum += k
    print(step_sum)

    # Churn reassignments & nested containers to exercise deterministic drops:
    let acc = \"seed\"
    let mat = [[1, 2], [3, 4]]
    for iter in 0..500:
        acc = \"iteration-long-string-value\"
        mat = [[iter, iter + 1], [iter + 2, iter + 3]]
        let _discard = [10, 20, 30, 40]
    print(len(acc))
    print(mat[1][1])
    print(build_summary(200))
",
    );
    // 1 + 4 + 7 + 10 + 13 + 16 + 19 = 70
    // iter=499 -> mat[1][1] = 502
    assert_eq!(out, "70\n27\n502\nok:region-promoted-result\n");
}

#[test]
fn run_flag_default_output_and_str_alias_work() {
    if !has_clang() {
        eprintln!("skipping: clang not found");
        return;
    }

    let dir = std::env::temp_dir().join(format!("archx-runflag-{}", std::process::id()));
    fs::create_dir_all(&dir).unwrap();

    let src = dir.join("echo_str.ax.lg");
    fs::write(
        &src,
        "func tag(s: str) -> str:\n    return \"[\" + s + \"]\"\n\nfunc main():\n    print(tag(\"ok\"))\n",
    )
    .unwrap();

    let out = Command::new(archx())
        .current_dir(&dir)
        .arg(&src)
        .arg("--run")
        .output()
        .unwrap();
    assert!(
        out.status.success(),
        "stderr: {}",
        String::from_utf8_lossy(&out.stderr)
    );
    assert_eq!(
        String::from_utf8_lossy(&out.stdout).replace("\r\n", "\n"),
        "[ok]\n"
    );
}

