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
