//! CLI entry point and compiler driver: parses flags, runs frontend + LLVM IR codegen, and invokes `clang`.

#[deny(dead_code)] // AX-004: a stale AST variant is a lie about the language; fail the build instead.
mod ast;
mod codegen;
mod diag;
mod diagnose;
mod dialect;
mod check;
mod dialect_rules;
mod explain_perf;
mod error_codes;
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

/// The optimisation level `archx` compiles with unless `-O` says otherwise.
///
/// `-O2` rather than `-O3` is a measured choice, not a default inherited from habit: on the seven
/// benchmark suites `-O3` moved wall-clock time by under 2% and changed no stdout, while `-O3`'s
/// larger unrolling and vectorisation widen the surface where a miscompile could hide a safety check.
/// `-O` exists so this can be re-measured per program (`docs/Thinking.md`, AX-012) instead of assumed.
const DEFAULT_OPT_LEVEL: &str = "-O2";
static TMP_COUNTER: AtomicU64 = AtomicU64::new(0);

struct Options {
    input: Option<PathBuf>,
    output: Option<PathBuf>,
    emit_ir: bool,
    run: bool,
    /// `--dialect compat|native`. Overrides the module's own directive (the directive is still
    /// required, so a module cannot be silently compiled against a contract it never declared).
    dialect: Option<dialect::Dialect>,
    /// The `clang` optimisation level. Pinned at `-O2` by default: see `optimisation_level`.
    opt_level: String,
}

/// A failure the driver reports itself (bad flags, I/O, toolchain), as opposed to a source diagnostic.
///
/// It carries a code for the same reason every other error does: a script that drives `archx` should
/// be able to tell "you passed a bad flag" (`E0001`) from "your program does not typecheck" (`E0402`)
/// without reading English.
#[derive(Debug)]
struct DriverError {
    code: error_codes::Code,
    message: String,
    /// Whether `message` is already the complete report (a rendered source snippet with its code and
    /// caret, or a JSON object), as opposed to a bare sentence that still needs its code prepended.
    rendered: bool,
}

impl DriverError {
    fn new(code: error_codes::Code, message: impl Into<String>) -> Self {
        Self {
            code,
            message: message.into(),
            rendered: false,
        }
    }

    /// A failure whose message is already the finished text (see `rendered`).
    fn rendered(code: error_codes::Code, message: impl Into<String>) -> Self {
        Self {
            code,
            message: message.into(),
            rendered: true,
        }
    }
}

impl std::fmt::Display for DriverError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "{}: {}", self.code.as_str(), self.message)
    }
}

impl DriverError {
    /// The human line for a driver failure: `E0001: unknown option …`.
    fn render_human(&self) -> String {
        format!("{}: {}", self.code.as_str(), self.message)
    }
}

type DriverResult<T> = std::result::Result<T, DriverError>;

/// One diagnostic in the machine-readable format: a single JSON object per line.
///
/// Hand-rolled rather than serde: the compiler has no dependencies by design (a 14 KB binary is a
/// feature), and the shape is fixed. Strings are escaped by `json_escape`, which is tested against a
/// real JSON parser in `tests/cli.rs`.
fn diagnostic_json(
    code: error_codes::Code,
    severity: &str,
    message: &str,
    file: Option<&str>,
    span: Option<diag::Span>,
) -> String {
    let mut out = String::from("{");
    out.push_str(&format!("\"code\":\"{}\",", code.as_str()));
    out.push_str(&format!("\"severity\":\"{severity}\","));
    out.push_str(&format!("\"message\":\"{}\",", json_escape(message)));
    out.push_str(&format!(
        "\"summary\":\"{}\",",
        json_escape(code.summary())
    ));
    if let Some(file) = file {
        out.push_str(&format!("\"file\":\"{}\",", json_escape(file)));
    }
    match span {
        Some(span) => out.push_str(&format!(
            "\"line\":{},\"column\":{},",
            span.line, span.col
        )),
        None => out.push_str("\"line\":null,\"column\":null,"),
    }
    out.push_str(&format!("\"internal\":{}}}", code.is_internal()));
    out
}

