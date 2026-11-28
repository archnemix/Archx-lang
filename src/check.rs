//! `archx check --against-python`: the compat gate (AX-017).
//!
//! The differential conformance harness (`tests/conformance.rs`) proves that the *probes* match
//! CPython. This module puts the same ability in the compiler, so a user can ask the question about
//! their own file before committing it:
//!
//! ```text
//! archx check --against-python examples/comparison/full_tour.archx.lang
//! ```
//!
//! It compiles the module, runs both the native executable and `python3` on the same path, and
//! compares stdout byte for byte. The verdict names the **dialect rule** that explains a difference
//! where one exists (see `dialect_rules`), because "your output differs on line 3" is much less useful
//! than "your output differs on line 3, and `bool repr` is a known divergence".
//!
//! Non-negotiables, because a conformance gate that lies is worse than none:
//!
//! * **Only stdout is compared.** stderr and the exit code are reported but not judged: a compat
//!   module is *supposed* to trap where CPython would raise (that is the `runtime failure` row), and
//!   treating that as a failure would make the gate useless for the programs people actually write.
//! * **A missing `python3` is a skip, not a pass.** Exit code 2 and an explicit message, so a CI step
//!   can tell "everything agreed" from "nothing ran".
//! * **A file that does not compile is a failure of the check, not a divergence.** The compiler's own
//!   diagnostics are printed and the comparison never happens.

use std::fs;
use std::fmt::Write as _;
use std::path::{Path, PathBuf};
use std::process::Command;

/// The outcome of comparing one file against CPython.
#[derive(Debug, PartialEq, Eq)]
pub enum Verdict {
    /// Both produced the same stdout.
    Match,
    /// Both ran, and stdout differs.
    Diverged(Divergence),
    /// The module did not compile, so there was nothing to run.
    DidNotCompile,
    /// The probe is marked `# conformance: xfail <reason>` and still differs, as documented.
    KnownGap(String),
    /// The probe is marked `xfail` but now matches CPython: the marker is stale and must be removed.
    UnexpectedPass,
    /// The comparison could not be performed.
    Unavailable(String),
}

/// What differs, in the terms a user can act on.
#[derive(Debug, PartialEq, Eq)]
pub struct Divergence {
    /// 1-based line of stdout where the two first disagree, or `None` for a length mismatch with a
    /// common prefix.
    pub line: Option<usize>,
    /// The text CPython printed on that line.
    pub python: String,
    /// The text Archx printed on that line.
    pub archx: String,
    /// The dialect rule that plausibly explains it, when the *values* alone identify one.
    pub rule: Option<&'static str>,
    /// Both stdouts, so the caller can show more context than one line.
    pub python_stdout: String,
    pub archx_stdout: String,
}

/// Everything the check observed, for reporting.
#[derive(Debug)]
pub struct Report {
    pub path: PathBuf,
    pub verdict: Verdict,
    /// The `python3` version string, when it ran.
    pub python_version: Option<String>,
    /// Archx's exit code and stderr, reported but not judged.
    pub archx_status: Option<i32>,
    pub archx_stderr: String,
    /// True when the file declared no dialect, so the check assumed `compat`.
    ///
    /// Stated in the output rather than done silently: the user asked for a comparison with CPython, so
    /// the `compat` contract is the right assumption, but a check that quietly compiles a file under a
    /// different contract than its author intended would be lying about what it verified.
    pub assumed_compat: bool,
}

impl Report {
    /// Exit code for the driver: 0 match, 1 divergence or compile failure, 2 cannot compare.
    pub fn exit_code(&self) -> i32 {
        match self.verdict {
            Verdict::Match | Verdict::KnownGap(_) => 0,
            Verdict::Diverged(_) | Verdict::DidNotCompile | Verdict::UnexpectedPass => 1,
            Verdict::Unavailable(_) => 2,
        }
    }
}

/// Runs `python3 --version`, returning the version text when it is available.
pub fn python_version() -> Option<String> {
    let out = Command::new("python3").arg("--version").output().ok()?;
    if !out.status.success() {
        return None;
    }
    let text = String::from_utf8_lossy(&out.stdout).trim().to_string();
    let text = if text.is_empty() {
        String::from_utf8_lossy(&out.stderr).trim().to_string()
    } else {
        text
    };
    Some(text)
}

