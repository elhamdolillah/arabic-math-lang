#!/usr/bin/env python3
"""Static constitutional checker for attached mechanisms 31–39.

The checker never imports or executes the attached language snippets. It validates
only the repository-owned registry, review contract, and research corpus.
"""
from __future__ import annotations

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
REGISTRY = ROOT / "protocol/MAL_ATTACHED_MECHANISMS_31_39_REGISTRY_AR.json"
CORPUS = ROOT / "tests/MAL_ATTACHED_MECHANISMS_31_39_CORPUS_AR.json"
REVIEW = ROOT / "protocol/MAL_ATTACHED_MECHANISMS_REVIEW_31_39_AR.md"

EXPECTED = {
    31: "RESEARCH",
    32: "ABSTAIN_UNTIL_EVIDENCE",
    33: "RESEARCH",
    34: "RESEARCH",
    35: "RESEARCH",
    36: "RESEARCH",
    37: "RESEARCH",
    38: "RESEARCH",
    39: "ABSTAIN_UNTIL_EVIDENCE",
}


def main() -> int:
    registry = json.loads(REGISTRY.read_text(encoding="utf-8"))
    corpus = json.loads(CORPUS.read_text(encoding="utf-8"))
    assert registry["baseline"] == "MAL_GRAMMAR_SPEC_v0.1_AR.md"
    assert registry["source_execution"] == "NOT_PERFORMED"
    assert registry["network"] == "DISABLED_BY_CONTRACT"
    assert registry["raw_pointers"] == "DENY"
    assert registry["runtime_features_admitted"] == 0
    entries = {entry["id"]: entry for entry in registry["entries"]}
    assert set(entries) == set(EXPECTED)
    for ident, decision in EXPECTED.items():
        assert entries[ident]["decision"] == decision
        assert entries[ident]["guard"]
    cases = {case["id"]: case for case in corpus["cases"]}
    assert set(cases) == set(EXPECTED)
    review = REVIEW.read_text(encoding="utf-8")
    for ident, decision in EXPECTED.items():
        assert f"| {ident} |" in review
        assert f"`{decision}`" in review
        for token in cases[ident]["must_contain"]:
            assert token.lower() in review.lower(), (ident, token)
    assert "المُجزِّئ الثابت لا يضمن ترتيب iteration" in review
    assert "ترتيب commits قد يتأثر بالجدولة" in review
    forbidden = ("eval", "exec", "source_ref", "المؤشرات الخام")
    for token in forbidden:
        assert token in review
    print("ATTACHED_MECHANISMS_CHECKER=PASS")
    print("CASES=9")
    print("RUNTIME_FEATURES_ADMITTED=0")
    print("RESEARCH=7")
    print("ABSTAIN_UNTIL_EVIDENCE=2")
    print("BASELINE_MODIFIED=NO")
    print("SOURCE_EXECUTION=NOT_PERFORMED")
    print("NETWORK=DISABLED_BY_CONTRACT")
    print("STATUS=0")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