/// Escapes a string for a JSON string literal, including the control characters a source file can
/// contain. Lone surrogates cannot occur in Rust `String`s, so UTF-8 passes through unchanged.
fn json_escape(text: &str) -> String {
    let mut out = String::with_capacity(text.len());
    for ch in text.chars() {
        match ch {
            '"' => out.push_str("\\\""),
            '\\' => out.push_str("\\\\"),
            '\n' => out.push_str("\\n"),
            '\r' => out.push_str("\\r"),
            '\t' => out.push_str("\\t"),
            c if (c as u32) < 0x20 => out.push_str(&format!("\\u{:04x}", c as u32)),
            c => out.push(c),
        }
    }
    out
}

fn main() {
    let args: Vec<String> = env::args().skip(1).collect();

    // `--message-format=json` is parsed before anything else, because it decides *how* every later
    // failure is reported, including a bad flag.
    let (args, json) = extract_message_format(&args);
    match run(&args, json) {
        Ok(code) => std::process::exit(code),
        Err(error) => {
            if json {
                // A JSON diagnostic is already a complete object when the failing stage produced one
                // (source diagnostics carry their span and file); driver errors are wrapped here.
                if error.rendered {
                    eprintln!("{}", error.message);
                } else {
                    eprintln!(
                        "{}",
                        diagnostic_json(error.code, "error", &error.message, None, None)
                    );
                }
            } else if error.rendered {
                // A source diagnostic renders itself, rustc-style: `error[E0402]: …` plus the snippet.
                eprint!("{}", error.message);
            } else {
                eprintln!("archx: error: {}", error.render_human());
            }
            std::process::exit(1);
        }
    }
}

/// Pulls `--message-format` out of the argument list, returning the remaining arguments.
///
/// Done first and unconditionally so that a *malformed* invocation can still be reported in the
/// requested format: a build tool that asked for JSON should not have to parse English just because
/// another flag was also wrong.
fn extract_message_format(args: &[String]) -> (Vec<String>, bool) {
    let mut kept = Vec::with_capacity(args.len());
    let mut json = false;
    let mut i = 0;
    while i < args.len() {
        let arg = &args[i];
        if arg == "--message-format=json" || arg == "--message-format" && args.get(i + 1).map(String::as_str) == Some("json") {
            json = true;
            if arg == "--message-format" {
                i += 1;
            }
        } else if arg == "--message-format=human" || arg == "--message-format" && args.get(i + 1).map(String::as_str) == Some("human") {
            if arg == "--message-format" {
                i += 1;
            }
        } else {
            kept.push(arg.clone());
        }
        i += 1;
    }
    (kept, json)
}

/// Shared by `-O3` and `-O 3`: validate the level text and store the clang flag for it.
fn args_i_split(options: &mut Options, level: &str) -> DriverResult<()> {
    options.opt_level = match level {
        "0" => "-O0",
        "1" => "-O1",
        "2" => "-O2",
        "3" => "-O3",
        "s" => "-Os",
        other => {
            return Err(DriverError::new(
                error_codes::Code::MissingOptionValue,
                format!("unknown optimisation level `{other}` (expected 0, 1, 2, 3 or s)"),
            ))
        }
    }
    .to_string();
    Ok(())
}

