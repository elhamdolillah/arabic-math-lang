#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"
export LC_ALL=C.UTF-8
export LANG=C.UTF-8
export SOURCE_DATE_EPOCH=0
export PYTHONHASHSEED=0
export UORI_POLICY_PATH="$ROOT/protocol/UORI_EXPANSION_POLICY_AR.md"

python3 tests/run_mal_grammar_corpus.py > /tmp/mal_grammar_ci_1.stdout
python3 tests/run_mal_grammar_corpus.py > /tmp/mal_grammar_ci_2.stdout
python3 tests/run_mal_gate_comparator.py > /tmp/mal_gate_ci_1.stdout
python3 tests/run_mal_gate_comparator.py > /tmp/mal_gate_ci_2.stdout
python3 tests/run_mal_policy_gate_comparator.py > /tmp/mal_policy_ci_1.stdout
python3 tests/run_mal_policy_gate_comparator.py > /tmp/mal_policy_ci_2.stdout
python3 tests/run_mal_deny_policy_ci.py > /tmp/mal_deny_ci_1.stdout
python3 tests/run_mal_deny_policy_ci.py > /tmp/mal_deny_ci_2.stdout
python3 tests/run_mal_dir_corpus.py > /tmp/mal_dir_ci_1.stdout
python3 tests/run_mal_dir_corpus.py > /tmp/mal_dir_ci_2.stdout
python3 tests/run_mal_dir_validator.py > /tmp/mal_dir_validator_ci_1.stdout
python3 tests/run_mal_dir_validator.py > /tmp/mal_dir_validator_ci_2.stdout
python3 tests/analyze_mal_dir_nodes.py > /tmp/mal_dir_nodes_ci.stdout
cp /tmp/mal_deny_ci_1.stdout evidence/MAL_DENY_POLICY_CI.stdout

cmp /tmp/mal_grammar_ci_1.stdout /tmp/mal_grammar_ci_2.stdout
cmp /tmp/mal_gate_ci_1.stdout /tmp/mal_gate_ci_2.stdout
cmp /tmp/mal_policy_ci_1.stdout /tmp/mal_policy_ci_2.stdout
cmp /tmp/mal_deny_ci_1.stdout /tmp/mal_deny_ci_2.stdout
cmp /tmp/mal_dir_ci_1.stdout /tmp/mal_dir_ci_2.stdout
cmp /tmp/mal_dir_validator_ci_1.stdout /tmp/mal_dir_validator_ci_2.stdout
grep -q '^MAL_POLICY_GATE_COMPARATOR=PASS$' /tmp/mal_policy_ci_1.stdout
grep -q '^MAL_DENY_POLICY_CI=PASS$' /tmp/mal_deny_ci_1.stdout
grep -q '^DENY_FIELDS_TESTED=8$' /tmp/mal_deny_ci_1.stdout
grep -q '^MAL_DIR_VALIDATOR=PASS$' /tmp/mal_dir_validator_ci_1.stdout
grep -q '^TOTAL_NODES=58$' /tmp/mal_dir_validator_ci_1.stdout
grep -q '^TOTAL_MATCH=PASS$' /tmp/mal_dir_nodes_ci.stdout
grep -q '^ALL_SEQUENCE_AND_ROOT_CHECKS=PASS$' /tmp/mal_dir_nodes_ci.stdout
grep -q 'EXECUTION=NOT_PERFORMED' /tmp/mal_policy_ci_1.stdout
grep -q 'SOURCE_EXECUTED=NO' /tmp/mal_policy_ci_1.stdout

sha256sum -c evidence/MAL_DIR_VALIDATOR.sha256
sha256sum -c evidence/MAL_GRAMMAR_GATE_COMPARATOR.sha256
sha256sum -c evidence/MAL_POLICY_GATE_COMPARATOR_REPRO.sha256
printf 'MAL_DETERMINISTIC_CI=PASS\n'
printf 'GRAMMAR_CORPUS=PASS\n'
printf 'GATE_COMPARATOR=PASS\n'
printf 'POLICY_HASH_AND_DENY=PASS\n'
printf 'DENY_POLICY_FIELDS=8\n'
printf 'MAL_DIR_VALIDATOR=PASS\n'
printf 'MAL_DIR_TOTAL_NODES=58\n'
printf 'EXECUTION=NOT_PERFORMED\n'
printf 'SOURCE_EXECUTED=NO\n'
printf 'NETWORK=DISABLED_BY_CONTRACT\n'
rm -rf extensions/__pycache__ tests/__pycache__
if [ "${MAL_SKIP_GIT_DIFF:-0}" != "1" ]; then
  git diff --exit-code -- . ':!evidence/MAL_CI_RUN.stdout' ':!evidence/MAL_CI_RUN.sha256' ':!evidence/MAL_DENY_POLICY_CI.stdout' ':!evidence/MAL_DENY_POLICY_CI.sha256'
fi
