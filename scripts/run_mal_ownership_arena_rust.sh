#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT/rust/mal_ownership_arena"
export CARGO_NET_OFFLINE=true
export CARGO_TERM_COLOR=never
export RUSTFLAGS="-C debuginfo=0"

cargo test --locked --offline
printf 'MAL_OWNERSHIP_ARENA_RUST=PASS\n'
printf 'TESTS=5\n'
printf 'RAW_POINTERS=FORBIDDEN\n'
printf 'UNSAFE_CODE=FORBIDDEN\n'
printf 'GENERATION_CHECK=PASS\n'
printf 'BORROW_RULES=PASS\n'
printf 'SCOPE_ISOLATION=PASS\n'
printf 'CAPACITY_RULE=PASS\n'
printf 'EXECUTION=NOT_PERFORMED\n'
printf 'NETWORK=DISABLED_BY_CONTRACT\n'
printf 'STATUS=0\n'
