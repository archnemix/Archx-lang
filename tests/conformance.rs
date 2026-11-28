//! Differential conformance harness (AX-007): compile each probe with `archx`, run it next to
//! `python3` on the same bytes, and compare stdout byte-for-byte.
//!
//! A probe is legal Python *and* legal Archx: line 1 is the dialect directive, which Python reads as a
//! comment. That is the whole point — the two implementations never see two hand-written programs.
//!
//! A probe that Archx cannot reproduce yet carries `# conformance: xfail <reason>` on line 2. The
//! reason is mandatory and is published in `conformance.md`/`docs/LIMITATIONS.md`, so a known gap is
//! documented rather than silently skipped; an xfail probe that *starts* passing fails the run, which
//! keeps the limitations list from growing stale in the other direction.

use std::fs;
use std::path::{Path, PathBuf};
use std::process::Command;

/// Everything the run learned, so one test can publish the report.
#[derive(Default)]
struct Report {
    matched: Vec<String>,
    diverged: Vec<(String, String)>,
    xfail: Vec<(String, String)>,
    xpass: Vec<String>,
    skipped: Vec<(String, String)>,
}

fn root() -> PathBuf {
    Path::new(env!("CARGO_MANIFEST_DIR")).to_path_buf()
}

fn archx_bin() -> PathBuf {
    // `cargo test` puts integration test binaries in `target/<profile>/deps`; the compiler is two
    // levels up. ARCHX_BIN overrides this for a release build or a system install.
    if let Ok(path) = std::env::var("ARCHX_BIN") {
        return PathBuf::from(path);
    }
    let mut dir = std::env::current_exe().expect("test binary path");
    dir.pop();
    if dir.ends_with("deps") {
        dir.pop();
    }
    dir.join(if cfg!(windows) { "archx.exe" } else { "archx" })
}

fn have_clang() -> bool {
    Command::new(std::env::var("ARCHX_CC").unwrap_or_else(|_| "clang".to_string()))
        .arg("--version")
        .output()
        .map(|o| o.status.success())
        .unwrap_or(false)
}

fn have_python() -> bool {
    Command::new("python3")
        .arg("--version")
        .output()
        .map(|o| o.status.success())
        .unwrap_or(false)
}

/// Reads the probe's expectation marker, if any.
fn xfail_reason(source: &str) -> Option<String> {
    let second = source.lines().nth(1)?;
    second
        .strip_prefix("# conformance: xfail ")
        .map(|reason| reason.trim().to_string())
}

fn normalise(bytes: &[u8]) -> String {
    String::from_utf8_lossy(bytes).replace("\r\n", "\n")
}

/// Compares the two implementations on one probe. Returns `Ok(())` when they agree.
fn compare(archx: &Path, probe: &Path, work: &Path) -> Result<(), String> {
    let stem = probe.file_stem().unwrap().to_string_lossy().to_string();

    let python = Command::new("python3")
        .arg(probe)
        .output()
        .map_err(|e| format!("cannot run python3: {e}"))?;
    if !python.status.success() {
        return Err(format!(
            "python3 itself failed (probe is not valid Python): {}",
            String::from_utf8_lossy(&python.stderr)
        ));
    }

    // `.py` is not an Archx extension, so the source is copied under one. The bytes are untouched.
    let source = fs::read_to_string(probe).map_err(|e| format!("cannot read probe: {e}"))?;
    let archx_src = work.join(format!("{stem}.archx.lang"));
    fs::write(&archx_src, &source).map_err(|e| format!("cannot stage probe: {e}"))?;

    let exe = work.join(&stem);
    let build = Command::new(archx)
        .arg(&archx_src)
        .arg("-o")
        .arg(&exe)
        .output()
        .map_err(|e| format!("cannot run archx: {e}"))?;
    if !build.status.success() {
        return Err(format!(
            "archx rejected the program: {}",
            String::from_utf8_lossy(&build.stderr).trim()
        ));
    }

    let run = Command::new(&exe)
        .output()
        .map_err(|e| format!("cannot run the compiled probe: {e}"))?;
    if !run.status.success() {
        return Err(format!(
            "compiled program exited with {:?}: {}",
            run.status.code(),
            normalise(&run.stdout).trim()
        ));
    }

    let want = normalise(&python.stdout);
    let got = normalise(&run.stdout);
    if want == got {
        Ok(())
    } else {
        Err(format!("stdout differs\n--- python3 ---\n{want}--- archx ---\n{got}"))
    }
}

