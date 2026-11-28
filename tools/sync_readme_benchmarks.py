#!/usr/bin/env python3
"""Regenerate the README's benchmark table and perf claims from `ci/out/benchmarks.txt` (AX-003).

The README used to quote numbers that no test compared against anything, so every release left a
table that was stale by one or more rounds. This script owns both surfaces:

* the whole `## Benchmarks` table (rewritten in place), and
* the two perf sentences in the status block (the "N×–M× faster than Python 3" range and the
  `full_tour` line), whose figures are read from the same report.

`--check` exits non-zero if the README disagrees with the report, which is what CI runs, so a stale
number can no longer merge. Numbers are only ever copied from the report: nothing here measures
anything, and nothing is invented for a suite the report does not contain.
"""

import argparse
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
README = ROOT / "README.md"
REPORT = ROOT / "ci" / "out" / "benchmarks.txt"
TABLE_START = "| Suite | Implementation | Best ms (mean) | vs Python 3 | Stripped KB |"
TABLE_END = "\n\nSee [`examples/comparison/`]"

SUITE_NAMES = {
    "1": "Scalar (`primes`)",
    "2": "Arrays (`arrays`)",
    "3": "Composite (`composite`)",
    "4": "Pythonic Float N-Body (`nbody_float`)",
    "5": "Planar SIMD Dict (`dict_bench`)",
    "6": "5-Way Full-Feature Tour (`full_tour`)",
    "7": "Comprehensions, Generators, `zip` & Inline Sorting (`pipelines`)",
}

def clean_label(label: str) -> str:
    """Collapse the report's fixed-width column padding into a single space."""
    return " ".join(label.split())


# The report is a console table, so its labels are terse ("C raw ptr (unchecked -O2)"). The README
# is read by humans who have not seen the C sources, so each row gets a label that says what the
# implementation actually is. Every row the report emits must appear here: a new suite or variant
# then fails the drift check loudly instead of quietly degrading the table into console shorthand.
IMPL_LABELS = {
    "Python 3 (python3)": "Python 3 (`python3`)",
    "C (clang -O2)": "C (`clang -O2`)",
    "Rust (rustc -O)": "Rust (`rustc -O`)",
    "Archx (archx -O2)": "Archx (`archx -O2`)",
    "C raw ptr (unchecked -O2)": "C raw / checked (`clang -O2`)",
    "C checked (slice struct -O2)": "C checked, slice struct (`clang -O2`)",
    "Rust (safe Vec -O)": "Rust (safe `Vec` `-O`)",
    "Archx (safe [T] -O2)": "Archx (safe `list[T]` `-O2`)",
    "C (AoS + malloc -O2)": "C (`AoS + malloc/strcmp -O2`)",
    "Rust (Vec<Body> + String)": "Rust (`Vec<Body> + String -O`)",
    "Archx (SoA + region + SSO)": "Archx (`SoA + region + SSO -O2`)",
    "C (AoS Body* -O2 -lm)": "C (`AoS Body* -O2 -lm`)",
    "Rust (Vec<Body> -O)": "Rust (`Vec<Body> -O`)",
    "Archx (Pythonic class + SoA)": "Archx (`Pythonic class + SoA -O2`)",
    "Python 3 (python3 built-in dict)": "Python 3 (built-in C `dict`)",
    "C (AoS open-addressing)": "C (`AoS open-addressing -O2`)",
    "Rust (std::HashMap -O)": "Rust (`std::HashMap` `-O`)",
    "Archx Static (Planar SIMD + region)": "Archx Static (`Planar SIMD + region`)",
    "Archx Dynamic (%ArchxAny dict[any])": "Archx Dynamic (`%ArchxAny dict[any]`)",
    "Python 3 (full_tour.py)": "Python 3 (`full_tour.py`)",
    "Archx Pythonic (1:1 == full_tour.py -O2)": "Archx Pythonic (`1:1 == full_tour.py`)",
    "Archx Speed (SoA + region + enum -O2)": "Archx Speed (`SoA + region + enum`)",
    "Clang C (full_tour.c -O2 -lm)": "Clang C (`full_tour.c -O2 -lm`)",
    "Rust (full_tour.rs rustc -O)": "Rust (`full_tour.rs` `rustc -O`)",
    "Python 3 (pipelines.py)": "Python 3 (`pipelines.py`)",
    "Archx Pythonic (1:1 == pipelines.py -O2)": "Archx Pythonic (`1:1 == pipelines.py`)",
    "Clang C (pipelines.c -O2)": "Clang C (`pipelines.c -O2`)",
    "Rust (pipelines.rs rustc -O)": "Rust (`pipelines.rs` `rustc -O`)",
}


