#!/usr/bin/env python3
from __future__ import annotations
import os
import tempfile
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[1]
POLICY = Path(os.environ.get('UORI_POLICY_PATH', str(ROOT / 'protocol/UORI_EXPANSION_POLICY_AR.md')))
sys.path.insert(0, str(ROOT / 'extensions'))
from mal_policy_gate_comparator import compare_policy_case, policy_sha256

DENY_FIELDS = ('source_ref', 'eval', 'exec', 'shell_command', 'callable', 'callback', 'executable_path', 'network_url_for_execution')

def main() -> int:
    digest = policy_sha256(POLICY)
    for field in DENY_FIELDS:
        result = compare_policy_case({'id': field, 'envelope': {'policy_version': '0.1', 'policy_sha256': digest, field: 'present'}, 'expected_decision': 'DENY', 'expected_reason_code': 'FORBIDDEN_CONSTRUCT'}, POLICY)
        if not result['match'] or result['observed_decision'] != 'DENY' or result['observed_reason_code'] != 'FORBIDDEN_CONSTRUCT':
            raise SystemExit(f'DENY_POLICY_FAIL:{field}')
        if result['execution'] != 'NOT_PERFORMED' or result['source_executed'] != 'NO':
            raise SystemExit(f'EXECUTION_GUARD_FAIL:{field}')
    original = POLICY.read_bytes()
    with tempfile.NamedTemporaryFile() as mutated:
        mutated.write(original + b'\n')
        mutated.flush()
        result = compare_policy_case({'id': 'mutated_policy', 'envelope': {'policy_version': '0.1', 'policy_sha256': digest}, 'expected_decision': 'ABSTAIN', 'expected_reason_code': 'POLICY_MISMATCH'}, mutated.name)
        if not result['match']:
            raise SystemExit('POLICY_MUTATION_FAIL')
    print('MAL_DENY_POLICY_CI=PASS')
    print(f'DENY_FIELDS_TESTED={len(DENY_FIELDS)}')
    print('POLICY_MUTATION=ABSTAIN')
    print('EXECUTION=NOT_PERFORMED')
    print('SOURCE_EXECUTED=NO')
    print('NETWORK=DISABLED_BY_CONTRACT')

if __name__ == '__main__':
    raise SystemExit(main())
