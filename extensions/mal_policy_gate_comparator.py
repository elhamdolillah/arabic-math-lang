#!/usr/bin/env python3
"""Static policy comparator for Admission Gate evidence.
The policy is hashed as bytes only; its contents are never executed or evaluated.
"""
from __future__ import annotations

import hashlib
from pathlib import Path
from typing import Any, Mapping

ALLOW = "ALLOW"
DENY = "DENY"
ABSTAIN = "ABSTAIN"
FORBIDDEN_FIELDS = frozenset({"source_ref", "eval", "exec", "shell_command", "callable", "callback", "executable_path", "network_url_for_execution"})


def policy_sha256(policy_path: str | Path) -> str:
    return hashlib.sha256(Path(policy_path).read_bytes()).hexdigest()


def compare_policy_case(case: Mapping[str, Any], policy_path: str | Path) -> dict[str, Any]:
    envelope = case.get("envelope")
    expected = case.get("expected_decision")
    expected_reason = case.get("expected_reason_code")
    actual_hash = policy_sha256(policy_path)
    if not isinstance(envelope, Mapping):
        observed, reason = ABSTAIN, "INPUT_SHAPE"
    elif FORBIDDEN_FIELDS.intersection(envelope):
        observed, reason = DENY, "FORBIDDEN_CONSTRUCT"
    elif envelope.get("policy_version") != "0.1":
        observed, reason = ABSTAIN, "POLICY_MISMATCH"
    elif envelope.get("policy_sha256") != actual_hash:
        observed, reason = ABSTAIN, "POLICY_MISMATCH"
    else:
        observed, reason = ALLOW, "POLICY_MATCH"
    return {
        "id": case.get("id"),
        "expected_decision": expected,
        "expected_reason_code": expected_reason,
        "observed_decision": observed,
        "observed_reason_code": reason,
        "match": observed == expected and reason == expected_reason,
        "policy_sha256_verified": envelope.get("policy_sha256") == actual_hash if isinstance(envelope, Mapping) else False,
        "execution": "NOT_PERFORMED",
        "source_executed": "NO",
        "network": "DISABLED_BY_CONTRACT",
    }


def compare_policy_cases(cases: list[Mapping[str, Any]], policy_path: str | Path) -> dict[str, Any]:
    results = [compare_policy_case(case, policy_path) for case in cases]
    return {
        "comparator": "MAL_POLICY_ADMISSION_GATE",
        "version": "0.1.0",
        "mode": "STATIC_DECISION_ONLY",
        "policy_sha256": policy_sha256(policy_path),
        "results": results,
        "summary": {"total": len(results), "matched": sum(r["match"] for r in results), "mismatched": sum(not r["match"] for r in results)},
    }
