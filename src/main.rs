mod ast;
mod codegen;
mod diag;
mod lexer;
mod parser;
mod token;

use std::env;
use std::fs;
use std::path::{Path, PathBuf};
use std::process::Command;

const VERSION: &str = env!("CARGO_PKG_VERSION");

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
    let ir_path = output.with_extension("ll");

    fs::write(&ir_path, &ir)
        .map_err(|error| format!("cannot write `{}`: {error}", ir_path.display()))?;

    let clang = find_clang().ok_or_else(|| {
        "no `clang` found. Archx emits LLVM IR and uses clang to compile it.\n\
         Install clang (for example `apt install clang` or `brew install llvm`) and make sure it is on PATH,\n\
         or set ARCHX_CC=/path/to/clang."
            .to_string()
    })?;

    let status = Command::new(&clang)
        .arg(&ir_path)
        .arg("-O2")
        .arg("-o")
        .arg(&output)
        .status()
        .map_err(|error| format!("failed to run `{}`: {error}", clang.display()))?;

    if !status.success() {
        return Err(format!(
            "clang failed to compile `{}`",
            ir_path.display()
        ));
    }

    if options.run {
        let status = Command::new(&output)
            .status()
            .map_err(|error| format!("failed to run `{}`: {error}", output.display()))?;
        return Ok(status.code().unwrap_or(0));
    }

    println!(
        "compiled `{}` -> `{}`",
        input.display(),
        output.display()
    );
    Ok(0)
}

fn default_output(input: &Path) -> PathBuf {
    let file_name = input
        .file_name()
        .map(|name| name.to_string_lossy().to_string())
        .unwrap_or_else(|| "a.out".to_string());

    let stem = if let Some(stem) = file_name.strip_suffix(".archx.lang") {
        stem.to_string()
    } else if let Some(stem) = file_name.strip_suffix(".archx.lg") {
        stem.to_string()
    } else if let Some(stem) = file_name.strip_suffix(".archx") {
        stem.to_string()
    } else {
        Path::new(&file_name)
            .file_stem()
            .map(|stem| stem.to_string_lossy().to_string())
            .unwrap_or_else(|| "a.out".to_string())
    };

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

    None
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
    println!("    archx <file.archx> [options]");
    println!();
    println!("OPTIONS:");
    println!("    -o, --output <file>   output executable (default: input name without extension)");
    println!("    --emit-ir             print the generated LLVM IR and exit");
    println!("    --run                 compile, then run the resulting program");
    println!("    -h, --help            show this help");
    println!("    -V, --version         show the version");
}
