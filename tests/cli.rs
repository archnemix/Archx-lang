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

    let dir = std::env::temp_dir().join(format!("archx-run-{}", std::process::id()));
    fs::create_dir_all(&dir).unwrap();

    let src = dir.join("hello.archx.lang");
    fs::write(
        &src,
        "func main():\n    print(\"Hello, Archx!\")\n    print('single quotes too')\n    let x = 6 * 7\n    print(x)\n",
    )
    .unwrap();

    let exe = dir.join("hello");
    let build = Command::new(archx())
        .arg(&src)
        .arg("-o")
        .arg(&exe)
        .output()
        .unwrap();

    assert!(
        build.status.success(),
        "stderr: {}",
        String::from_utf8_lossy(&build.stderr)
    );

    let run = Command::new(&exe).output().unwrap();
    assert!(run.status.success());
    assert_eq!(
        String::from_utf8_lossy(&run.stdout),
        "Hello, Archx!\nsingle quotes too\n42\n"
    );
}

#[test]
fn functions_run() {
    if !has_clang() {
        eprintln!("skipping: clang not found");
        return;
    }

    let dir = std::env::temp_dir().join(format!("archx-func-{}", std::process::id()));
    fs::create_dir_all(&dir).unwrap();

    let src = dir.join("functions.archx.lang");
    fs::write(
        &src,
        "func add(a: int, b: int) -> int:\n    return a + b\n\nfunc main():\n    print(add(40, 2))\n",
    )
    .unwrap();

    let exe = dir.join("functions");
    let build = Command::new(archx())
        .arg(&src)
        .arg("-o")
        .arg(&exe)
        .output()
        .unwrap();

    assert!(
        build.status.success(),
        "stderr: {}",
        String::from_utf8_lossy(&build.stderr)
    );

    let run = Command::new(&exe).output().unwrap();
    assert!(run.status.success());
    assert_eq!(String::from_utf8_lossy(&run.stdout), "42\n");
}
