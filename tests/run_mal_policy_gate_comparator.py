#!/usr/bin/env python3
from __future__ import annotations
import json
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[1]
POLICY = Path(__import__('os').environ.get('UORI_POLICY_PATH', str(Path(__file__).resolve().parents[1] / 'protocol/UORI_EXPANSION_POLICY_AR.md')))
sys.path.insert(0, str(ROOT / "extensions"))
from mal_policy_gate_comparator import compare_policy_cases, policy_sha256

OUT = ROOT / "evidence/MAL_POLICY_GATE_COMPARATOR.stdout"

def main() -> int:
    digest = policy_sha256(POLICY)
    cases = [
        {"id": "policy_match", "envelope": {"policy_version": "0.1", "policy_sha256": digest}, "expected_decision": "ALLOW", "expected_reason_code": "POLICY_MATCH"},
        {"id": "policy_hash_mismatch", "envelope": {"policy_version": "0.1", "policy_sha256": "0" * 64}, "expected_decision": "ABSTAIN", "expected_reason_code": "POLICY_MISMATCH"},
        {"id": "policy_hash_malformed", "envelope": {"policy_version": "0.1", "policy_sha256": "not-a-hash"}, "expected_decision": "ABSTAIN", "expected_reason_code": "POLICY_MISMATCH"},
        {"id": "policy_version_mismatch", "envelope": {"policy_version": "0.2", "policy_sha256": digest}, "expected_decision": "ABSTAIN", "expected_reason_code": "POLICY_MISMATCH"},
        {"id": "forbidden_source_ref", "envelope": {"policy_version": "0.1", "policy_sha256": digest, "source_ref": "untrusted"}, "expected_decision": "DENY", "expected_reason_code": "FORBIDDEN_CONSTRUCT"},
        {"id": "forbidden_exec", "envelope": {"policy_version": "0.1", "policy_sha256": digest, "exec": "blocked"}, "expected_decision": "DENY", "expected_reason_code": "FORBIDDEN_CONSTRUCT"},
        {"id": "missing_envelope", "envelope": None, "expected_decision": "ABSTAIN", "expected_reason_code": "INPUT_SHAPE"},
    ]
    result = compare_policy_cases(cases, POLICY)
    if result["summary"]["mismatched"] != 0:
        raise SystemExit("POLICY_COMPARATOR_MISMATCH")
    if any(r["execution"] != "NOT_PERFORMED" or r["source_executed"] != "NO" for r in result["results"]):
        raise SystemExit("POLICY_EXECUTION_GUARD_FAIL")
    print("MAL_POLICY_GATE_COMPARATOR=PASS")
    print(f"POLICY_SHA256={digest}")
    print(f"TOTAL={result['summary']['total']}")
    print(f"MATCHED={result['summary']['matched']}")
    print(f"MISMATCHED={result['summary']['mismatched']}")
    for r in result["results"]:
        print(f"CASE_ID={r['id']} DECISION={r['observed_decision']} REASON_CODE={r['observed_reason_code']} POLICY_HASH_VERIFIED={'YES' if r['policy_sha256_verified'] else 'NO'} MATCH={'PASS' if r['match'] else 'FAIL'}")
    print("EXECUTION=NOT_PERFORMED")
    print("SOURCE_EXECUTED=NO")
    print("NETWORK=DISABLED_BY_CONTRACT")
    OUT.write_text(json.dumps(result, ensure_ascii=False, sort_keys=True, separators=(",", ":")) + "\n", encoding="utf-8")

if __name__ == "__main__":
    raise SystemExit(main())
