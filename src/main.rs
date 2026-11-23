//! CLI entry point and compiler driver: parses flags, runs frontend + LLVM IR codegen, and invokes `clang`.

mod ast;
mod codegen;
mod diag;
mod lexer;
mod parser;
mod token;

use std::env;
use std::fs::{self, OpenOptions};
use std::io::Write as _;
use std::path::{Path, PathBuf};
use std::process::Command;
use std::sync::atomic::{AtomicU64, Ordering};

const VERSION: &str = env!("CARGO_PKG_VERSION");
const VALID_EXTENSIONS: [&str; 4] = [".archx.lang", ".archx.lg", ".ax.lang", ".ax.lg"];
static TMP_COUNTER: AtomicU64 = AtomicU64::new(0);

struct Options {
    input: Option<PathBuf>,
    output: Option<PathBuf>,
    emit_ir: bool,
    run: bool,
}

fn main() {
    let args: Vec<String> = env::args().skip(1).collect();

    match run(&args) {
        Ok(code) => std::process::exit(code),
        Err(message) => {
            eprintln!("archx: error: {message}");
            std::process::exit(1);
        }
    }
}

fn run(args: &[String]) -> Result<i32, String> {
    let mut options = Options {
        input: None,
        output: None,
        emit_ir: false,
        run: false,
    };

    let mut i = 0;
    while i < args.len() {
        match args[i].as_str() {
            "-h" | "--help" => {
                print_help();
                return Ok(0);
            }
            "-V" | "--version" => {
                println!("archx {VERSION}");
                return Ok(0);
            }
            "--emit-ir" => options.emit_ir = true,
            "--run" => options.run = true,
            "-o" | "--output" => {
                i += 1;
                if i >= args.len() {
                    return Err("missing value after `-o`".to_string());
                }
                options.output = Some(PathBuf::from(&args[i]));
            }
            other if other.starts_with('-') => {
                return Err(format!("unknown option `{other}` (try `archx --help`)"));
            }
            path => {
                if options.input.is_some() {
                    return Err("only one input file is supported".to_string());
                }
                options.input = Some(PathBuf::from(path));
            }
        }
        i += 1;
    }

    let input = options
        .input
        .ok_or_else(|| "no input file (try `archx --help`)".to_string())?;

    if !has_valid_archx_extension(&input) {
        return Err(format!(
            "invalid source file extension for `{}` (expected `.archx.lang`, `.archx.lg`, `.ax.lang`, or `.ax.lg`)",
            input.display()
        ));
    }

    let source = fs::read_to_string(&input)
        .map_err(|error| format!("cannot read `{}`: {error}", input.display()))?;

    let tokens = lexer::Lexer::new(&source)
        .tokenize()
        .map_err(|diagnostic| render_error(&source, &diagnostic))?;

    let mut parser = parser::Parser::new(tokens);
    let program = parser
        .parse_program()
        .map_err(|diagnostic| render_error(&source, &diagnostic))?;

    let ir = codegen::lower(&program)
        .map_err(|diagnostic| render_error(&source, &diagnostic))?;

    if options.emit_ir {
        print!("{ir}");
        return Ok(0);
    }

    let output = options
        .output
        .unwrap_or_else(|| default_output(&input));

    if paths_refer_to_same_file(&input, &output) {
        return Err(format!(
            "refusing to overwrite source file `{}` with `-o`",
            input.display()
        ));
    }

    let clang = find_clang().ok_or_else(|| {
        "no `clang` found. Archx emits LLVM IR and uses clang to compile it.\n\
         Install clang (for example `apt install clang` or `brew install llvm`) and make sure it is on PATH,\n\
         or set ARCHX_CC=/path/to/clang."
            .to_string()
    })?;

    let ir_path = write_exclusive_temp_ir(&ir)?;

    let mut clang_cmd = Command::new(&clang);
    clang_cmd
        .arg(&ir_path)
        .arg("-O2")
        .arg("-Wno-override-module")
        .arg("-o")
        .arg(&output);
    if cfg!(windows) && clang_uses_msvc_target(&clang) {
        clang_cmd.arg("-llegacy_stdio_definitions");
    } else if !cfg!(windows) {
        clang_cmd.arg("-lm");
    }

    let clang_res = clang_cmd.status();

    let _ = fs::remove_file(&ir_path);

    let status = clang_res
        .map_err(|error| format!("failed to run `{}`: {error}", clang.display()))?;

    if !status.success() {
        return Err("clang failed to compile generated LLVM IR".to_string());
    }

    if options.run {
        let run_path = if output.parent().map_or(true, |p| p.as_os_str().is_empty()) {
            PathBuf::from(".").join(&output)
        } else {
            output.clone()
        };
        let status = Command::new(&run_path)
            .status()
            .map_err(|error| format!("failed to run `{}`: {error}", run_path.display()))?;
        return Ok(status.code().unwrap_or(0));
    }

    println!(
        "compiled `{}` -> `{}`",
        input.display(),
        output.display()
    );
    Ok(0)
}

fn has_valid_archx_extension(path: &Path) -> bool {
    let Some(name) = path.file_name().and_then(|s| s.to_str()) else {
        return false;
    };
    VALID_EXTENSIONS
        .iter()
        .any(|ext| name.len() > ext.len() && name.ends_with(ext))
}

