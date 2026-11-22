.PHONY: build test run ir clean

build:
	cargo build --release

test:
	cargo test

run: build
	./target/release/archx examples/hello.archx.lang --run

ir: build
	./target/release/archx examples/hello.archx.lang --emit-ir

clean:
	cargo clean