/// Picks the rule that most plausibly explains a difference between two lines.
///
/// This is a *hint*, and it is deliberately narrow: it only names a rule when the two strings differ
/// in the way that rule predicts. A wrong hint is worse than no hint, so each test is a concrete
/// shape rather than "the output differs, so blame the dialect".
fn attribute(python: &str, archx: &str, dialect_compat: bool) -> Option<&'static str> {
    let py = python.trim();
    let ax = archx.trim();

    // bool repr: same words, different case/spelling.
    let python_words = ["True", "False"];
    let systems_words = ["true", "false"];
    if python_words
        .iter()
        .zip(systems_words.iter())
        .any(|(p, s)| py.contains(p) && ax.contains(s) && py.replace(p, s) == ax)
    {
        return Some("bool repr");
    }

    // container repr: the compat contract quotes strings inside a container.
    if ax.contains('\'') {
        let unquoted: String = ax.replace('\'', "");
        if unquoted == py {
            return Some("container repr");
        }
    }
    if py.contains('\'') && py.replace('\'', "") == ax {
        return Some("container repr");
    }

    // int overflow: Archx trapped where CPython produced an arbitrary-precision value.
    if ax.contains("integer overflow") && py.parse::<i128>().is_ok() {
        return Some("int overflow");
    }

    // int division: `3.5` in one and a truncated `3` in the other.
    if let (Ok(p), Ok(a)) = (py.parse::<f64>(), ax.parse::<f64>()) {
        if (p - a).abs() < 1.0 && p != a {
            return Some("int division");
        }
    }

    // The compat contract is what promises CPython equivalence, so an unexplained difference there is
    // worth flagging more strongly than one in a native module, where divergence is documented.
    let _ = dialect_compat;
    None
}

/// Reads the probe's expectation marker: `# conformance: xfail <reason>` on line 2.
///
/// The same contract the differential harness uses (`tests/conformance.rs`): a known gap is documented
/// with a mandatory reason, and a marker that starts passing is itself a failure. Without this the
/// gate could never pass on the documented gaps, and a gate that is always red gets ignored.
pub fn xfail_reason(source: &str) -> Option<String> {
    let second = source.lines().nth(1)?;
    second
        .strip_prefix("# conformance: xfail ")
        .map(|reason| {
            let reason = reason.trim();
            if reason.is_empty() {
                "(no reason given)".to_string()
            } else {
                reason.to_string()
            }
        })
}