def parse_report(text: str) -> list[dict]:
    """Split the report into suites, each a list of `{impl, best, mean, speedup, stripped}` rows."""
    suites: list[dict] = []
    current = None
    for line in text.splitlines():
        header = re.match(r"^(\d)\. .*\(([^()]*)\)\s*$", line)
        if header and header.group(1) in SUITE_NAMES:
            current = {"number": header.group(1), "rows": []}
            suites.append(current)
            continue
        if current is None:
            continue
        # The implementation label may itself contain spaces, digits and parentheses, so the
        # numbers are matched from the right and the label is everything before them. Rows are
        # padded to a fixed column width, which means the gap before `best` can be one space.
        row = re.match(
            r"^  (?P<impl>\S.*?)\s+(?P<best>\d[\d,]*) \((?P<mean>\d[\d,]*)\)"
            r"\s+(?P<speedup>\d+\.\d+)x\s+(?P<raw>\S+)\s+(?P<stripped>\S+)\s*$",
            line,
        )
        if not row:
            continue
        raw_label = clean_label(row["impl"])
        if raw_label not in IMPL_LABELS:
            raise SystemExit(f"unmapped benchmark row `{raw_label}`: add it to IMPL_LABELS")
        impl = IMPL_LABELS[raw_label]
        current["rows"].append(
            {
                "impl": impl,
                "best": int(row["best"].replace(",", "")),
                "mean": int(row["mean"].replace(",", "")),
                "speedup": row["speedup"],
                "raw": row["raw"],
                "stripped": row["stripped"],
            }
        )
    return [s for s in suites if s["rows"]]


def render_table(suites: list[dict]) -> str:
    lines = [TABLE_START, "|---|---|---:|---:|---:|"]
    for suite in suites:
        name = SUITE_NAMES[suite["number"]]
        for index, row in enumerate(suite["rows"]):
            # Archx rows are the subject of the table, so they are the ones set in bold.
            is_archx = row["impl"].lower().startswith("archx")
            impl = f"**{row['impl']}**" if is_archx else row["impl"]
            best = f"{row['best']:,} ms ({row['mean']:,})"
            best = f"**{best}**" if row["best"] == min(r["best"] for r in suite["rows"]) else best
            speed = f"{row['speedup']}×"
            if is_archx:
                speed = f"**{speed}**"
            stripped = "n/a" if row["stripped"] == "n/a" else f"{row['stripped']} KB"
            if is_archx:
                stripped = f"**{stripped}**"
            label = f"**{suite['number']}. {name}**" if index == 0 else ""
            lines.append(f"| {label} | {impl} | {best} | {speed} | {stripped} |")
    return "\n".join(lines)


def python_baseline(suites: list[dict]) -> int:
    for suite in suites:
        for row in suite["rows"]:
            if row["impl"].startswith("Python 3"):
                return row["best"]
    raise SystemExit("the report has no Python 3 baseline")


def archx_speeds(suites: list[dict]) -> dict[str, float]:
    """Best Archx speed-up per suite number."""
    return {
        suite["number"]: max(float(row["speedup"]) for row in suite["rows"] if row["impl"].lower().startswith("archx"))
        for suite in suites
        if any(row["impl"].lower().startswith("archx") for row in suite["rows"])
    }


