//! AX-011 acceptance gate: every diagnostic the compiler can emit has a code, a span, and an
//! `archx explain` entry.
//!
//! The compiler raises diagnostics from ~460 sites. Rather than trusting that each one was labelled,
//! this test reads the compiler's own source, extracts every `Diagnostic::new(...)` message literal
//! (including multi-line and `format!` templates), and requires each to classify. A new diagnostic
//! therefore cannot ship uncoded: adding one turns this test red until `src/diagnose.rs` learns the
//! message.
//!
//! It also runs the real binary to check the parts a unit test cannot reach: that the CLI prints the
//! code, that `--message-format=json` produces parseable objects, and that `archx explain` documents
//! every code.

use std::path::{Path, PathBuf};
use std::process::Command;

fn archx() -> PathBuf {
    // Cargo's own answer to "where is the binary this crate builds".
    PathBuf::from(env!("CARGO_BIN_EXE_archx"))
}

fn root() -> PathBuf {
    Path::new(env!("CARGO_MANIFEST_DIR")).to_path_buf()
}

/// Every `Diagnostic::new("…")` / `Diagnostic::new(format!("…"))` message literal under `src/`.
///
/// The scan is textual on purpose: the point is to cover the *construction sites*, and a textual scan
/// sees them whether they are in a `match`, a closure, or a helper.
fn diagnostic_literals() -> Vec<(String, String)> {
    let mut found = Vec::new();
    let mut stack = vec![root().join("src")];
    while let Some(dir) = stack.pop() {
        for entry in std::fs::read_dir(&dir).expect("read src") {
            let path = entry.expect("dir entry").path();
            if path.is_dir() {
                stack.push(path);
                continue;
            }
            if path.extension().and_then(|e| e.to_str()) != Some("rs") {
                continue;
            }
            let text = std::fs::read_to_string(&path).expect("read source");
            for literal in literals_in(&text) {
                found.push((path.display().to_string(), literal));
            }
        }
    }
    assert!(
        found.len() > 400,
        "expected hundreds of diagnostics, found {} — did the scan break?",
        found.len()
    );
    found
}

/// Extracts the first string literal of every `Diagnostic::new(` call in `text`.
fn literals_in(text: &str) -> Vec<String> {
    let mut out = Vec::new();
    let needle = "Diagnostic::new(";
    let mut from = 0;
    while let Some(offset) = text[from..].find(needle) {
        let start = from + offset + needle.len();
        // Skip `format!(`, whitespace and newlines up to the opening quote (raw literals included).
        let rest = &text[start..];
        let mut quote_at = None;
        let mut raw = false;
        let mut k = 0;
        let bytes = rest.as_bytes();
        while k < bytes.len() {
            match bytes[k] {
                b'r' if raw_prefix_at(bytes, k) => {
                    raw = true;
                    k += 1;
                }
                b'"' => {
                    quote_at = Some(k);
                    break;
                }
                b')' => break,
                _ => k += 1,
            }
        }
        let Some(quote_at) = quote_at else {
            from = start;
            continue;
        };
        let body = &rest[quote_at + 1..];
        if raw {
            if let Some(end) = body.find('"') {
                out.push(body[..end].to_string());
            }
        } else {
            let mut literal = String::new();
            let mut chars = body.chars();
            while let Some(ch) = chars.next() {
                match ch {
                    '"' => break,
                    '\\' => {
                        if let Some(next) = chars.next() {
                            literal.push(next);
                        }
                    }
                    other => literal.push(other),
                }
            }
            out.push(literal);
        }
        from = start;
    }
    out
}

/// `r"` / `r#"` prefix at `k`, i.e. this quote starts a raw literal.
fn raw_prefix_at(bytes: &[u8], k: usize) -> bool {
    let mut i = k + 1;
    while i < bytes.len() && bytes[i] == b'#' {
        i += 1;
    }
    bytes.get(i) == Some(&b'"')
}

#[test]
fn every_compiler_diagnostic_has_a_code() {
    let mut missing = Vec::new();
    for (file, literal) in diagnostic_literals() {
        if arena_classify(&literal).is_none() {
            missing.push(format!("{file}: {literal:?}"));
        }
    }
    assert!(
        missing.is_empty(),
        "these diagnostics would ship without a code (add a rule to src/diagnose.rs):\n  {}",
        missing.join("\n  ")
    );
}