/// Compares one module's output against CPython.
///
/// `archx_bin` is the compiler to invoke; the caller passes its own executable path so the check
/// always tests the compiler the user is running.
pub fn against_python(archx_bin: &Path, source: &Path, work_dir: &Path) -> std::io::Result<Report> {
    let mut report = Report {
        path: source.to_path_buf(),
        verdict: Verdict::Match,
        python_version: python_version(),
        archx_status: None,
        archx_stderr: String::new(),
        assumed_compat: false,
    };

    if report.python_version.is_none() {
        report.verdict = Verdict::Unavailable("`python3` is not on PATH".to_string());
        return Ok(report);
    }

    fs::create_dir_all(work_dir)?;
    let exe = work_dir.join(format!(
        "check-{}{}",
        std::process::id(),
        if cfg!(windows) { ".exe" } else { "" }
    ));

    // A probe is legal Python *and* legal Archx, but the driver insists on an Archx extension, so the
    // same bytes are compiled under a `.archx.lang` name. Copying rather than symlinking keeps this
    // working on Windows and means neither tool ever sees a different file.
    // Read the documented-gap marker first: an `xfail` probe is *expected* not to match, whether the
    // reason is a compile-time refusal or different output, so every later failure has to consult it.
    let expected_gap = fs::read_to_string(source)
        .ok()
        .and_then(|source| xfail_reason(&source));

    // A plain `.py` file has no directive, and the driver requires one. Since the request is "does this
    // behave like CPython?", the compat contract is the right thing to compile it under — recorded in
    // the report so the output never implies the module declared it.
    let declares_dialect = fs::read_to_string(source)
        .map(|text| {
            text.lines()
                .next()
                .map(|line| line.trim_start().starts_with("# archx:"))
                .unwrap_or(false)
        })
        .unwrap_or(false);
    report.assumed_compat = !declares_dialect;

    let build_source = work_dir.join(format!("probe-{}.archx.lang", std::process::id()));
    // The language requires an explicit directive and the driver will not compile without one, so a
    // plain `.py` file gets the compat directive on the copy the compiler sees. Line numbers in the copy
    // shift by one, which is harmless: the report quotes *stdout* lines, never source spans.
    if declares_dialect {
        fs::copy(source, &build_source)?;
    } else {
        let body = fs::read_to_string(source)?;
        fs::write(
            &build_source,
            format!("# archx: dialect=compat, version=1\n{body}"),
        )?;
    }

    // Compile. A failure here is the check's failure, not a divergence: there is nothing to compare.
    let build = Command::new(archx_bin)
        .arg(&build_source)
        .arg("-o")
        .arg(&exe)
        .output()?;
    if !build.status.success() {
        report.archx_stderr = String::from_utf8_lossy(&build.stderr).to_string();
        let _ = fs::remove_file(&build_source);
        report.verdict = match expected_gap {
            Some(reason) => Verdict::KnownGap(reason),
            None => Verdict::DidNotCompile,
        };
        return Ok(report);
    }

    let archx_run = Command::new(&exe).output()?;
    report.archx_status = archx_run.status.code();
    report.archx_stderr = String::from_utf8_lossy(&archx_run.stderr).to_string();

    // The probe file's first line is a comment in Python, so the same path runs under both.
    let python_run = Command::new("python3").arg(source).output()?;
    let _ = fs::remove_file(&exe);
    let _ = fs::remove_file(&build_source);

    let archx_stdout = String::from_utf8_lossy(&archx_run.stdout).replace("\r\n", "\n");
    let python_stdout = String::from_utf8_lossy(&python_run.stdout).replace("\r\n", "\n");

    if python_run.status.code() != Some(0) && expected_gap.is_some() {
        // The probe is documented as raising (a `try`/`except` reference), so CPython failing is the
        // expected shape of the comparison, not a reason it could not be performed.
        report.verdict = Verdict::KnownGap(expected_gap.unwrap_or_default());
        return Ok(report);
    }
    if python_run.status.code() != Some(0) {
        // CPython itself failed: the file is not valid Python, so there is no reference output. That
        // is a limitation of the check, not a conformance result.
        report.verdict = Verdict::Unavailable(format!(
            "`python3` exited with {:?}: {}",
            python_run.status.code(),
            String::from_utf8_lossy(&python_run.stderr)
                .lines()
                .next()
                .unwrap_or("")
        ));
        return Ok(report);
    }

    if archx_stdout == python_stdout {
        // A documented gap that now passes is a stale marker, not a success.
        report.verdict = match expected_gap {
            Some(_) => Verdict::UnexpectedPass,
            None => Verdict::Match,
        };
        return Ok(report);
    }

    // Find the first differing line.
    let mut divergence = None;
    for (index, (py, ax)) in python_stdout
        .lines()
        .zip(archx_stdout.lines())
        .enumerate()
    {
        if py != ax {
            divergence = Some((index + 1, py.to_string(), ax.to_string()));
            break;
        }
    }
    let (line, python, archx) = match divergence {
        Some((line, py, ax)) => (Some(line), py, ax),
        None => (
            None,
            python_stdout
                .lines()
                .nth(archx_stdout.lines().count())
                .unwrap_or("")
                .to_string(),
            archx_stdout
                .lines()
                .nth(python_stdout.lines().count())
                .unwrap_or("")
                .to_string(),
        ),
    };
    let rule = attribute(&python, &archx, true);
    report.verdict = match expected_gap {
        Some(reason) => Verdict::KnownGap(reason),
        None => Verdict::Diverged(Divergence {
            line,
            python,
            archx,
            rule,
            python_stdout: python_stdout.clone(),
            archx_stdout: archx_stdout.clone(),
        }),
    };
    Ok(report)
}

