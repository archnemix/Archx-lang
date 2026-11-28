//! End-to-end CLI integration tests exercising compilation, execution, runtime panics, and CLI flags
//! across Linux, macOS, and Windows.

use std::fs;
use std::io::Write;
use std::path::{Path, PathBuf};
use std::process::{Command, Stdio};

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

/// The dialect directive that a 1:1 Python edition must carry on line 1.
const COMPAT_DIRECTIVE: &str = "# archx: dialect=compat, version=1";

/// Returns the body of a 1:1 Archx source below its dialect directive.
///
/// `None` when the file does not start with the expected compat directive, which is itself a
/// failure the caller should report. Line endings are normalised first: the 1:1 editions are
/// checked out with CRLF on Windows, and the invariant is about *source text*, not about the host's
/// newline convention.
fn one_to_one_body(source: &str) -> Option<String> {
    let normalised = source.replace("\r\n", "\n");
    normalised
        .strip_prefix(COMPAT_DIRECTIVE)
        .map(|rest| rest.trim_start_matches('\n').to_string())
}

/// Whether the linker genuinely implements GNU `--wrap`.
///
/// The leak harness depends on it, and only Linux reliably provides it (GNU ld and lld both do).
/// The other platforms fail in ways that would be easy to mistake for "no leaks":
///
/// * macOS `ld64`: rejects the flags outright (`ld: unknown options: --wrap=malloc …`).
/// * Windows MSVC `link.exe`: accepts them from the driver but performs no wrapping, so the harness
///   ends up with unresolved `__real_malloc` (LNK1120).
///
/// Skipping is the honest choice: a harness that cannot observe allocations must not report
/// success. The leak *evidence* for this project is therefore Linux-only, which is stated in
/// `docs/V1_Tracker.md` rather than implied to be cross-platform.
fn linker_supports_wrap() -> bool {
    cfg!(target_os = "linux")
}

/// Native-dialect header for inline test sources.
///
/// Every module must declare its dialect (AX-013), so the tests state the contract they are written
/// against instead of relying on a compiler default. Sources that already carry a directive are
/// left alone, which is how a test can opt into `compat`.
fn with_native_directive(source: &str) -> String {
    if source.trim_start().starts_with("# archx:") {
        source.to_string()
    } else {
        format!("# archx: dialect=native, version=1\n{source}")
    }
}

/// Compiles `source` with the freshly built archx binary and returns the
/// program's stdout (with Windows CRLF normalized to LF). Panics if compilation fails.
fn build_and_run(tag: &str, source: &str) -> String {
    let dir = std::env::temp_dir().join(format!("archx-{tag}-{}", std::process::id()));
    fs::create_dir_all(&dir).unwrap();

    let src = dir.join(format!("{tag}.archx.lang"));
    fs::write(&src, with_native_directive(source)).unwrap();

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
    if !run.status.success() {
        let mut asan_report = String::new();
        if cfg!(target_os = "linux") {
            let ir_out = Command::new(archx()).arg(&src).arg("--emit-ir").output().unwrap();
            let ll_path = dir.join(format!("{tag}_asan.ll"));
            let asan_exe = dir.join(format!("{tag}_asan"));
            let _ = fs::write(&ll_path, &ir_out.stdout);
            if let Ok(st) = Command::new("clang")
                .args([
                    "-O1",
                    "-g",
                    "-fsanitize=address",
                    "-fno-omit-frame-pointer",
                    "-Wno-override-module",
                ])
                .arg(&ll_path)
                .arg("-lm")
                .arg("-o")
                .arg(&asan_exe)
                .status()
            {
                if st.success() {
                    if let Ok(ar) = Command::new(&asan_exe).output() {
                        asan_report = format!(
                            "\n--- ASan stdout ---\n{}\n--- ASan stderr ---\n{}",
                            String::from_utf8_lossy(&ar.stdout),
                            String::from_utf8_lossy(&ar.stderr)
                        );
                    }
                }
            }
        }
        panic!(
            "program failed (status={:?}):\nstdout: {}\nstderr: {}{}",
            run.status,
            String::from_utf8_lossy(&run.stdout),
            String::from_utf8_lossy(&run.stderr),
            asan_report
        );
    }
    String::from_utf8_lossy(&run.stdout).replace("\r\n", "\n")
}

