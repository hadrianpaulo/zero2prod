#!/usr/bin/env bash
set -x
set -eo pipefail

cargo watch -x check -x fmt -x test