/// Renders one report for a human.
pub fn render_human(report: &Report) -> String {
    let mut out = String::new();
    let name = report.path.display();
    match &report.verdict {
        Verdict::Match => {
            out.push_str(&format!("ok      {name}\n"));
            if let Some(version) = &report.python_version {
                out.push_str(&format!("        matches {version}"));
                if report.assumed_compat {
                    out.push_str(" (compiled as dialect=compat; the file declares none)");
                }
                out.push('\n');
            }
            if let Some(code) = report.archx_status {
                if code != 0 {
                    // Not a failure — a compat module traps where CPython raises — but the user should
                    // know the programs did not exit the same way.
                    out.push_str(&format!(
                        "        stdout agrees, but the process exited {code} (CPython raised; this \
                         is the `runtime failure` row of `archx --dialect-matrix`)\n"
                    ));
                }
            }
        }
        Verdict::Diverged(divergence) => {
            out.push_str(&format!("FAILED  {name}\n"));
            match divergence.line {
                Some(line) => out.push_str(&format!("        stdout differs at line {line}:\n")),
                None => out.push_str("        stdout differs in length:\n"),
            }
            out.push_str(&format!("          python3: {}\n", divergence.python));
            out.push_str(&format!("          archx:   {}\n", divergence.archx));
            match divergence.rule {
                Some(rule) => out.push_str(&format!(
                    "        this looks like the `{rule}` divergence; run `archx --dialect-matrix` \
                     for the contract\n"
                )),
                None => out.push_str(
                    "        no dialect rule predicts this difference, so it is a conformance bug\n",
                ),
            }
        }
        Verdict::KnownGap(reason) => {
            out.push_str(&format!("xfail   {name}\n        differs as documented: {reason}\n"));
        }
        Verdict::UnexpectedPass => {
            out.push_str(&format!(
                "FAILED  {name}\n        marked `xfail` but now matches CPython — remove the marker\n"
            ));
        }
        Verdict::DidNotCompile => {
            out.push_str(&format!("FAILED  {name}\n        the module does not compile:\n"));
            for line in report.archx_stderr.lines().take(6) {
                out.push_str(&format!("        {line}\n"));
            }
        }
        Verdict::Unavailable(reason) => {
            out.push_str(&format!("SKIPPED {name}\n        {reason}\n"));
        }
    }
    out
}

/// Renders one report as a JUnit `<testcase>`, so a CI run shows conformance per file.
///
/// JUnit XML rather than a bespoke format because every CI system already renders it, and because a
/// skipped test is represented natively (`<skipped/>`) instead of being indistinguishable from a pass.
pub fn render_junit(report: &Report, out: &mut String) {
    let name = xml_escape(&report.path.display().to_string());
    match &report.verdict {
        Verdict::Match => {
            let _ = writeln!(out, "    <testcase classname=\"archx.conformance\" name=\"{name}\"/>");
        }
        Verdict::Diverged(divergence) => {
            let _ = writeln!(
                out,
                "    <testcase classname=\"archx.conformance\" name=\"{name}\">"
            );
            let message = xml_escape(&format!(
                "stdout differs at line {}",
                divergence
                    .line
                    .map(|l| l.to_string())
                    .unwrap_or_else(|| "end".to_string())
            ));
            let body = xml_escape(&format!(
                "python3: {}\narchx:   {}\nrule: {}",
                divergence.python,
                divergence.archx,
                divergence.rule.unwrap_or("none — conformance bug")
            ));
            let _ = writeln!(
                out,
                "      <failure message=\"{message}\">{body}</failure>\n    </testcase>"
            );
        }
        Verdict::KnownGap(reason) => {
            let _ = writeln!(
                out,
                "    <testcase classname=\"archx.conformance\" name=\"{name}\">\n      \
                 <skipped message=\"xfail: {}\"/>\n    </testcase>",
                xml_escape(reason)
            );
        }
        Verdict::UnexpectedPass => {
            let _ = writeln!(
                out,
                "    <testcase classname=\"archx.conformance\" name=\"{name}\">\n      \
                 <failure message=\"stale xfail marker\">marked xfail but the output now matches \
                 CPython; remove the marker</failure>\n    </testcase>"
            );
        }
        Verdict::DidNotCompile => {
            let _ = writeln!(
                out,
                "    <testcase classname=\"archx.conformance\" name=\"{name}\">"
            );
            let _ = writeln!(
                out,
                "      <failure message=\"compile error\">{}</failure>\n    </testcase>",
                xml_escape(&report.archx_stderr)
            );
        }
        Verdict::Unavailable(reason) => {
            let _ = writeln!(
                out,
                "    <testcase classname=\"archx.conformance\" name=\"{name}\">\n      \
                 <skipped message=\"{}\"/>\n    </testcase>",
                xml_escape(reason)
            );
        }
    }
}