fn run(args: &[String], json: bool) -> DriverResult<i32> {
    let mut options = Options {
        input: None,
        output: None,
        emit_ir: false,
        run: false,
        dialect: None,
        opt_level: DEFAULT_OPT_LEVEL.to_string(),
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
            "explain-perf" => {
                return explain_perf_command(&args[i + 1..], json);
            }
            "check" => {
                return check_command(&args[i + 1..]);
            }
            "--dialect-matrix" => {
                // The matrix the compiler actually obeys, for both humans and the docs generator.
                print!("{}", dialect_rules::render_matrix());
                return Ok(0);
            }
            "--explain" => {
                // `archx explain` with no code lists every code; with a code it prints the entry.
                let code = args.get(i + 1).filter(|text| !text.starts_with('-'));
                match code {
                    Some(text) => match error_codes::Code::parse(text) {
                        Some(code) => print!("{}", error_codes::explain(Some(code))),
                        None => {
                            return Err(DriverError::new(
                                error_codes::Code::UnknownOption,
                                format!("unknown error code `{text}` (try `archx explain`)"),
                            ))
                        }
                    },
                    None => print!("{}", error_codes::explain(None)),
                }
                return Ok(0);
            }
            "--dialect" => {
                i += 1;
                if i >= args.len() {
                    return Err(DriverError::new(
                        error_codes::Code::MissingOptionValue,
                        "missing value after `--dialect`",
                    ));
                }
                options.dialect =
                    Some(dialect::Dialect::parse(&args[i]).ok_or_else(|| {
                        DriverError::new(
                            error_codes::Code::UnknownOption,
                            format!(
                                "unknown dialect `{}` (expected `compat` or `native`)",
                                args[i]
                            ),
                        )
                    })?);
            }
            "-O" | "--opt-level" => {
                i += 1;
                if i >= args.len() {
                    return Err(DriverError::new(
                        error_codes::Code::MissingOptionValue,
                        "missing value after `-O` (expected 0, 1, 2, 3 or s)",
                    ));
                }
                args_i_split(&mut options, &args[i])?;
            }
            "--emit-ir" => options.emit_ir = true,
            "--run" => options.run = true,
            "-o" | "--output" => {
                i += 1;
                if i >= args.len() {
                    return Err(DriverError::new(
                        error_codes::Code::MissingOptionValue,
                        "missing value after `-o`",
                    ));
                }
                options.output = Some(PathBuf::from(&args[i]));
            }
            // Accept the fused spelling too: `-O3` is what everyone types.
            other if other.len() > 2 && other.starts_with("-O") => {
                args_i_split(&mut options, &other[2..])?;
            }
            other if other.starts_with('-') => {
                return Err(DriverError::new(
                    error_codes::Code::UnknownOption,
                    format!("unknown option `{other}` (try `archx --help`)"),
                ));
            }
            path => {
                if options.input.is_some() {
                    return Err(DriverError::new(
                        error_codes::Code::MultipleInputs,
                        "only one input file is supported",
                    ));
                }
                options.input = Some(PathBuf::from(path));
            }
        }
        i += 1;
    }

    let input = options.input.ok_or_else(|| {
        DriverError::new(
            error_codes::Code::MissingOptionValue,
            "no input file (try `archx --help`)",
        )
    })?;

    if !has_valid_archx_extension(&input) {
        return Err(DriverError::new(
            error_codes::Code::UnknownOption,
            format!(
                "invalid source file extension for `{}` (expected `.archx.lang`, `.archx.lg`, `.ax.lang`, or `.ax.lg`)",
                input.display()
            ),
        ));
    }

    let source = fs::read_to_string(&input).map_err(|error| {
        DriverError::new(
            error_codes::Code::UnreadableInput,
            format!("cannot read `{}`: {error}", input.display()),
        )
    })?;

    // The dialect is a checked, per-module decision: a module without a directive is an error, and
    // `--dialect` can only override a directive that is present.
    let declared = match dialect::parse_directive(&source) {
        Ok(Some(spec)) => spec,
        Ok(None) => {
            return Err(source_failure(
                &source,
                &input,
                &dialect::missing_directive_for(&source),
                json,
            ))
        }
        Err(diagnostic) => return Err(source_failure(&source, &input, &diagnostic, json)),
    };
    let spec = match options.dialect {
        Some(over) if over != declared.dialect => dialect::DialectSpec {
            dialect: over,
            version: declared.version,
            source: dialect::DialectSource::Cli,
        },
        _ => declared,
    };

    let tokens = lexer::Lexer::new(&source)
        .tokenize()
        .map_err(|diagnostic| source_failure(&source, &input, &diagnostic, json))?;

    let mut parser = parser::Parser::new(tokens, spec.dialect);
    let mut program = parser
        .parse_program()
        .map_err(|diagnostic| source_failure(&source, &input, &diagnostic, json))?;
    program.dialect = spec;

    let ir = codegen::lower_with_source(&program, Some(&source_name_for_debug(&input)))
        .map_err(|diagnostic| source_failure(&source, &input, &diagnostic, json))?;

    if options.emit_ir {
        print!("{ir}");
        return Ok(0);
    }

    let output = options
        .output
        .unwrap_or_else(|| default_output(&input));

    if paths_refer_to_same_file(&input, &output) {
        return Err(DriverError::new(
            error_codes::Code::OutputWouldClobberSource,
            format!(
                "refusing to overwrite source file `{}` with `-o`",
                input.display()
            ),
        ));
    }

    let clang = find_clang().ok_or_else(|| {
        DriverError::new(
            error_codes::Code::ToolchainFailed,
            "no `clang` found. Archx emits LLVM IR and uses clang to compile it.\n\
             Install clang (for example `apt install clang` or `brew install llvm`) and make sure it is on PATH,\n\
             or set ARCHX_CC=/path/to/clang.",
        )
    })?;

    let ir_path = write_exclusive_temp_ir(&ir).map_err(|message| {
        DriverError::new(error_codes::Code::TemporaryFileFailed, message)
    })?;

    let mut clang_cmd = Command::new(&clang);
    clang_cmd
        .arg(&ir_path)
        // The module carries the *source* name (`codegen::lower_with_source`), not the temp path:
        // clang names the object's file symbol after its input, which would otherwise make every
        // binary different (a fresh PID in the temp name) and embed a sandbox path in a shipped
        // executable. See AX-012 and `ci/reproducibility.sh`.
        .arg(&options.opt_level)
        // One IEEE-754 operation per source operation. Recent clang makes contraction
        // (`a*b+c` -> `fma`) the default even at `-O2`, which changes the *last bits* of any
        // floating-point result versus Python, Rust, and the interpreter-style evaluation this
        // language promises. Pinning it off keeps every edition bit-identical.
        .arg("-ffp-contract=off")
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

    let status = clang_res.map_err(|error| {
        DriverError::new(
            error_codes::Code::ToolchainFailed,
            format!("failed to run `{}`: {error}", clang.display()),
        )
    })?;

    if !status.success() {
        return Err(DriverError::new(
            error_codes::Code::ToolchainFailed,
            "clang failed to compile generated LLVM IR",
        ));
    }

    if options.run {
        let run_path = if output.parent().map_or(true, |p| p.as_os_str().is_empty()) {
            PathBuf::from(".").join(&output)
        } else {
            output.clone()
        };
        let status = Command::new(&run_path)
            .status()
            .map_err(|error| {
                DriverError::new(
                    error_codes::Code::ToolchainFailed,
                    format!("failed to run `{}`: {error}", run_path.display()),
                )
            })?;
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

/// The name recorded in the object as the module's file, so build output does not depend on where the
/// intermediate `.ll` happened to live.
fn source_name_for_debug(input: &Path) -> String {
    input
        .file_name()
        .map(|name| name.to_string_lossy().to_string())
        .unwrap_or_else(|| "archx-module".to_string())
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

/// Turns a source diagnostic into the driver's error type.
///
/// In human format the rendered snippet is the message, so the text a user sees is unchanged. In JSON
/// format a single object carries the code, span and file instead, because a multi-line snippet is
/// useless to a tool.
fn source_failure(
    source: &str,
    input: &Path,
    diagnostic: &diag::Diagnostic,
    json: bool,
) -> DriverError {
    let code = diagnostic.code.unwrap_or(error_codes::Code::InternalInvariant);
    if json {
        DriverError::rendered(
            code,
            diagnostic_json(
                code,
                "error",
                &diagnostic.message,
                Some(&input.display().to_string()),
                Some(diagnostic.span),
            ),
        )
    } else {
        DriverError::rendered(code, render_error(source, diagnostic))
    }
}

fn render_error(source: &str, diagnostic: &diag::Diagnostic) -> String {
    let line = source
        .lines()
        .nth(diagnostic.span.line.saturating_sub(1))
        .unwrap_or("");

    let mut out = String::new();
    // The code leads, because it is what users search for and what `--message-format=json` reports.
    // A message that already begins with its code (the dialect layer) is not prefixed twice.
    if diagnostic.message.starts_with(diagnostic.code_str()) {
        out.push_str(&format!("error: {}\n", diagnostic.message));
    } else {
        out.push_str(&format!(
            "error[{}]: {}\n",
            diagnostic.code_str(),
            diagnostic.message
        ));
    }
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
    println!("    -O <0|1|2|3|s>        clang optimisation level (default `-O2`, see docs/USAGE.md)");
    println!("    --dialect <compat|native>  override the module's dialect directive");
    println!("    --message-format=json  emit diagnostics as one JSON object per line on stderr");
    println!("    --explain [CODE]      explain an error code, or list them all");
    println!("    --dialect-matrix      print every compat/native divergence the compiler decides");
    println!("    explain-perf [--min-tier=static|iterator|any|heap|unwind] <file>");
    println!("                          show what each expression costs and how to make it cheaper");
    println!("    check --against-python [--format=junit] [--output=FILE] <path>...");
    println!("                          run CPython on the same file and compare stdout (see docs/USAGE.md)");
    println!("    --emit-ir             print the generated LLVM IR and exit");
    println!("    --run                 compile, then run the resulting program");
    println!("    --dialect <name>      override the module's `# archx: dialect=…` (compat|native)");
    println!("    -h, --help            show this help");
    println!("    -V, --version         show the version");
}

/// `archx check --against-python <path>...`: the compat gate (AX-017).
///
/// Compiles every file, runs it next to CPython on the same bytes, and compares stdout. Exits 0 only
/// when everything that ran agreed; 2 when nothing could be compared, so a machine without `python3`
/// cannot silently pass.
fn check_command(args: &[String]) -> Result<i32, DriverError> {
    let mut files: Vec<PathBuf> = Vec::new();
    let mut format = check::Format::Human;
    let mut output: Option<PathBuf> = None;
    let mut against_python = false;
    let mut i = 0;
    while i < args.len() {
        let arg = args[i].as_str();
        match arg {
            "--against-python" => against_python = true,
            "--format" => {
                i += 1;
                let name = args.get(i).ok_or_else(|| {
                    DriverError::new(
                        error_codes::Code::MissingOptionValue,
                        "missing value after `--format`",
                    )
                })?;
                format = check::Format::parse(name).ok_or_else(|| {
                    DriverError::new(
                        error_codes::Code::UnknownOption,
                        format!("unknown format `{name}` (expected `human` or `junit`)"),
                    )
                })?;
            }
            "--output" => {
                i += 1;
                let path = args.get(i).ok_or_else(|| {
                    DriverError::new(
                        error_codes::Code::MissingOptionValue,
                        "missing value after `--output`",
                    )
                })?;
                output = Some(PathBuf::from(path));
            }
            other if other.starts_with("--format=") => {
                let name = &other["--format=".len()..];
                format = check::Format::parse(name).ok_or_else(|| {
                    DriverError::new(
                        error_codes::Code::UnknownOption,
                        format!("unknown format `{name}` (expected `human` or `junit`)"),
                    )
                })?;
            }
            other if other.starts_with("--output=") => {
                output = Some(PathBuf::from(&other["--output=".len()..]));
            }
            other if other.starts_with('-') => {
                return Err(DriverError::new(
                    error_codes::Code::UnknownOption,
                    format!("unknown option `{other}` for `check`"),
                ));
            }
            other => files.push(PathBuf::from(other)),
        }
        i += 1;
    }

    if !against_python {
        return Err(DriverError::new(
            error_codes::Code::UnknownOption,
            "`archx check` needs a reference implementation: `--against-python`",
        ));
    }
    if files.is_empty() {
        return Err(DriverError::new(
            error_codes::Code::MissingOptionValue,
            "`archx check` needs at least one file or directory",
        ));
    }

    let files = check::collect(&files).map_err(|error| {
        DriverError::new(error_codes::Code::UnreadableInput, format!("{error}"))
    })?;

    // The compiler under test is this binary, so the gate can never test a different build than the
    // one the user invoked.
    let self_path = env::current_exe().map_err(|error| {
        DriverError::new(
            error_codes::Code::UnreadableInput,
            format!("cannot locate this compiler: {error}"),
        )
    })?;
    let work_dir = env::temp_dir().join(format!("archx-check-{}", std::process::id()));
    let (exit, text) = check::run(&self_path, &files, &work_dir, format);
    let _ = std::fs::remove_dir_all(&work_dir);

    match output {
        Some(path) => {
            std::fs::write(&path, text).map_err(|error| {
                DriverError::new(
                    error_codes::Code::UnreadableInput,
                    format!("cannot write `{}`: {error}", path.display()),
                )
            })?;
            println!("wrote {} (exit code {exit})", path.display());
        }
        None => print!("{text}"),
    }
    Ok(exit)
}

/// `archx explain-perf <file>`: tier annotation with a concrete fix per note (AX-018).
///
/// Runs the front end only — no clang, no linking — so it is fast enough to use as a save hook, and it
/// works on a module that does not build yet (the point is to show what *would* be slow).
fn explain_perf_command(args: &[String], json: bool) -> Result<i32, DriverError> {
    let mut files: Vec<PathBuf> = Vec::new();
    let mut min_tier: Option<explain_perf::Tier> = None;
    for arg in args {
        if let Some(name) = arg.strip_prefix("--min-tier=") {
            min_tier = Some(explain_perf::Tier::parse(name).ok_or_else(|| {
                DriverError::new(
                    error_codes::Code::UnknownOption,
                    format!(
                        "unknown tier `{name}` (expected `static`, `iterator`, `any`, `heap`, or `unwind`)"
                    ),
                )
            })?);
        } else if arg == "--min-tier" {
            return Err(DriverError::new(
                error_codes::Code::MissingOptionValue,
                "`--min-tier` needs a value, for example `--min-tier=any`",
            ));
        } else if arg.starts_with('-') {
            return Err(DriverError::new(
                error_codes::Code::UnknownOption,
                format!("unknown option `{arg}` for `explain-perf`"),
            ));
        } else {
            files.push(PathBuf::from(arg));
        }
    }
    let input = match files.as_slice() {
        [one] => one.clone(),
        [] => {
            return Err(DriverError::new(
                error_codes::Code::UnreadableInput,
                "`explain-perf` needs a source file",
            ))
        }
        _ => {
            return Err(DriverError::new(
                error_codes::Code::MultipleInputs,
                "`explain-perf` takes one source file at a time",
            ))
        }
    };
    if !has_valid_archx_extension(&input) {
        return Err(DriverError::new(
            error_codes::Code::UnreadableInput,
            format!(
                "invalid source file extension for `{}` (expected `.archx.lang`, `.archx.lg`, `.ax.lang`, or `.ax.lg`)",
                input.display()
            ),
        ));
    }

    let source = std::fs::read_to_string(&input).map_err(|error| {
        DriverError::new(
            error_codes::Code::UnreadableInput,
            format!("cannot read `{}`: {error}", input.display()),
        )
    })?;

    // A module without a directive would be rejected by the compiler; for a cost report we only need the
    // syntax, so the dialect is taken from the directive when present and assumed `native` otherwise.
    // `native` is the right assumption: the command exists to suggest native fixes.
    let spec = match dialect::parse_directive(&source) {
        Ok(Some(spec)) => spec,
        _ => dialect::DialectSpec {
            dialect: dialect::Dialect::Native,
            version: 1,
            source: dialect::DialectSource::Cli,
        },
    };

    let tokens = lexer::Lexer::new(&source)
        .tokenize()
        .map_err(|diagnostic| source_failure(&source, &input, &diagnostic, json))?;
    let mut parser = parser::Parser::new(tokens, spec.dialect);
    let mut program = parser
        .parse_program()
        .map_err(|diagnostic| source_failure(&source, &input, &diagnostic, json))?;
    program.dialect = spec;

    let report = explain_perf::analyze(&program, &source);
    if json {
        // One object per note, the same shape as `--message-format=json`, so an editor treats a cost note
        // exactly like a diagnostic.
        for note in report.filtered(min_tier) {
            println!(
                "{{\"severity\":\"note\",\"tier\":\"{}\",\"file\":\"{}\",\"line\":{},\"column\":{},\"message\":\"{}\",\"why\":\"{}\",\"fix\":\"{}\"}}",
                note.tier.label(),
                input.display(),
                note.line,
                note.col,
                json_escape(&note.construct),
                json_escape(&note.why),
                json_escape(&note.fix)
            );
        }
    } else {
        print!("{}", explain_perf::render(&report, min_tier));
    }
    Ok(0)
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