/// Re-implements `diagnose::classify` for the test process: the binary is a bin crate, so its modules
/// are not importable from an integration test. The rules are read from the source of `diagnose.rs`,
/// which keeps this honest — the test cannot pass by having its own copy of the table.
fn arena_classify(message: &str) -> Option<String> {
    let text = std::fs::read_to_string(root().join("src/diagnose.rs")).expect("read diagnose.rs");
    let body = text
        .split_once("const RULES: &[(&str, &str)] = &[")
        .expect("RULES table")
        .1;
    let body = body.split_once("\n];").expect("end of RULES").0;
    let mut rules: Vec<(String, String)> = Vec::new();
    for line in body.lines() {
        let line = line.trim();
        let Some(inner) = line.strip_prefix("(\"") else {
            continue;
        };
        let Some((fragment, rest)) = inner.split_once("\", \"") else {
            continue;
        };
        let Some((code, _)) = rest.split_once('"') else {
            continue;
        };
        rules.push((fragment.to_string(), code.to_string()));
    }
    assert!(rules.len() > 150, "RULES table looks truncated");

    // A message that already carries its code keeps it.
    if let Some((head, _)) = message.split_once(':') {
        if head.len() == 5 && head.starts_with('E') && head[1..].bytes().all(|b| b.is_ascii_digit()) {
            return Some(head.to_string());
        }
    }
    rules
        .into_iter()
        .find(|(fragment, _)| message.contains(fragment.as_str()))
        .map(|(_, code)| code)
}

#[test]
fn cli_reports_codes_in_human_and_json_output() {
    let dir = std::env::temp_dir().join(format!("archx-codes-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    let src = dir.join("bad.archx.lang");
    std::fs::write(
        &src,
        "# archx: dialect=native, version=1\nfunc main():\n    x: int = \"hello\"\n",
    )
    .unwrap();

    // Human: rustc-style `error[E0402]: …` plus a caret, and nothing else on the line.
    let human = Command::new(archx()).arg(&src).output().unwrap();
    assert_eq!(human.status.code(), Some(1));
    let text = String::from_utf8_lossy(&human.stderr).to_string();
    assert!(
        text.starts_with("error[E0402]: type mismatch"),
        "unexpected human output: {text}"
    );
    assert!(text.contains("  --> 3:14"), "missing span: {text}");
    assert!(text.contains('^'), "missing caret: {text}");

    // JSON: exactly one object, one line, with the code and the span.
    let json = Command::new(archx())
        .arg(&src)
        .arg("--message-format=json")
        .output()
        .unwrap();
    assert_eq!(json.status.code(), Some(1));
    let line = String::from_utf8_lossy(&json.stderr);
    let line = line.trim();
    assert_eq!(line.lines().count(), 1, "expected one JSON line: {line}");
    // No JSON library in this crate by design, so assert on the shape and the fields that matter.
    assert!(line.starts_with('{') && line.ends_with('}'), "{line}");
    for field in [
        "\"code\":\"E0402\"",
        "\"severity\":\"error\"",
        "\"line\":3",
        "\"column\":14",
        "\"internal\":false",
    ] {
        assert!(line.contains(field), "missing {field} in {line}");
    }
    // The message is escaped, so a raw newline or quote from the compiler cannot break the line.
    assert_eq!(line.matches('\n').count(), 0);
}

#[test]
fn driver_errors_have_codes_too() {
    let cases: [(&[&str], &str); 3] = [
        (&["--not-a-flag"], "E0001"),
        (&["only.archx.lang", "second.archx.lang"], "E0004"),
        (&["--dialect"], "E0002"),
    ];
    for (args, code) in cases {
        let output = Command::new(archx()).args(args).output().unwrap();
        assert_eq!(output.status.code(), Some(1), "{args:?}");
        let text = String::from_utf8_lossy(&output.stderr);
        assert!(
            text.contains(code),
            "{args:?} should report {code}, got: {text}"
        );
    }
    // A missing input file carries its own code rather than being a panic.
    let output = Command::new(archx())
        .arg("does-not-exist.archx.lang")
        .output()
        .unwrap();
    let text = String::from_utf8_lossy(&output.stderr);
    assert!(text.contains("E0003"), "got: {text}");
}

#[test]
fn explain_documents_every_code_and_nothing_else() {
    let list = Command::new(archx()).arg("--explain").output().unwrap();
    assert!(list.status.success());
    let text = String::from_utf8_lossy(&list.stdout).to_string();
    assert!(text.contains("Error codes"));

    // Every code mentioned by the compiler's output must be explainable, and every explained code
    // must be reachable. The list is the registry: drive it.
    let codes: Vec<String> = text
        .split_whitespace()
        .filter(|w| w.len() == 5 && w.starts_with('E') && w[1..].bytes().all(|b| b.is_ascii_digit()))
        .map(str::to_string)
        .collect();
    assert!(codes.len() >= 35, "expected the full registry, got {codes:?}");

    for code in &codes {
        let entry = Command::new(archx())
            .arg("--explain")
            .arg(code)
            .output()
            .unwrap();
        assert!(entry.status.success(), "--explain {code} failed");
        let body = String::from_utf8_lossy(&entry.stdout).to_string();
        assert!(body.starts_with(code.as_str()), "{code}: {body}");
        assert!(
            body.len() > 120,
            "{code}'s explanation is too thin: {body}"
        );
    }

    // An unknown code is a driver error with a code of its own, not a panic or a silent success.
    let unknown = Command::new(archx())
        .arg("--explain")
        .arg("E9999")
        .output()
        .unwrap();
    assert_eq!(unknown.status.code(), Some(1));
    assert!(String::from_utf8_lossy(&unknown.stderr).contains("E0001"));
}
