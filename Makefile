# Convenience developer targets for building, testing, running, and inspecting Archx LLVM IR.

.PHONY: build test run ir check clean

build:
	cargo build --release

test:
	cargo test

run: build
	./target/release/archx examples/hello.archx.lang --run

ir: build
	./target/release/archx examples/hello.archx.lang --emit-ir

# Every generated document must match the artifact it is generated from. This is the same gate CI runs
# (`--check` fails on drift), so a doc that was edited by hand instead of regenerated is caught before
# the push rather than after it.
check: build
	python3 tools/gen_dialect_matrix.py --check
	python3 tools/gen_error_codes.py --check
	python3 tools/gen_limitations.py --check
	python3 tools/gen_tracker.py --check
	python3 tools/check_test_count.py
	python3 tools/check_binaries.py

clean:
	cargo clean
