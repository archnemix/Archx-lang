#!/usr/bin/env python3
"""Check that the test count quoted in `README.md` matches the tests that exist (AX-003).

The README claimed "69 = 37 unit + 32 CLI" long after the suite had grown. Counting `#[test]`
attributes is the same thing `cargo test` reports, and it needs no build, so it can gate every push.
"""

import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
README = ROOT / "README.md"
CLAIM = re.compile(
    r"\*\*(\d+) automated tests\*\* \((\d+) unit \+ (\d+) CLI"
    r"(?: \+ (\d+) conformance)?(?: \+ (\d+) diagnostics)?\)"
)


def count_tests(directory: Path, suffix: str = "") -> int:
    """Counts `#[test]` attributes in `directory/<*suffix>.rs`.

    The suite has three parts and the README quotes all three: unit tests in `src/`, CLI integration
    tests in `tests/cli.rs`, and the differential conformance harness in `tests/conformance.rs`.
    """
    return sum(
        path.read_text().count("#[test]")
        for path in directory.rglob(f"*{suffix}.rs")
        if "target" not in path.parts
    )


def main() -> int:
    unit = count_tests(ROOT / "src")
    cli = sum(
        path.read_text().count("#[test]")
        for path in (ROOT / "tests").glob("*.rs")
        if path.stem not in ("conformance", "error_codes")
    )
    conformance = count_tests(ROOT / "tests", "conformance")
    diagnostics = count_tests(ROOT / "tests", "error_codes")
    total = unit + cli + conformance + diagnostics

    readme = README.read_text()
    match = CLAIM.search(readme)
    if not match:
        print("README no longer states the test count in `N automated tests (U unit + C CLI)` form", file=sys.stderr)
        return 2

    claimed = (
        int(match.group(1)),
        int(match.group(2)),
        int(match.group(3)),
        int(match.group(4) or 0),
        int(match.group(5) or 0),
    )
    expected = (total, unit, cli, conformance, diagnostics)
    if claimed != expected:
        print(
            "README test count is stale: claims "
            f"{claimed[0]} ({claimed[1]} unit + {claimed[2]} CLI + {claimed[3]} conformance"
            f" + {claimed[4]} diagnostics), found "
            f"{expected[0]} ({expected[1]} unit + {expected[2]} CLI + {expected[3]} conformance"
            f" + {expected[4]} diagnostics)",
            file=sys.stderr,
        )
        return 1
    print(
        f"README test count matches: {total} ({unit} unit + {cli} CLI + {conformance} conformance"
        f" + {diagnostics} diagnostics)"
    )
    return 0


if __name__ == "__main__":
    sys.exit(main())