def archx_range(suites: list[dict]) -> tuple[str, str]:
    """Slowest and fastest Archx speed-up over Suites 2–7, in suite order.

    Suite 1 (`primes`) is excluded on purpose and the README says so: that benchmark is dominated by
    `%` on a loop counter, where CPython's `int` fast path is unusually strong, and Archx is
    genuinely slower there. Folding it into a headline range would either hide a loss (quote only
    the wins) or misrepresent the rest (quote 0.3× as if every suite were like that).
    """
    speeds = archx_speeds(suites)
    ranked = [number for number in sorted(speeds, key=int) if number != "1"]
    if not ranked:
        raise SystemExit("the report has no Archx rows outside Suite 1")
    return f"{min(speeds[n] for n in ranked):.1f}", f"{max(speeds[n] for n in ranked):.1f}"


def tour_rows(suites: list[dict]) -> dict[str, dict]:
    for suite in suites:
        if suite["number"] == "6":
            return {row["impl"]: row for row in suite["rows"]}
    raise SystemExit("the report has no full_tour suite")


def rewrite_status_block(readme: str, suites: list[dict]) -> str:
    low, high = archx_range(suites)
    readme, count = re.subn(
        r"\*\*\d+\.\d+×–\d+\.\d+× faster than Python 3\*\* on Suites 2–7",
        f"**{low}×–{high}× faster than Python 3** on Suites 2–7",
        readme,
    )
    if count != 1:
        raise SystemExit("the status block's 'faster than Python 3' claim was not found exactly once")

    tour = tour_rows(suites)

    def pick(prefix: str) -> dict:
        for impl, row in tour.items():
            if impl.startswith(prefix):
                return row
        raise SystemExit(f"the full_tour suite has no `{prefix}` row")

    py, ax, rust, c = pick("Python 3"), pick("Archx Pythonic"), pick("Rust"), pick("Clang C")
    # The report is run on a shared runner, so only the figures are substituted; the sentence keeps
    # its meaning and every number in it comes from the same run.
    readme, count = re.subn(
        r"\*\*\d+\.\d+× faster than Python 3\*\* \(`\d+ ms` vs `\d+ ms`, against "
        r"`clang -O2` `\d+ ms` and `rustc -O` `\d+ ms`\)",
        f"**{ax['speedup']}× faster than Python 3** (`{ax['best']} ms` vs `{py['best']} ms`, "
        f"against `clang -O2` `{c['best']} ms` and `rustc -O` `{rust['best']} ms`)",
        readme,
    )
    if count != 1:
        raise SystemExit("the status block's full_tour sentence was not found exactly once")
    return readme


def rewrite_table(readme: str, suites: list[dict]) -> str:
    start = readme.find(TABLE_START)
    if start < 0:
        raise SystemExit("the README has no benchmark table to regenerate")
    end = readme.find(TABLE_END, start)
    if end < 0:
        raise SystemExit("the README benchmark table has no closing 'See also' line")
    return readme[:start] + render_table(suites) + readme[end:]


def regenerate(readme: str, suites: list[dict]) -> str:
    return rewrite_status_block(rewrite_table(readme, suites), suites)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument(
        "--check",
        action="store_true",
        help="exit non-zero if the README disagrees with ci/out/benchmarks.txt",
    )
    args = parser.parse_args()

    if not REPORT.is_file():
        print(f"missing benchmark report: {REPORT.relative_to(ROOT)}", file=sys.stderr)
        return 2
    current = README.read_text()
    expected = regenerate(current, parse_report(REPORT.read_text()))

    if args.check:
        if current == expected:
            print("README benchmarks match ci/out/benchmarks.txt")
            return 0
        print(
            "README benchmarks are stale; run `python3 tools/sync_readme_benchmarks.py`",
            file=sys.stderr,
        )
        return 1

    if current != expected:
        README.write_text(expected)
        print("README benchmarks regenerated from ci/out/benchmarks.txt")
    else:
        print("README benchmarks already up to date")
    return 0


if __name__ == "__main__":
    sys.exit(main())