#[test]
fn emit_ir_works() {
    let dir = std::env::temp_dir().join(format!("archx-ir-{}", std::process::id()));
    fs::create_dir_all(&dir).unwrap();

    let src = dir.join("hello.archx.lang");
    fs::write(&src, with_native_directive("func main():\n    print(\"Hello, Archx!\")\n")).unwrap();

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
        with_native_directive("func read_at(xs: [int], idx: int) -> int:\n    return xs[idx]\n\nfunc main():\n    let xs = [10, 20, 30]\n    print(read_at(xs, 5))\n"),
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
        with_native_directive("func step(dst: [int], a: [int], b: [int]):\n    for i in 0..len(dst):\n        dst[i] = a[i] + b[i]\n\nfunc main():\n    let dst = [0; 4]\n    let a = [1; 4]\n    let b = [2; 2]\n    step(dst, a, b)\n"),
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
        with_native_directive("func bad_sieve(limit: int):\n    let flags = [true; limit]\n    let j = -2\n    while j < limit:\n        flags[j] = false\n        j += 3\n\nfunc main():\n    bad_sieve(10)\n"),
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
    fs::write(&src, with_native_directive("func main():\n    break\n")).unwrap();

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
    fs::write(&bad, with_native_directive("func main():\n    print(1)\n")).unwrap();
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
        fs::write(&p, with_native_directive("func main():\n    print(7)\n")).unwrap();
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
    let orig = with_native_directive("func main():\n    print(42)\n");
    fs::write(&src, &orig).unwrap();
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
    let q = a // b
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
        with_native_directive("func divide(a: int, b: int) -> int:\n    return a // b\n\nfunc main():\n    print(divide(10, 0))\n"),
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
        with_native_directive("func tag(s: str) -> str:\n    return \"[\" + s + \"]\"\n\nfunc main():\n    print(tag(\"ok\"))\n"),
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

#[test]
fn pythonic_syntax_loops_classes_floats_fstrings_and_methods() {
    if !has_clang() {
        eprintln!("skipping: clang not found");
        return;
    }

    let out = build_and_run(
        "pythonic_v06",
        "\
class Counter:
    val: int
    step: int

    def inc(self, times: int) -> None:
        self.val += self.step * times

    def describe(self, tag: str) -> str:
        return f\"{tag}={self.val}\"

def check_all() -> None:
    c = Counter(step=3, val=10)
    c.inc(2)
    print(c.describe(\"ctr\"))

    rsum = 0
    for k in range(10, 0, -3):
        rsum += k
    neg_step = -2
    dsum = 0
    for k in range(6, 0, neg_step):
        dsum += k
    print(rsum, dsum)

    xs: list[int] = []
    xs.append(10)
    xs.append(20)
    xs.append(30)
    popped = xs.pop()
    ys = xs + [40]
    esum = 0
    for idx, v in enumerate(ys, 1):
        esum += idx * v
    xs.clear()
    assert popped == 30 and len(xs) == 0 and 20 in ys and 99 not in ys
    print(esum)

    s = \"  AbC--DeF  \".strip()
    assert s.lower() == \"abc--def\" and s.upper() == \"ABC--DEF\"
    assert s.startswith(\"AbC\") and s.endswith(\"DeF\") and \"--\" in s and \"zz\" not in s
    parts = \"alpha,beta,gamma\".split(\",\")
    chars = 0
    for ch in \"hi!\":
        chars += ord(ch)
    print(s.find(\"--\"), s.replace(\"--\", \":\"), parts[1], chars, chr(65) * 3)

    with region:
        tmp = [1] * 8
        assert len(tmp) == 8
        pass

    print(-7 // 2, 2 ** 10, 2.0 ** 3.0, sqrt(2.25))
    print(int(\"  -42\\n\") + int(float(\" 3.9 \")), sum([1, 2, 3, 4]), min(9, 4, 7), max([2, 8, 5]), abs(-12))
    print(\"A\", 2.0, None, sep=\"|\", end=\"!\\n\")
    print()

if __name__ == \"__main__\":
    check_all()
    label = \"yes\" if bool(\"x\") and not bool(\"\") else \"no\"
    print(f\"{{done}} {label}\")
",
    );

    assert_eq!(
        out,
        "\
ctr=16
22 12
170
3 AbC:DeF beta 242 AAA
-4 1024 8.0 1.5
-39 10 4 8 12
A|2.0|None!

{done} yes
"
    );
}

#[test]
fn pythonic_stdin_input_with_prompt_and_piped_lines() {
    if !has_clang() {
        eprintln!("skipping: clang not found");
        return;
    }

    let dir = std::env::temp_dir().join(format!("archx-stdin-{}", std::process::id()));
    fs::create_dir_all(&dir).unwrap();

    let src = dir.join("stdin_io.archx.lang");
    let program = with_native_directive(
        "\
name = input(\"Name? \")
n = int(input())
nums = input().split()
total = 0
for i in range(n):
    total += int(nums[i])
scale = float(input())
long_line = input()
eof_line = input()
print(f\"hi {name}: {float(total) * scale} len={len(long_line)} eof={len(eof_line)}\")
",
    );
    fs::write(&src, program).unwrap();

    let exe = exe_path(&dir, "stdin_io");
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

    let mut child = Command::new(&exe)
        .stdin(Stdio::piped())
        .stdout(Stdio::piped())
        .stderr(Stdio::piped())
        .spawn()
        .unwrap();

    {
        let mut stdin = child.stdin.take().unwrap();
        let payload = format!("Alice\r\n3\n10 20 30\n2.5\n{}\n", "x".repeat(120));
        stdin.write_all(payload.as_bytes()).unwrap();
    }

    let out = child.wait_with_output().unwrap();
    assert!(
        out.status.success(),
        "binary stderr: {}",
        String::from_utf8_lossy(&out.stderr)
    );
    assert_eq!(
        String::from_utf8_lossy(&out.stdout).replace("\r\n", "\n"),
        "Name? hi Alice: 150.0 len=120 eof=0\n"
    );
}

#[test]
fn pythonic_assert_and_zero_step_panic_cleanly() {
    if !has_clang() {
        eprintln!("skipping: clang not found");
        return;
    }

    let dir = std::env::temp_dir().join(format!("archx-pypanic-{}", std::process::id()));
    fs::create_dir_all(&dir).unwrap();

    // 1. Failed assertion with message exits 101 and prints message:
    let src_assert = dir.join("fail_assert.archx.lang");
    fs::write(&src_assert, with_native_directive("x = 5\nassert x == 9, \"expected nine\"\n")).unwrap();
    let exe_assert = exe_path(&dir, "fail_assert");
    assert!(Command::new(archx()).arg(&src_assert).arg("-o").arg(&exe_assert).status().unwrap().success());
    let run_assert = Command::new(&exe_assert).output().unwrap();
    assert_eq!(run_assert.status.code(), Some(101));
    let combined = format!(
        "{}{}",
        String::from_utf8_lossy(&run_assert.stdout),
        String::from_utf8_lossy(&run_assert.stderr)
    );
    assert!(combined.contains("AssertionError") && combined.contains("expected nine"), "got: {combined}");

    // 2. Dynamic zero step in `range()` exits 101:
    let src_step = dir.join("zero_step.archx.lang");
    fs::write(
        &src_step,
        with_native_directive("def bad(s: int):\n    for i in range(0, 10, s):\n        print(i)\nbad(0)\n"),
    )
    .unwrap();
    let exe_step = exe_path(&dir, "zero_step");
    assert!(Command::new(archx()).arg(&src_step).arg("-o").arg(&exe_step).status().unwrap().success());
    let run_step = Command::new(&exe_step).output().unwrap();
    assert_eq!(run_step.status.code(), Some(101));
}

#[test]
fn planar_simd_dict_set_and_slicing_work() {
    if !has_clang() {
        eprintln!("skipping: clang not found");
        return;
    }

    let out = build_and_run(
        "dict_set_slice_v07",
        "\
def build_region_dict() -> dict[str, int]:
    with region:
        tmp = {\"alpha\": 10, \"beta\": 20, \"gamma\": 30}
        tmp[\"beta\"] += 5
        popped = tmp.pop(\"alpha\")
        tmp[\"delta\"] = popped + 2
        return tmp

scores = {}
for i in range(50):
    scores[f\"k{i}\"] = i * 3
scores[\"k10\"] += 7
print(len(scores), scores[\"k10\"], \"k49\" in scores, \"k99\" not in scores)
print(scores.get(\"k0\", -1), scores.get(\"missing\", -99))

removed = scores.pop(\"k0\")
print(removed, len(scores))

# Deterministic insertion-order iteration even after tombstone deletion:
small = {\"first\": 1, \"second\": 2, \"third\": 3}
_ = small.pop(\"second\")
small[\"fourth\"] = 4
acc_k = \"\"
acc_v = 0
for k, v in small.items():
    acc_k = acc_k + k + \",\"
    acc_v += v
print(acc_k, acc_v)

# Planar SIMD set deduplication & operations:
uniq = set([5, 3, 5, 1, 3, 9, 1])
uniq.add(7)
uniq.discard(999)
uniq.remove(3)
sum_u = 0
for x in uniq:
    sum_u += x
print(len(uniq), 5 in uniq, 3 in uniq, sum_u)

rd = build_region_dict()
print(rd[\"beta\"], rd[\"delta\"], len(rd))

# Pythonic slicing & negative indexing on lists and strings:
nums = [10, 20, 30, 40, 50, 60]
nums[-1] = 66
print(nums[-1], nums[-2])
print(nums[1:4])
print(nums[:3])
print(nums[4:])
print(nums[::-2])

s = \"Archx-v0.7\"
print(s[0:5], s[-4:], s[::-1])
",
    );

    assert_eq!(
        out,
        "\
50 37 true true
0 -99
0 49
first,third,fourth, 8
4 true false 22
25 12 3
66 50
[20, 30, 40]
[10, 20, 30]
[50, 66]
[66, 40, 20]
Archx v0.7 7.0v-xhcrA
"
    );
}

#[test]
fn adaptive_any_mixed_containers_and_dynamic_rebinding_work() {
    if !has_clang() {
        eprintln!("skipping: clang not found");
        return;
    }

    let out = build_and_run(
        "adaptive_any_v07",
        "\
def describe(val):
    if val is None:
        return \"nothing\"
    elif isinstance(val, int):
        return f\"int:{val * 2}\"
    elif isinstance(val, str):
        return f\"str:{val.upper()}\"
    elif isinstance(val, list):
        return f\"list:{len(val)}\"
    return f\"other:{type(val)}\"

def maybe_double(flag, n):
    if flag:
        return n + n

# 1. Mixed-type dict & nested heterogeneous list (exact user showcase):
hello = {\"data\": [\"Archx\", 18, \"legal\"], \"age\": 18}
hello[\"data\"].append(\"fast\")
hello[\"age\"] += 3
hello[\"ok\"] = True
print(hello[\"data\"][0], hello[\"data\"][1], hello[\"data\"][-1])
print(hello[\"age\"], hello[\"ok\"], len(hello[\"data\"]))

# 2. Dynamic variable type rebinding (`str` -> `int` -> `list` -> `None`):
name = \"Abdullah\"
p1 = f\"{name}:{type(name)}\"
name = 18
p2 = f\"{name + 2}:{type(name)}\"
name = [\"x\", 42]
p3 = f\"{name[0]}-{name[1]}:{type(name)}\"
name = None
p4 = f\"{name}:{type(name)}:{name is None}\"
print(p1, p2, p3, p4)

# 3. Untyped Python `def`, `isinstance`, and implicit `None` return:
print(describe(\"archx\"), describe(21), describe(hello[\"data\"]), describe(None))
print(maybe_double(True, \"go\"), maybe_double(False, \"go\"))
",
    );

    assert_eq!(
        out,
        "\
Archx 18 fast
21 true 4
Abdullah:str 20:int x-42:list None:NoneType:true
str:ARCHX int:42 list:4 nothing
gogo None
"
    );
}

#[test]
fn dict_key_error_and_dynamic_type_error_panic_cleanly() {
    if !has_clang() {
        eprintln!("skipping: clang not found");
        return;
    }

    let dir = std::env::temp_dir().join(format!("archx-v07panic-{}", std::process::id()));
    fs::create_dir_all(&dir).unwrap();

    // 1. Missing dictionary key raises KeyError with exit code 101:
    let src_key = dir.join("key_err.archx.lang");
    fs::write(&src_key, with_native_directive("d = {\"a\": 1}\nprint(d[\"missing\"])\n")).unwrap();
    let exe_key = exe_path(&dir, "key_err");
    assert!(Command::new(archx()).arg(&src_key).arg("-o").arg(&exe_key).status().unwrap().success());
    let run_key = Command::new(&exe_key).output().unwrap();
    assert_eq!(run_key.status.code(), Some(101));
    let out_key = format!(
        "{}{}",
        String::from_utf8_lossy(&run_key.stdout),
        String::from_utf8_lossy(&run_key.stderr)
    );
    assert!(out_key.contains("KeyError"), "expected KeyError, got: {out_key}");

    // 2. Incompatible runtime operation on rebound `any` raises TypeError with exit code 101:
    let src_ty = dir.join("type_err.archx.lang");
    fs::write(&src_ty, with_native_directive("x = \"Abdullah\"\nif False:\n    x = 18\nprint(x - 5)\n")).unwrap();
    let exe_ty = exe_path(&dir, "type_err");
    assert!(Command::new(archx()).arg(&src_ty).arg("-o").arg(&exe_ty).status().unwrap().success());
    let run_ty = Command::new(&exe_ty).output().unwrap();
    assert_eq!(run_ty.status.code(), Some(101));
    let out_ty = format!(
        "{}{}",
        String::from_utf8_lossy(&run_ty.stdout),
        String::from_utf8_lossy(&run_ty.stderr)
    );
    assert!(out_ty.contains("TypeError"), "expected TypeError, got: {out_ty}");
}

#[test]
fn tuples_optionals_enums_and_pattern_matching_work() {
    if !has_clang() {
        eprintln!("skipping: clang not found");
        return;
    }

    let out = build_and_run(
        "v08_showcase",
        "\
enum ExprNode:
    Const(int)
    Pair(int, int)
    Named(str)
    Nil

def eval_node(n: ExprNode) -> int:
    match n:
        case ExprNode.Const(v) if v < 0:
            return -v
        case ExprNode.Const(v):
            return v
        case ExprNode.Pair(a, b):
            return a * 10 + b
        case ExprNode.Named(s):
            return len(s)
        case ExprNode.Nil:
            return 0

def make_promoted_enum() -> ExprNode:
    with region:
        label = \"region_promoted_enum_payload_string\"
        return ExprNode.Named(label)

def lookup_even(xs: list[int]) -> (int, int) | None:
    for i, x in enumerate(xs):
        if x % 2 == 0:
            return i, x

def guard_unwrap(opt: int | None) -> int:
    if opt is None:
        return -99
    return opt + 5

def main():
    # 1. Tuples, unpacking, swap, negative indexing, list-of-tuples iteration:
    x, y = 7, 13
    x, y = y, x
    tup = (\"archx\", 8, True)
    pairs = [(\"a\", 2), (\"b\", 5), (\"c\", 9)]
    psum = 0
    for k, v in pairs:
        psum += len(k) * v
    print(f\"{x},{y} {tup[0]}:{tup[-1]} {psum}\")

    # 2. T | None optionals, narrowing, ternary promotion, and match unwrapping:
    r1 = lookup_even([3, 9, 14, 21])
    r2 = lookup_even([1, 3, 5])
    if r1 is not None:
        idx, val = r1
        print(f\"even={idx}:{val}\")
    match r2:
        case None:
            print(\"none_ok\")
        case (i, v):
            print(f\"bad:{i}:{v}\")
    m_some: int | None = 40
    match m_some:
        case None:
            print(\"bad\")
        case 0:
            print(\"zero\")
        case n:
            print(f\"unwrapped={n + 2} g={guard_unwrap(m_some)},{guard_unwrap(None)}\")

    # 3. Algebraic enums, OR-patterns, guards, and region-return promotion:
    promoted = make_promoted_enum()
    nodes = [ExprNode.Const(-6), ExprNode.Pair(3, 4), promoted, ExprNode.Nil]
    scores: list[int] = []
    for nd in nodes:
        scores.append(eval_node(nd))
    tag_acc = 0
    for code in [1, 2, 3, 9]:
        match code:
            case 1 | 2:
                tag_acc += 10
            case 3 if len(scores) == 4:
                tag_acc += 100
            case _:
                tag_acc += 1
    print(scores, tag_acc)
",
    );

    assert_eq!(
        out,
        "\
13,7 archx:true 16
even=2:14
none_ok
unwrapped=42 g=45,-99
[6, 34, 35, 0] 121
"
    );
}

/// AX-013 regression, found by CI on Windows: the 1:1 editions are checked out with CRLF there, so
/// comparing raw text failed even though the sources were unchanged. The helper normalises first,
/// and it must still reject a file with no directive or the wrong one.
#[test]
fn one_to_one_body_normalises_line_endings_and_requires_the_directive() {
    let lf = "# archx: dialect=compat, version=1\nA = 1\n";
    assert_eq!(one_to_one_body(lf).as_deref(), Some("A = 1\n"));

    let crlf = "# archx: dialect=compat, version=1\r\nA = 1\r\n";
    assert_eq!(
        one_to_one_body(crlf).as_deref(),
        Some("A = 1\n"),
        "a CRLF checkout must yield the same body as an LF one"
    );

    assert!(one_to_one_body("A = 1\n").is_none(), "a missing directive is not a body");
    assert!(
        one_to_one_body("# archx: dialect=native, version=1\nA = 1\n").is_none(),
        "a 1:1 edition must be compat, not native"
    );
}

#[test]
fn full_tour_pythonic_and_speed_editions_match_exactly() {
    if !has_clang() {
        eprintln!("skipping: clang not found");
        return;
    }

    let root = std::path::PathBuf::from(env!("CARGO_MANIFEST_DIR"));
    let py_src = fs::read_to_string(root.join("examples/comparison/full_tour.py")).unwrap();
    let ax_py_src =
        fs::read_to_string(root.join("examples/comparison/full_tour_pythonic.archx.lang")).unwrap();
    // The Archx edition carries the mandatory dialect directive on line 1; the rest of the file must
    // stay byte-for-byte identical to the Python reference, which is the point of the 1:1 edition.
    let ax_body = one_to_one_body(&ax_py_src).unwrap_or_else(|| {
        panic!("full_tour_pythonic.archx.lang must start with `{COMPAT_DIRECTIVE}`")
    });
    assert_eq!(
        py_src.replace("\r\n", "\n"),
        ax_body,
        "full_tour.py and full_tour_pythonic.archx.lang must stay 1:1 identical below the directive"
    );

    let ax_spd_src =
        fs::read_to_string(root.join("examples/comparison/full_tour_speed.archx.lang")).unwrap();

    let out_py = build_and_run("full_tour_py", &ax_py_src);
    let out_spd = build_and_run("full_tour_spd", &ax_spd_src);

    let expected = "\
sim=7684989
dict_slice=2307705,nohtyp_smetsys_xhcra
tuple_opt=8,104,3543,10099,empty
match_dispatch=33780000
pipeline=2665359250
";
    assert_eq!(out_py, expected, "1:1 Pythonic edition output mismatch");
    assert_eq!(out_spd, expected, "Speed edition output mismatch");
}

#[test]
fn comprehensions_generators_zip_and_inline_sort_work() {
    if !has_clang() {
        eprintln!("skipping: clang not found");
        return;
    }

    let out = build_and_run(
        "v9_features",
        r#"squares = [x * x for x in range(10)]
print(squares)
print([x for x in range(20) if x % 3 == 0])
print([[r * c for c in range(3)] for r in range(3)])
print({x * 2 for x in range(5)})
print({k: k * k for k in range(4)})

print(sum(x for x in range(101)))
print(any(x > 9 for x in range(10)))
print(all(x < 10 for x in range(10)))
print(len(x for x in range(7)))
print(min(x for x in range(3, 9)))
print(max(x for x in range(5)))

for a, b in zip([1, 2, 3], [4, 5, 6]):
    print(a + b)
print(zip([1, 2], [3, 4]))

xs = [5, 3, 9, 1, 7, 2, 8, 4, 6, 0]
print(sorted(xs))
print(sorted(xs, reverse=True))
xs.sort()
print(xs)
ys = [5, 3, 9, 1]
ys.sort(reverse=True)
print(ys)

words = ["pear", "apple", "fig", "banana", "a"]
print(sorted(words))
print(sorted(words, key=lambda w: len(w)))
print(sorted(words, key=lambda w: len(w), reverse=True))
nums = [5, 1, 4, 2]
print(sorted(nums, key=lambda v: -v))
print(sorted([3.5, -1.25, 2.0, 0.5]))
big = [i for i in range(40)]
print(sorted(big, reverse=True))
"#,
    );

    assert_eq!(
        out,
        "\
[0, 1, 4, 9, 16, 25, 36, 49, 64, 81]
[0, 3, 6, 9, 12, 15, 18]
[[0, 0, 0], [0, 1, 2], [0, 2, 4]]
{0, 2, 4, 6, 8}
{0: 0, 1: 1, 2: 4, 3: 9}
5050
false
true
7
3
4
5
7
9
[(1, 3), (2, 4)]
[0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
[9, 8, 7, 6, 5, 4, 3, 2, 1, 0]
[0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
[9, 5, 3, 1]
[a, apple, banana, fig, pear]
[a, fig, pear, apple, banana]
[banana, apple, pear, fig, a]
[5, 4, 2, 1]
[-1.25, 0.5, 2.0, 3.5]
[39, 38, 37, 36, 35, 34, 33, 32, 31, 30, 29, 28, 27, 26, 25, 24, 23, 22, 21, 20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0]
"
    );
}

#[test]
fn pep695_generics_and_inline_lambdas_are_monomorphized() {
    if !has_clang() {
        eprintln!("skipping: clang not found");
        return;
    }

    let out = build_and_run(
        "v9_generics",
        r#"def add[T](a: T, b: T) -> T:
    return a + b


def total[T](xs: list[T]) -> int:
    t = 0
    for x in xs:
        t += x
    return t


class Box[T]:
    def __init__(self, value: T):
        self.value = value

    def get(self) -> T:
        return self.value


print(add(3, 4))
print(add(1.5, 2.5))
print(add("a", "b"))
print(add[int](7, 8))
print(total([1, 2, 3]))
print(total[int]([4, 5]))

b = Box[int](41)
print(b.get() + 1)
s = Box[str]("hi")
print(s.get())

double = lambda x: x * 2
print(double(21))
bump = 10
add_bump = lambda x: x + bump
print(add_bump(5))
print(sorted([5, 1, 4, 2], key=lambda v: -v))
"#,
    );

    assert_eq!(
        out,
        "7\n4.0\nab\n15\n6\n9\n42\nhi\n42\n15\n[5, 4, 2, 1]\n"
    );
}

#[test]
fn comprehension_and_sorting_example_matches_expected_output() {
    if !has_clang() {
        eprintln!("skipping: clang not found");
        return;
    }

    let out = build_and_run(
        "v9_example_comprehensions",
        r#"def add[T](a: T, b: T) -> T:
    return a + b


class Box[T]:
    def __init__(self, value: T):
        self.value = value

    def get(self) -> T:
        return self.value


def show(words: list[str]):
    line = ""
    for i, w in enumerate(words):
        if i > 0:
            line += ", "
        line += "'" + w + "'"
    print("[" + line + "]")


def main():
    squares = [x * x for x in range(10)]
    print(squares)
    print([x for x in squares if x % 2 == 0])
    print([[r * c for c in range(3)] for r in range(2)])
    print(sum_of_squares(101))
    print(sum(x for x in range(1000) if x % 3 == 0))
    print(max(x * 2 for x in range(50)))
    print(any(x > 99 for x in range(100)))
    print(all(x >= 0 for x in range(100)))
    print(add(3, 4))
    print(add("a", "b"))
    print(add[int](7, 8))
    b = Box[int](41)
    print(b.get() + 1)
    double = lambda x: x * 2
    print(double(21))
    bump = 10
    add_bump = lambda x: x + bump
    print(add_bump(5))
    print(list(zip([1, 2], [3, 4])))
    nums = [5, 3, 9, 1, 7, 2, 8, 4, 6, 0]
    print(sorted(nums))
    print(sorted(nums, reverse=True))
    print(sorted(nums, key=lambda v: -v))
    words = ["pear", "apple", "fig", "banana", "a", "cherry"]
    show(sorted(words))
    show(sorted(words, key=lambda w: len(w)))
    show(sorted(words, key=lambda w: len(w), reverse=True))
    nums.sort()
    print(nums)
    nums.sort(reverse=True)
    print(nums)


def sum_of_squares(n: int) -> int:
    return sum(x * x for x in range(n))


if __name__ == "__main__":
    main()
"#,
    );

    assert_eq!(
        out,
        "[0, 1, 4, 9, 16, 25, 36, 49, 64, 81]\n\
         [0, 4, 16, 36, 64]\n\
         [[0, 0, 0], [0, 1, 2]]\n\
         338350\n\
         166833\n\
         98\n\
         false\n\
         true\n\
         7\n\
         ab\n\
         15\n\
         42\n\
         42\n\
         15\n\
         [(1, 3), (2, 4)]\n\
         [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]\n\
         [9, 8, 7, 6, 5, 4, 3, 2, 1, 0]\n\
         [9, 8, 7, 6, 5, 4, 3, 2, 1, 0]\n\
         ['a', 'apple', 'banana', 'cherry', 'fig', 'pear']\n\
         ['a', 'fig', 'pear', 'apple', 'banana', 'cherry']\n\
         ['banana', 'cherry', 'apple', 'pear', 'fig', 'a']\n\
         [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]\n\
         [9, 8, 7, 6, 5, 4, 3, 2, 1, 0]\n"
    );
}

/// Regression: the insertion-sort scan used to fetch `base[j - 1]` *before* testing `j == lo`.
/// `base[j - 1]` is then an `inbounds` gep one element before the run, i.e. poison, and clang
/// -O1/-O2 miscompiled the whole function (`free(): invalid pointer`, corrupt output). The
/// short-circuit must come first; this test exercises every run length around the 16-element
/// insertion/merge boundary.
#[test]
fn inline_sort_is_ub_free_across_run_lengths_and_keeps_stability() {
    if !has_clang() {
        eprintln!("skipping: clang not found");
        return;
    }

    let src = r#"def main():
    for n in range(0, 70):
        raw = [0] * n
        for i in range(n):
            raw[i] = (i * 37 + 11) % 101
        asc = sorted(raw)
        desc = sorted(raw, reverse=True)
        keyed = sorted(raw, key=lambda v: -v)
        inplace = [x for x in raw]
        inplace.sort()
        ok = 1
        for i in range(n):
            if asc[i] != inplace[i]:
                ok = 0
            if i > 0 and asc[i - 1] > asc[i]:
                ok = 0
            if i > 0 and desc[i - 1] < desc[i]:
                ok = 0
            if keyed[i] != desc[i]:
                ok = 0
        if ok == 0:
            print(f"FAIL n={n}")
            return
    print("all sizes ok")
    print(sorted([5, 3, 9, 1, 7, 2, 8, 4, 6, 0]))
    print(sorted([9, 1, 8, 2, 7, 3, 6, 4, 5], reverse=True))
main()
"#;

    let out = build_and_run("v9_sort_ub_free", src);
    assert_eq!(
        out,
        "all sizes ok\n[0, 1, 2, 3, 4, 5, 6, 7, 8, 9]\n[9, 8, 7, 6, 5, 4, 3, 2, 1]\n"
    );
}

/// Math semantics that CPython defines and that are easy to get subtly wrong: floored `%`,
/// `int ** negative` returning a float, `round()`'s round-half-to-even, and `hex/oct/bin`
/// sign placement.
#[test]
fn pythonic_int_float_semantics_match_cpython() {
    if !has_clang() {
        eprintln!("skipping: clang not found");
        return;
    }

    let src = r#"def main():
    print(7 % 3, -7 % 3, 7 % -3, -7 % -3)
    print(-7 // 2, 7 // -2)
    print(2 ** 10, 2 ** 0, 2 ** -2)
    print(round(2.5), round(3.5), round(-2.5), round(2.567, 2))
    print(hex(255), oct(8), bin(5), hex(-255), bin(0))
    print(divmod(7, 3), divmod(-7, 3))
    print('a' < 'b', 'Z' < 'a', 'ab' < 'abc', 'abc' == 'abc')
main()
"#;

    let out = build_and_run("v10_int_float_semantics", src);
    assert_eq!(
        out,
        "1 2 -2 -1\n-4 -4\n1024 1 0.25\n2 4 -2 2.57\n0xff 0o10 0b101 -0xff 0b0\n(2, 1) (-3, 2)\ntrue true true true\n"
    );
}

/// The coll/str additions from Milestone 10: list mutation, `str.join`, bitwise operators,
/// docstrings, triple-quoted strings and `;`-separated statements.
#[test]
fn pythonic_list_mutation_join_bitwise_and_docstrings() {
    if !has_clang() {
        eprintln!("skipping: clang not found");
        return;
    }

    let src = r#"def main():
    """Module docstring."""
    xs = [1, 2, 3]
    xs.reverse(); xs.extend([4, 5])
    xs.insert(0, 0)
    xs.remove(4)
    print(xs, xs.index(3), xs.count(4))
    ys = [1]
    ys.clear()
    print(len(ys))
    print('-'.join(['a', 'b', 'c']))
    print(' '.join([]))
    print(12 & 10, 12 | 10, 12 ^ 10, 1 << 4, 64 >> 2, ~5)
    print('x' * 3, len("""multi
line"""))
main()
"#;

    let out = build_and_run("v10_list_join_bitwise", src);
    assert_eq!(
        out,
        "[0, 3, 2, 1, 5] 1 0\n0\na-b-c\n\n8 14 6 16 16 -6\nxxx 10\n"
    );
}

/// String formatting and set algebra — the parts of Python that a program hits immediately but
/// that need real runtime support (format specs, set union/intersection).
#[test]
fn pythonic_formatting_and_set_algebra_match_cpython() {
    if !has_clang() {
        eprintln!("skipping: clang not found");
        return;
    }

    let src = r#"def main():
    a = {1, 2, 3, 4}
    b = {3, 4, 5, 6}
    print(sorted(list(a | b)))
    print(sorted(list(a & b)))
    print(sorted(list(a - b)))
    print(sorted(list(a ^ b)))
    p = 3.14159
    print(f"{p:.2f} {p:10.2f}| {42:05d}")
    print("{}-{} {:.3f} {{}}".format(1, 'two', p))
    print("%d items, %.1f%%" % (5, 12.5))
    x = 5
    print(1 < x < 10, 1 < x < 3)
main()
"#;

    let out = build_and_run("v10_format_and_sets", src);
    assert_eq!(
        out,
        "[1, 2, 3, 4, 5, 6]\n[3, 4]\n[1, 2]\n[1, 2, 5, 6]\n\
         3.14       3.14| 00042\n\
         1-two 3.142 {}\n\
         5 items, 12.5%\n\
         true false\n"
    );
}

/// v0.9.1 — default parameters, `for ... else`, Python loop-variable scope, keyword arguments,
/// `map`/`filter` (with inline and named callables) and keyless tuple sorting.
#[test]
fn pythonic_defaults_else_keywords_and_map_filter() {
    if !has_clang() {
        eprintln!("skipping: clang not found");
        return;
    }

    let src = r#"def greet(name: str, punct: str = "!", loud: bool = false) -> str:
    if loud:
        return name + punct + punct
    return name + punct

def rect(w: int, h: int = 2) -> int:
    return w * h

def sq(x: int) -> int:
    return x * x

def odd(x: int) -> bool:
    return x % 2 == 1

def find(target: int) -> str:
    for i in range(4):
        if i == target:
            return "found"
    else:
        return "missing"

def main():
    print(greet("hi"), greet("hi", punct="?"), greet(loud=true, name="hey"))
    print(rect(5), rect(h=3, w=4))
    print(find(2), find(9))
    for j in range(2):
        pass
    print(j)
    nums = [1, 2, 3, 4, 5]
    print(list(map(sq, nums)))
    print(list(filter(odd, nums)))
    print(list(map(lambda x: x * 2, nums)))
    print(list(map(str, nums)))
    print(sorted([("b", 2), ("a", 1), ("a", 0)]))
    print(sorted([3, 1, 2], reverse=True))
main()
"#;

    let out = build_and_run("v11_defaults_else_map", src);
    assert_eq!(
        out,
        "hi! hi? hey!!\n10 12\nfound missing\n1\n\
         [1, 4, 9, 16, 25]\n[1, 3, 5]\n[2, 4, 6, 8, 10]\n[1, 2, 3, 4, 5]\n\
         [(a, 0), (a, 1), (b, 2)]\n[3, 2, 1]\n"
    );
}

/// v0.9.2 — keyless sorting of nested collections: tuples with tuple payloads and lists of ints
/// compare exactly like CPython (lexicographic, then length for lists).
#[test]
fn pythonic_nested_collection_sorting_matches_cpython() {
    if !has_clang() {
        eprintln!("skipping: clang not found");
        return;
    }

    let src = r#"def main():
    rows = [[3, 1], [1, 2], [2, 5], [1, 1]]
    print(sorted(rows))
    print(sorted(rows, reverse=True))
    print(sorted([[1, 2], [1, 2, 0], [1]]))
    tagged = [(3, "x", 9), (1, "z", 2), (2, "a", 5)]
    print(sorted(tagged))
    nested = [("a", (2, "y")), ("a", (1, "z")), ("b", (0, "q"))]
    print(sorted(nested))
    pairs = [("b", 2), ("a", 1), ("a", 0)]
    print(sorted(pairs))
main()
"#;

    let out = build_and_run("v12_nested_sort", src);
    assert_eq!(
        out,
        "[[1, 1], [1, 2], [2, 5], [3, 1]]\n\
         [[3, 1], [2, 5], [1, 2], [1, 1]]\n\
         [[1], [1, 2], [1, 2, 0]]\n\
         [(1, z, 2), (2, a, 5), (3, x, 9)]\n\
         [(a, (1, z)), (a, (2, y)), (b, (0, q))]\n\
         [(a, 0), (a, 1), (b, 2)]\n"
    );
}

/// v0.9.2 — `del x` ends the binding early: the value is dropped once, the name is gone, and a
/// later rebinding introduces a fresh variable (Python removes the name from the scope).
#[test]
fn del_statement_drops_and_forgets_binding() {
    if !has_clang() {
        eprintln!("skipping: clang not found");
        return;
    }

    let src = r#"def main():
    xs = [1, 2, 3]
    print(len(xs))
    del xs
    xs = "reborn"
    print(xs)
    d = {"a": 1}
    del d
    print("gone")
main()
"#;
    assert_eq!(build_and_run("v12_del", src), "3\nreborn\ngone\n");

    // A read after `del` is a compile error, like Python's `UnboundLocalError`.
    let dir = std::env::temp_dir().join(format!("archx-del-bad-{}", std::process::id()));
    fs::create_dir_all(&dir).unwrap();
    let src = dir.join("del_bad.archx.lang");
    fs::write(&src, with_native_directive("def main():\n    x = 5\n    del x\n    print(x)\nmain()\n")).unwrap();
    let out = Command::new(archx()).arg(&src).arg("--emit-ir").output().unwrap();
    assert!(!out.status.success());
    let err = String::from_utf8_lossy(&out.stderr);
    assert!(err.contains("undefined variable `x`"), "stderr was: {err}");
}

/// v0.9.2 — module-level constants and `global`: literal bindings fold to compile-time constants
/// readable from any function, and `global NAME` assignment mutates one shared module slot.
#[test]
fn module_constants_and_global_rebinding_match_python() {
    if !has_clang() {
        eprintln!("skipping: clang not found");
        return;
    }

    let src = r#"LIMIT = 10
NAME = "archx"
count = 0

def bump():
    global count
    count = count + 1

def show():
    print(count)

def limit() -> int:
    return LIMIT

def banner() -> str:
    return "hi " + NAME

def main():
    bump()
    bump()
    print(count, limit(), banner())
    count = 10
    bump()
    print(count)
main()
"#;
    assert_eq!(build_and_run("v12_globals", src), "2 10 hi archx\n11\n");

    // The in-order case: a module binding that is *not* hoisted keeps its runtime value.
    let ordered = r#"total = 0
for i in range(4):
    total += i
print(total)
"#;
    assert_eq!(build_and_run("v12_globals_order", ordered), "6\n");
}

/// AX-001: the leak gate must be able to observe a live allocation.
///
/// `ci/leakcheck.c` is the independent check that runs in CI. If the tracker itself regresses
/// (wrong `--wrap` wiring, silently missing a destructor) every program looks clean and the gate
/// becomes theatre. This pins the tracker's failing behaviour against a program that leaks by
/// construction.
#[test]
fn leakcheck_tracker_reports_leaks() {
    if !has_clang() {
        eprintln!("skipping: clang not found");
        return;
    }
    if !linker_supports_wrap() {
        eprintln!("skipping: the leak harness needs GNU ld/lld `--wrap` (Linux only)");
        return;
    }
    let dir = std::env::temp_dir().join(format!("archx-leakcheck-{}", std::process::id()));
    fs::create_dir_all(&dir).unwrap();

    let leak_src = dir.join("leak.c");
    fs::write(
        &leak_src,
        "#include <stdlib.h>\nvoid *leak_demo(void) { return malloc(1234); }\n",
    )
    .unwrap();
    let drv_src = dir.join("drv.c");
    fs::write(
        &drv_src,
        "extern void *leak_demo(void);\nint main(void) { (void)leak_demo(); return 0; }\n",
    )
    .unwrap();

    let tracker = Path::new(env!("CARGO_MANIFEST_DIR")).join("ci/leakcheck.c");
    let exe = exe_path(&dir, "leakdemo");
    let build = Command::new("clang")
        .arg("-O1")
        .arg(&drv_src)
        .arg(&leak_src)
        .arg(&tracker)
        .args([
            "-Wl,--wrap=malloc",
            "-Wl,--wrap=calloc",
            "-Wl,--wrap=realloc",
            "-Wl,--wrap=free",
        ])
        .arg("-o")
        .arg(&exe)
        .output()
        .unwrap();
    assert!(
        build.status.success(),
        "leakcheck harness failed to build: {}",
        String::from_utf8_lossy(&build.stderr)
    );

    let run = Command::new(&exe).output().unwrap();
    let stderr = String::from_utf8_lossy(&run.stderr);
    assert!(
        !run.status.success(),
        "leakcheck must exit non-zero when a block is still live; stderr: {stderr}"
    );
    assert!(
        stderr.contains("LEAKCHECK: FAILED"),
        "leakcheck must report the failure on stderr; got: {stderr}"
    );
    assert!(
        stderr.contains("1234 byte(s)"),
        "leakcheck must name the leaked size; got: {stderr}"
    );
}

/// AX-001 regression: every construct that used to leak its buffer must still print correctly AND
/// still be leak-free, so a future change cannot trade a leak for a wrong answer.
#[test]
fn v1_leak_free_collections() {
    if !has_clang() {
        eprintln!("skipping: clang not found");
        return;
    }
    // Comprehensions, filtered comprehensions, `min`/`max` over generators, nested comprehensions
    // re-bound through a `for row in grid:` loop variable, and `sorted()` with and without `key=`.
    let src = r#"def main():
    n = 200
    squares = [x * x for x in range(n)]
    evens = [x for x in squares if x % 2 == 0]
    print(len(squares), len(evens))
    print(sum(evens))
    print(max(x * 2 for x in range(n)))
    print(min(x * 3 + 1 for x in range(n)))
    grid = [[r * c for c in range(4)] for r in range(5)]
    acc = 0
    for row in grid:
        for v in row:
            acc += v
    print(acc)
    raw = [(i * 37) % 997 for i in range(n)]
    asc = sorted(raw)
    desc = sorted(raw, reverse=True)
    neg = sorted(raw, key=lambda v: -v)
    print(asc[0], asc[n - 1], desc[0], neg[0], neg[n - 1])
main()
"#;
    let expected = {
        // Ground truth computed with the same semantics the compat dialect promises.
        let n = 200;
        let squares: Vec<i64> = (0..n).map(|x| x * x).collect();
        let evens: Vec<i64> = squares.iter().copied().filter(|v| v % 2 == 0).collect();
        let acc: i64 = (0..5).flat_map(|r| (0..4).map(move |c| r * c)).sum();
        let raw: Vec<i64> = (0..n).map(|i| (i * 37) % 997).collect();
        let mut asc = raw.clone();
        asc.sort();
        let mut desc = raw.clone();
        desc.sort_by(|a, b| b.cmp(a));
        let mut neg = raw.clone();
        neg.sort_by_key(|v| -v);
        format!(
            "{} {}\n{}\n{}\n{}\n{}\n{} {} {} {} {}\n",
            squares.len(),
            evens.len(),
            evens.iter().sum::<i64>(),
            (0..n).map(|x| x * 2).max().unwrap(),
            (0..n).map(|x| x * 3 + 1).min().unwrap(),
            acc,
            asc[0],
            asc[n as usize - 1],
            desc[0],
            neg[0],
            neg[n as usize - 1]
        )
    };
    assert_eq!(build_and_run("v1_leak_free", src), expected);
}

/// AX-013: the dialect is an explicit, checked, per-module decision.
///
/// The failure this guards against is a program whose behaviour depends on a compiler default, so
/// a missing directive must be a hard error rather than a fallback, and a malformed directive must
/// say what is wrong instead of silently picking one side.
#[test]
fn dialect_directive_is_required_and_checked() {
    if !has_clang() {
        eprintln!("skipping: clang not found");
        return;
    }
    let dir = std::env::temp_dir().join(format!("archx-dialect-{}", std::process::id()));
    fs::create_dir_all(&dir).unwrap();

    let compile = |name: &str, source: &str| {
        let path = dir.join(format!("{name}.archx.lang"));
        fs::write(&path, source).unwrap();
        Command::new(archx())
            .arg(&path)
            .arg("--emit-ir")
            .output()
            .unwrap()
    };

    // 1. A module with no directive is rejected, and the message names the code and the fix.
    let missing = compile("no_directive", "def main():\n    print(1)\nmain()\n");
    assert!(!missing.status.success(), "a missing directive must fail");
    let err = String::from_utf8_lossy(&missing.stderr);
    assert!(err.contains("E0100"), "expected E0100, got: {err}");
    assert!(
        err.contains("dialect=compat") && err.contains("dialect=native"),
        "the error must show both legal directives, got: {err}"
    );

    // 2. A malformed directive is a different error, not a silent default.
    for (name, body, needle) in [
        ("bad_dialect", "dialect=python, version=1", "unknown dialect"),
        ("bad_version", "dialect=native, version=99", "version 1"),
        ("missing_version", "dialect=native", "missing `version=`"),
        ("unknown_key", "dialect=native, version=1, turbo=on", "unknown directive key"),
    ] {
        let out = compile(name, &format!("# archx: {body}\ndef main():\n    print(1)\nmain()\n"));
        assert!(!out.status.success(), "`{body}` must fail");
        let err = String::from_utf8_lossy(&out.stderr);
        assert!(err.contains("E0101"), "`{body}` must be E0101, got: {err}");
        assert!(err.contains(needle), "`{body}` must mention `{needle}`, got: {err}");
    }

    // 3. Both dialects compile the same source, the emitted IR records which contract it was
    //    lowered against, and a normal comment on line 1 is not a directive.
    for dialect in ["compat", "native"] {
        let out = compile(
            &format!("ok_{dialect}"),
            &format!("# archx: dialect={dialect}, version=1\ndef main():\n    print(2)\nmain()\n"),
        );
        assert!(
            out.status.success(),
            "`{dialect}` must compile: {}",
            String::from_utf8_lossy(&out.stderr)
        );
        let ir = String::from_utf8_lossy(&out.stdout);
        assert!(
            ir.contains(&format!("!0 = !{{i32 1, !\"archx.dialect\", !\"{dialect}\"}}")),
            "the IR must carry the dialect module flag, got:\n{ir}"
        );
        assert!(
            ir.contains("!1 = !{i32 1, !\"archx.directive_version\", !\"1\"}"),
            "the IR must carry the directive version, got:\n{ir}"
        );
    }
    let comment_first = compile(
        "comment_first",
        "# just a note\ndef main():\n    print(3)\nmain()\n",
    );
    assert!(
        !comment_first.status.success(),
        "a leading ordinary comment must not stand in for the directive"
    );

    // 4. `--dialect` overrides the module's directive.
    let path = dir.join("override.archx.lang");
    fs::write(&path, "# archx: dialect=compat, version=1\ndef main():\n    print(4)\nmain()\n")
        .unwrap();
    let over = Command::new(archx())
        .arg(&path)
        .arg("--dialect")
        .arg("native")
        .arg("--emit-ir")
        .output()
        .unwrap();
    assert!(
        over.status.success(),
        "--dialect must override a valid directive: {}",
        String::from_utf8_lossy(&over.stderr)
    );
    // ...and an unknown override name is rejected rather than ignored.
    let bad_over = Command::new(archx())
        .arg(&path)
        .arg("--dialect")
        .arg("cobol")
        .arg("--emit-ir")
        .output()
        .unwrap();
    assert!(!bad_over.status.success(), "an unknown --dialect must be rejected");
}