#[test]
fn conformance_probes_match_cpython() {
    let archx = archx_bin();
    assert!(
        archx.is_file(),
        "no archx binary at {} — run `cargo build` first",
        archx.display()
    );

    let probe_dir = root().join("tests").join("conformance");
    let mut probes: Vec<PathBuf> = fs::read_dir(&probe_dir)
        .expect("tests/conformance exists")
        .filter_map(|e| e.ok().map(|e| e.path()))
        .filter(|p| p.extension().is_some_and(|x| x == "py"))
        .collect();
    probes.sort();
    assert!(
        probes.len() >= 94,
        "the harness must cover at least the 94 audit probes, found {}",
        probes.len()
    );

    let work = std::env::temp_dir().join(format!("archx-conformance-{}", std::process::id()));
    let _ = fs::remove_dir_all(&work);
    fs::create_dir_all(&work).expect("create the work directory");

    let mut report = Report::default();

    if !have_python() {
        for probe in &probes {
            report
                .skipped
                .push((name_of(probe), "python3 not on PATH".to_string()));
        }
        publish(&report, probes.len());
        eprintln!("skipping: python3 not found");
        return;
    }
    if !have_clang() {
        for probe in &probes {
            report
                .skipped
                .push((name_of(probe), "clang not on PATH".to_string()));
        }
        publish(&report, probes.len());
        eprintln!("skipping: clang not found");
        return;
    }

    for probe in &probes {
        let name = name_of(probe);
        let source = fs::read_to_string(probe).unwrap_or_default();
        let expected_gap = xfail_reason(&source);
        match (compare(&archx, probe, &work), expected_gap) {
            (Ok(()), None) => report.matched.push(name),
            (Ok(()), Some(reason)) => {
                report.xpass.push(name);
                let _ = reason;
            }
            (Err(why), Some(reason)) => report.xfail.push((name, format!("{reason} ({why})"))),
            (Err(why), None) => report.diverged.push((name, why)),
        }
    }

    publish(&report, probes.len());
    let _ = fs::remove_dir_all(&work);

    let total = report.matched.len() + report.diverged.len();
    let mut problems = Vec::new();
    if !report.diverged.is_empty() {
        problems.push(format!("{} undocumented divergence(s)", report.diverged.len()));
    }
    if !report.xpass.is_empty() {
        problems.push(format!(
            "{} probe(s) marked xfail now pass — remove the marker",
            report.xpass.len()
        ));
    }
    let mut detail = String::new();
    for (name, why) in &report.diverged {
        detail.push_str(&format!("  {name}: {why}\n"));
    }
    for name in &report.xpass {
        detail.push_str(&format!("  {name}: marked xfail but now matches CPython\n"));
    }
    assert!(
        problems.is_empty(),
        "{}\nsee conformance.md for per-probe detail\n{detail}",
        problems.join(", ")
    );
    eprintln!(
        "conformance: {} of {} reproducible probes match CPython, {} documented gaps",
        report.matched.len(),
        total,
        report.xfail.len()
    );
}

fn name_of(probe: &Path) -> String {
    probe.file_stem().unwrap().to_string_lossy().to_string()
}

/// Writes `conformance.md` next to the probes, so the counts CI printed are also in the repo.
fn publish(report: &Report, total: usize) {
    let reproducible = report.matched.len() + report.diverged.len();
    let mut out = String::new();
    out.push_str("# Conformance report\n\n");
    out.push_str(
        "<!-- Generated by `cargo test --test conformance` (AX-007). Every probe in `tests/conformance/`\n\
         is one file that is legal Python and legal Archx; the same bytes are run by `python3` and\n\
         compiled by `archx`, and stdout is compared byte-for-byte. Do not edit by hand. -->\n\n",
    );
    out.push_str(&format!("* probes: {total}\n"));
    out.push_str(&format!("* match CPython: {}\n", report.matched.len()));
    out.push_str(&format!("* diverged: {}\n", report.diverged.len()));
    out.push_str(&format!("* documented gaps (xfail): {}\n", report.xfail.len()));
    out.push_str(&format!("* unexpected passes (xpass): {}\n", report.xpass.len()));
    out.push_str(&format!("* skipped: {}\n\n", report.skipped.len()));
    if reproducible > 0 {
        out.push_str(&format!(
            "Reproducible probes matching CPython: **{:.1}%** ({} of {}).\n\n",
            100.0 * report.matched.len() as f64 / reproducible as f64,
            report.matched.len(),
            reproducible
        ));
    }

    if !report.diverged.is_empty() {
        out.push_str("## Diverged (must be fixed or marked xfail)\n\n");
        for (name, why) in &report.diverged {
            out.push_str(&format!("* `{name}`\n\n  ```\n  {}\n  ```\n", why.replace('\n', "\n  ")));
        }
        out.push('\n');
    }
    if !report.xpass.is_empty() {
        out.push_str("## Unexpected passes (remove the `xfail` marker)\n\n");
        for name in &report.xpass {
            out.push_str(&format!("* `{name}`\n"));
        }
        out.push('\n');
    }
    if !report.xfail.is_empty() {
        out.push_str("## Documented gaps\n\n");
        for (name, why) in &report.xfail {
            out.push_str(&format!("* `{name}` — {}\n", why.replace('\n', " ")));
        }
        out.push('\n');
    }
    if !report.skipped.is_empty() {
        out.push_str("## Skipped\n\n");
        for (name, why) in &report.skipped {
            out.push_str(&format!("* `{name}` — {why}\n"));
        }
        out.push('\n');
    }

    let path = root().join("tests").join("conformance").join("conformance.md");
    let _ = fs::write(path, out);
}
