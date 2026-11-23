use std::fs;
use std::path::PathBuf;
use std::process::Command;

fn archx() -> PathBuf {
    PathBuf::from(env!("CARGO_BIN_EXE_archx"))
}

fn has_clang() -> bool {
    Command::new("clang")
        .arg("--version")
        .output()
        .map(|output| output.status.success())
        .unwrap_or(false)
}

/// Compiles `source` with the freshly built archx binary and returns the
/// program's stdout. Panics with the compiler's stderr if compilation fails.
fn build_and_run(tag: &str, source: &str) -> String {
    let dir = std::env::temp_dir().join(format!("archx-{tag}-{}", std::process::id()));
    fs::create_dir_all(&dir).unwrap();

    let src = dir.join(format!("{tag}.archx.lang"));
    fs::write(&src, source).unwrap();

    let exe = dir.join(tag);
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
    String::from_utf8_lossy(&run.stdout).to_string()
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

    let exe = dir.join("oob");
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
    let exe2 = dir.join("oob_for");
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
    let exe3 = dir.join("oob_while");
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
