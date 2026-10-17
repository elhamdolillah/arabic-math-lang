#!/usr/bin/env python3
"""Deterministic governance checks for the GADT/rank research phase."""
from __future__ import annotations

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
REGISTRY = ROOT / "protocol" / "MAL_GADT_RANK_RESEARCH_REGISTRY_AR.json"
CORPUS = ROOT / "tests" / "MAL_GADT_RANK_RESEARCH_CORPUS_AR.json"
ALLOWED = {"PROVEN", "POLICY", "RESEARCH", "DENY", "ABSTAIN", "EXTENSION_SCOPED_PROVEN"}


def load(path: Path):
    return json.loads(path.read_text(encoding="utf-8"))


def main() -> int:
    registry = load(REGISTRY)
    corpus = load(CORPUS)
    assert registry["status"] == "RESEARCH"
    assert registry["default_decision"] == "ABSTAIN_UNTIL_EVIDENCE"
    assert registry["source_execution"] == "NOT_PERFORMED"
    assert registry["network"] == "DISABLED_BY_CONTRACT"
    assert registry["raw_pointers"] == "DENY"

    extensions = registry["extensions"]
    ids = [item["id"] for item in extensions]
    assert ids == ["gadt-bounded-research", "rank2-static-research"]
    assert len(ids) == len(set(ids))
    assert all(item["decision"] == "RESEARCH" for item in extensions)
    by_id = {item["id"]: item for item in extensions}
    assert by_id["rank2-static-research"]["rank_limit"] == 2
    assert by_id["gadt-bounded-research"]["on_runtime_reflection"] == "DENY"
    assert by_id["rank2-static-research"]["on_impredicative_instantiation"] == "DENY"

    cases = corpus["cases"]
    assert len(cases) == 10
    case_ids = [case["id"] for case in cases]
    assert len(case_ids) == len(set(case_ids))
    for case in cases:
        assert case["feature"] in by_id
        assert case["expected"] in ALLOWED

    assert sum(case["expected"] == "RESEARCH" for case in cases) == 2
    assert sum(case["expected"] == "ABSTAIN" for case in cases) == 5
    assert sum(case["expected"] == "DENY" for case in cases) == 3
    print("GADT_RANK_RESEARCH_REGISTRY=PASS")
    print("GADT_DECISION=RESEARCH")
    print("RANK2_DECISION=RESEARCH")
    print("ABSTAIN_CASES=5")
    print("DENY_CASES=3")
    print("SOURCE_EXECUTION=NOT_PERFORMED")
    print("NETWORK=DISABLED_BY_CONTRACT")
    print("STATUS=0")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