/// Escapes text for XML character data and attribute values.
pub fn xml_escape(text: &str) -> String {
    let mut out = String::with_capacity(text.len());
    for ch in text.chars() {
        match ch {
            '&' => out.push_str("&amp;"),
            '<' => out.push_str("&lt;"),
            '>' => out.push_str("&gt;"),
            '"' => out.push_str("&quot;"),
            '\'' => out.push_str("&apos;"),
            // Control characters are not legal in XML 1.0; replace rather than emit a broken document.
            c if (c as u32) < 0x20 && c != '\n' && c != '\t' => out.push(' '),
            c => out.push(c),
        }
    }
    out
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn only_a_predicted_difference_gets_a_rule_name() {
        // bool repr: same words, different spelling.
        assert_eq!(attribute("True", "true", true), Some("bool repr"));
        assert_eq!(attribute("x True y", "x true y", true), Some("bool repr"));
        // container repr: quotes only.
        assert_eq!(attribute("[a, b]", "['a', 'b']", true), Some("container repr"));
        assert_eq!(attribute("['a']", "[a]", true), Some("container repr"));
        // int overflow: Archx trapped, CPython produced the exact value.
        assert_eq!(
            attribute("9223372036854775808", "archx runtime panic: integer overflow", true),
            Some("int overflow")
        );
        // int division.
        assert_eq!(attribute("3.5", "3", true), Some("int division"));
        // An unrelated difference must NOT be blamed on a rule.
        assert_eq!(attribute("hello", "goodbye", true), None);
        assert_eq!(attribute("42", "43", true), None);
    }

    #[test]
    fn xml_escaping_keeps_the_document_legal() {
        assert_eq!(xml_escape("a<b&c>d\"e'f"), "a&lt;b&amp;c&gt;d&quot;e&apos;f");
        // A control character would make the XML unparseable; it becomes a space.
        assert_eq!(xml_escape("a\u{1}b"), "a b");
        assert_eq!(xml_escape("keep\nnewline"), "keep\nnewline");
    }

    #[test]
    fn exit_codes_distinguish_pass_fail_and_cannot_compare() {
        let base = |verdict| Report {
            path: PathBuf::from("x.archx.lang"),
            verdict,
            python_version: Some("Python 3.12.0".to_string()),
            archx_status: Some(0),
            archx_stderr: String::new(),
            assumed_compat: false,
        };
        assert_eq!(base(Verdict::Match).exit_code(), 0);
        assert_eq!(
            base(Verdict::Unavailable("no python3".to_string())).exit_code(),
            2,
            "a skip must not look like a pass"
        );
        assert_eq!(base(Verdict::DidNotCompile).exit_code(), 1);
        assert_eq!(
            base(Verdict::Diverged(Divergence {
                line: Some(1),
                python: "a".to_string(),
                archx: "b".to_string(),
                rule: None,
                python_stdout: "a\n".to_string(),
                archx_stdout: "b\n".to_string(),
            }))
            .exit_code(),
            1
        );
    }
}

