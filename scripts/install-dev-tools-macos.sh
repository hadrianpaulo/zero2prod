#!/usr/bin/env bash
set -x
set -eo pipefail

brew update
brew install michaeleisel/zld/zld npm libpq
brew link --force libpq
cargo install cargo-watch cargo-audit cargo-tarpaulin expand
cargo install sqlx-cli --no-default-features --features rustls,postgres
rustup component add rustfmt clippy
rustup toolchain install nightly
pip install Commitizen pre-commit
pre-commit install
npm install -g @commitlint/cli @commitlint/config-conventional