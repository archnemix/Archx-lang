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
CLAIM = re.compile(r"\*\*(\d+) automated tests\*\* \((\d+) unit \+ (\d+) CLI\)")


def count_tests(directory: Path) -> int:
    return sum(
        path.read_text().count("#[test]")
        for path in directory.rglob("*.rs")
        if "target" not in path.parts
    )


def main() -> int:
    unit = count_tests(ROOT / "src")
    cli = count_tests(ROOT / "tests")
    total = unit + cli

    readme = README.read_text()
    match = CLAIM.search(readme)
    if not match:
        print("README no longer states the test count in `N automated tests (U unit + C CLI)` form", file=sys.stderr)
        return 2

    claimed = (int(match.group(1)), int(match.group(2)), int(match.group(3)))
    expected = (total, unit, cli)
    if claimed != expected:
        print(
            "README test count is stale: claims "
            f"{claimed[0]} ({claimed[1]} unit + {claimed[2]} CLI), found "
            f"{expected[0]} ({expected[1]} unit + {expected[2]} CLI)",
            file=sys.stderr,
        )
        return 1
    print(f"README test count matches: {total} ({unit} unit + {cli} CLI)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