/// Collects checkable files from the paths on the command line, expanding directories.
///
/// Both `.py` and the Archx extensions are accepted because a probe is the same bytes under either
/// name: line 1 is the directive, which Python reads as a comment. Expanding directories is what makes
/// `archx check --against-python tests/conformance` a one-command gate.
pub fn collect(paths: &[PathBuf]) -> std::io::Result<Vec<PathBuf>> {
    fn walk(dir: &Path, out: &mut Vec<PathBuf>) -> std::io::Result<()> {
        let mut entries: Vec<PathBuf> = fs::read_dir(dir)?
            .filter_map(|entry| entry.ok().map(|e| e.path()))
            .collect();
        entries.sort();
        for entry in entries {
            if entry.is_dir() {
                walk(&entry, out)?;
            } else if is_checkable(&entry) {
                out.push(entry);
            }
        }
        Ok(())
    }

    fn is_checkable(path: &Path) -> bool {
        let Some(name) = path.file_name().and_then(|n| n.to_str()) else {
            return false;
        };
        name.ends_with(".py") || crate::has_valid_archx_extension(path)
    }

    let mut out = Vec::new();
    for path in paths {
        if path.is_dir() {
            walk(path, &mut out)?;
        } else if is_checkable(path) {
            out.push(path.clone());
        } else {
            return Err(std::io::Error::new(
                std::io::ErrorKind::InvalidInput,
                format!(
                    "`{}` is not a `.py` or Archx source file",
                    path.display()
                ),
            ));
        }
    }
    Ok(out)
}

/// How a run's reports should be rendered.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum Format {
    Human,
    JUnit,
}

impl Format {
    /// Parses `--format=`; `None` when the name is not one we render.
    pub fn parse(name: &str) -> Option<Self> {
        match name {
            "human" | "text" => Some(Format::Human),
            "junit" | "junit-xml" => Some(Format::JUnit),
            _ => None,
        }
    }
}

/// Runs the full check over `files` and returns the process exit code and the rendered output.
///
/// The exit code is the aggregate: 0 only when every file matched, 2 when nothing could be compared,
/// 1 otherwise. A run that compared nothing must not report success — that is how a gate rots into a
/// green checkmark that tests nothing.
pub fn run(archx_bin: &Path, files: &[PathBuf], work_dir: &Path, format: Format) -> (i32, String) {
    let reports: Vec<Report> = files
        .iter()
        .map(|file| {
            against_python(archx_bin, file, work_dir).unwrap_or_else(|error| Report {
                path: file.clone(),
                verdict: Verdict::Unavailable(format!("could not run the check: {error}")),
                python_version: None,
                archx_status: None,
                archx_stderr: String::new(),
                assumed_compat: false,
            })
        })
        .collect();

    let matched = reports
        .iter()
        .filter(|r| matches!(r.verdict, Verdict::Match))
        .count();
    let diverged = reports
        .iter()
        .filter(|r| matches!(r.verdict, Verdict::Diverged(_)))
        .count();
    let broken = reports
        .iter()
        .filter(|r| matches!(r.verdict, Verdict::DidNotCompile))
        .count();
    let skipped = reports
        .iter()
        .filter(|r| matches!(r.verdict, Verdict::Unavailable(_)))
        .count();
    let known_gaps = reports
        .iter()
        .filter(|r| matches!(r.verdict, Verdict::KnownGap(_)))
        .count();
    let stale = reports
        .iter()
        .filter(|r| matches!(r.verdict, Verdict::UnexpectedPass))
        .count();

    // Aggregate from the per-file verdicts so the rule lives in one place (`Report::exit_code`): any
    // failure wins, and a run that compared nothing is 2, never 0.
    let codes: Vec<i32> = reports.iter().map(Report::exit_code).collect();
    let exit = if codes.contains(&1) {
        1
    } else if !codes.is_empty() && codes.iter().all(|code| *code == 2) {
        2
    } else {
        0
    };

    let mut out = String::new();
    match format {
        Format::Human => {
            for report in &reports {
                out.push_str(&render_human(report));
            }
            let version = reports
                .iter()
                .find_map(|r| r.python_version.clone())
                .unwrap_or_else(|| "python3 (version unknown)".to_string());
            out.push_str(&format!(
                "\n{matched} matched, {known_gaps} xfail (documented gaps), {diverged} diverged, \
                 {broken} failed to compile, {stale} stale xfail markers, {skipped} skipped \
                 (reference: {version})\n"
            ));
        }
        Format::JUnit => {
            out.push_str("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n");
            let _ = writeln!(
                out,
                "<testsuite name=\"archx.conformance\" tests=\"{}\" failures=\"{}\" errors=\"0\" \
                 skipped=\"{}\">",
                reports.len(),
                diverged + broken + stale,
                skipped + known_gaps
            );
            for report in &reports {
                render_junit(report, &mut out);
            }
            out.push_str("</testsuite>\n");
        }
    }
    (exit, out)
}
