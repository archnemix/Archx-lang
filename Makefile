.PHONY: build test run ir clean

build:
	cargo build --release

test:
	cargo test

run: build
	./target/release/archx examples/hello.archx --run

ir: build
	./target/release/archx examples/hello.archx --emit-ir

clean:
	cargo clean
