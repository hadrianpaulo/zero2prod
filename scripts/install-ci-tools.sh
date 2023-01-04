#!/usr/bin/env bash
set -x
set -eo pipefail

cargo install cargo-tarpaulin cargo-audit
rustup component add rustfmt clippy