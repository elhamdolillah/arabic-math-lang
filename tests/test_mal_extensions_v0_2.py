#!/usr/bin/env python3
"""Structural, deterministic checks for MAL v0.2 extension governance."""
from __future__ import annotations

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
REGISTRY = ROOT / "protocol" / "MAL_EXTENSIONS_V0_2_REGISTRY_AR.json"
CORPUS = ROOT / "tests" / "MAL_EXTENSIONS_V0_2_CORPUS_AR.json"

ALLOWED = {"PROVEN", "POLICY", "RESEARCH", "DENY", "ABSTAIN", "EXTENSION_SCOPED_PROVEN"}


def load(path: Path):
    return json.loads(path.read_text(encoding="utf-8"))


def main() -> int:
    registry = load(REGISTRY)
    corpus = load(CORPUS)
    extensions = registry["extensions"]
    ids = [item["id"] for item in extensions]
    assert len(ids) == len(set(ids)), "duplicate extension id"
    assert registry["default_decision"] == "ABSTAIN_UNTIL_EVIDENCE"
    assert registry["source_execution"] == "NOT_PERFORMED"
    assert registry["network"] == "DISABLED_BY_CONTRACT"
    assert registry["raw_pointers"] == "DENY"
    for item in extensions:
        assert item["decision"] in ALLOWED, item
        assert item["scope"], item
    by_id = {item["id"]: item for item in extensions}
    assert by_id["raw-pointer"]["decision"] == "DENY"
    assert by_id["ieee754-guarded"]["decision"] == "ABSTAIN"
    assert len(corpus["cases"]) >= 10
    for case in corpus["cases"]:
        assert case["feature"] in by_id, case
        assert case["expected"], case
    print("MAL_EXTENSIONS_V0_2_REGISTRY=PASS")
    print(f"EXTENSIONS={len(extensions)}")
    print(f"CORPUS_CASES={len(corpus['cases'])}")
    print("RAW_POINTER_POLICY=DENY")
    print("FLOAT_WITHOUT_CONTRACT=ABSTAIN")
    print("SOURCE_EXECUTION=NOT_PERFORMED")
    print("NETWORK=DISABLED_BY_CONTRACT")
    print("STATUS=0")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
