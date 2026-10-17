#!/usr/bin/env python3
"""Static comparator between MAL parser evidence and the Admission Gate contract.
It compares evidence only. It never evaluates, executes, imports source, or opens a network.
"""
from __future__ import annotations

from typing import Any, Mapping

ALLOW = "ALLOW"
DENY = "DENY"
ABSTAIN = "ABSTAIN"

_ERROR_REASON = {
    "UNKNOWN_TOKEN": "UNKNOWN_TOKEN",
    "SYNTAX_ERROR": "SYNTAX_ERROR",
    "UNSUPPORTED_UNARY_OPERATOR": "UNSUPPORTED_UNARY_OPERATOR",
    "RESERVED_WORD_AS_IDENTIFIER": "RESERVED_WORD_AS_IDENTIFIER",
    "UNTRUSTED_SOURCE": "UNTRUSTED_SOURCE",
    "REAL_ARITHMETIC_CONTRACT_MISSING": "REAL_ARITHMETIC_CONTRACT_MISSING",
}


def compare_case(case: Mapping[str, Any], evidence: Mapping[str, Any]) -> dict[str, Any]:
    """Return a deterministic decision comparison for one corpus case."""
    case_id = case.get("id")
    expected = case.get("expected_status")
    expected_error = case.get("expected_error")
    expected_root = case.get("expected_root")
    parser_status = evidence.get("parser_status")
    ast = evidence.get("ast")
    diagnostics = evidence.get("diagnostics")
    observed_error = None
    if isinstance(diagnostics, list) and diagnostics:
        observed_error = diagnostics[0].get("message")

    if parser_status == "PASS":
        root_ok = isinstance(ast, Mapping) and ast.get("النوع") == expected_root
        if not root_ok:
            observed, reason = ABSTAIN, "AST_ROOT_MISMATCH"
        elif expected == ALLOW and expected_error is None:
            observed, reason = ALLOW, "STATIC_ACCEPT"
        elif expected == ABSTAIN and expected_error == "REAL_ARITHMETIC_CONTRACT_MISSING":
            observed, reason = ABSTAIN, "REAL_ARITHMETIC_CONTRACT_MISSING"
        else:
            observed, reason = ABSTAIN, "EXPECTATION_CONTRACT_MISMATCH"
    elif parser_status == "ERROR":
        if expected != ABSTAIN:
            observed, reason = ABSTAIN, "UNEXPECTED_PARSER_ERROR"
        elif expected_error in _ERROR_REASON:
            observed, reason = ABSTAIN, _ERROR_REASON[expected_error]
        else:
            observed, reason = ABSTAIN, "UNCLASSIFIED_DIAGNOSTIC"
    else:
        observed, reason = ABSTAIN, "PARSER_EVIDENCE_MISSING"

    matches = observed == expected and (expected_error is None or reason == expected_error)
    return {
        "id": case_id,
        "expected_status": expected,
        "expected_error": expected_error,
        "observed_decision": observed,
        "observed_reason_code": reason,
        "parser_status": parser_status,
        "match": matches,
        "execution": "NOT_PERFORMED",
        "source_executed": "NO",
        "network": "DISABLED_BY_CONTRACT",
    }


def compare_all(corpus: Mapping[str, Any], parser_payload: Mapping[str, Any]) -> dict[str, Any]:
    evidence_by_id = {item["id"]: item for item in parser_payload.get("cases", [])}
    results = [compare_case(case, evidence_by_id.get(case["id"], {})) for case in corpus.get("cases", [])]
    return {
        "comparator": "MAL_GRAMMAR_ADMISSION_GATE",
        "version": "0.1.0",
        "mode": "STATIC_DECISION_ONLY",
        "results": results,
        "summary": {
            "total": len(results),
            "matched": sum(1 for item in results if item["match"]),
            "mismatched": sum(1 for item in results if not item["match"]),
            "execution": "NOT_PERFORMED",
        },
    }