fn paths_refer_to_same_file(a: &Path, b: &Path) -> bool {
    if a == b {
        return true;
    }
    if let (Ok(ca), Ok(cb)) = (fs::canonicalize(a), fs::canonicalize(b)) {
        return ca == cb;
    }
    false
}

fn write_exclusive_temp_ir(ir: &str) -> Result<PathBuf, String> {
    let dir = env::temp_dir();
    let pid = std::process::id();
    for attempt in 0..1024u64 {
        let seq = TMP_COUNTER.fetch_add(1, Ordering::Relaxed) + attempt;
        let candidate = dir.join(format!("archx-{pid}-{seq}.ll"));
        match OpenOptions::new()
            .write(true)
            .create_new(true)
            .open(&candidate)
        {
            Ok(mut file) => {
                if let Err(err) = file.write_all(ir.as_bytes()) {
                    let _ = fs::remove_file(&candidate);
                    return Err(format!(
                        "cannot write temporary IR `{}`: {err}",
                        candidate.display()
                    ));
                }
                return Ok(candidate);
            }
            Err(err) if err.kind() == std::io::ErrorKind::AlreadyExists => continue,
            Err(err) => {
                return Err(format!(
                    "cannot create temporary IR `{}`: {err}",
                    candidate.display()
                ));
            }
        }
    }
    Err("failed to allocate unique temporary `.ll` file".to_string())
}

fn default_output(input: &Path) -> PathBuf {
    let file_name = input
        .file_name()
        .map(|name| name.to_string_lossy().to_string())
        .unwrap_or_else(|| "a.out".to_string());

    let stem = VALID_EXTENSIONS
        .iter()
        .find_map(|ext| file_name.strip_suffix(ext))
        .map(|s| s.to_string())
        .unwrap_or_else(|| {
            Path::new(&file_name)
                .file_stem()
                .map(|stem| stem.to_string_lossy().to_string())
                .unwrap_or_else(|| "a.out".to_string())
        });

    let mut output = PathBuf::from(stem);
    if cfg!(windows) {
        output.set_extension("exe");
    }
    output
}

fn find_clang() -> Option<PathBuf> {
    if let Ok(path) = env::var("ARCHX_CC") {
        if !path.is_empty() {
            return Some(PathBuf::from(path));
        }
    }

    for name in [
        "clang",
        "clang-21",
        "clang-20",
        "clang-19",
        "clang-18",
        "clang-17",
        "clang-16",
        "clang-15",
    ] {
        if let Ok(output) = Command::new(name).arg("--version").output() {
            if output.status.success() {
                return Some(PathBuf::from(name));
            }
        }
    }

    if cfg!(windows) {
        let win_llvm = PathBuf::from(r"C:\Program Files\LLVM\bin\clang.exe");
        if win_llvm.is_file() {
            return Some(win_llvm);
        }
    }

    None
}

fn clang_uses_msvc_target(clang: &Path) -> bool {
    Command::new(clang)
        .arg("--version")
        .output()
        .map(|out| String::from_utf8_lossy(&out.stdout).contains("windows-msvc"))
        .unwrap_or(false)
}

fn render_error(source: &str, diagnostic: &diag::Diagnostic) -> String {
    let line = source
        .lines()
        .nth(diagnostic.span.line.saturating_sub(1))
        .unwrap_or("");

    let mut out = String::new();
    out.push_str(&format!("error: {}\n", diagnostic.message));
    out.push_str(&format!(
        "  --> {}:{}\n",
        diagnostic.span.line, diagnostic.span.col
    ));
    out.push_str("   |\n");
    out.push_str(&format!("{:3} | {}\n", diagnostic.span.line, line));
    out.push_str(&format!(
        "   | {}^\n",
        " ".repeat(diagnostic.span.col.saturating_sub(1))
    ));
    out
}

fn print_help() {
    println!("archx {VERSION} — a small readable language that compiles to LLVM IR");
    println!();
    println!("USAGE:");
    println!("    archx <file.archx.lang> [options]");
    println!();
    println!("FILE EXTENSIONS:");
    println!("    .archx.lang, .archx.lg, .ax.lang, .ax.lg");
    println!();
    println!("OPTIONS:");
    println!("    -o, --output <file>   output executable (default: input name without extension)");
    println!("    --emit-ir             print the generated LLVM IR and exit");
    println!("    --run                 compile, then run the resulting program");
    println!("    -h, --help            show this help");
    println!("    -V, --version         show the version");
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn default_output_strips_archx_extensions() {
        let expected = |stem: &str| {
            let mut path = PathBuf::from(stem);
            if cfg!(windows) {
                path.set_extension("exe");
            }
            path
        };

        assert_eq!(default_output(Path::new("hello.archx.lang")), expected("hello"));
        assert_eq!(default_output(Path::new("dir/hello.archx.lg")), expected("hello"));
        assert_eq!(default_output(Path::new("hello.ax.lang")), expected("hello"));
        assert_eq!(default_output(Path::new("hello.ax.lg")), expected("hello"));
        assert!(has_valid_archx_extension(Path::new("hello.archx.lang")));
        assert!(!has_valid_archx_extension(Path::new("hello.archx")));
        assert!(!has_valid_archx_extension(Path::new(".archx.lang")));
    }
}
