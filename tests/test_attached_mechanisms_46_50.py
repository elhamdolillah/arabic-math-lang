#!/usr/bin/env python3
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
REG = ROOT / "protocol/MAL_ATTACHED_MECHANISMS_46_50_REGISTRY_AR.json"
CORPUS = ROOT / "tests/MAL_ATTACHED_MECHANISMS_46_50_CORPUS_AR.json"
FORBIDDEN = {"eval", "exec", "source_ref", "raw_pointer", "unsafe"}

reg = json.loads(REG.read_text(encoding="utf-8"))
corpus = json.loads(CORPUS.read_text(encoding="utf-8"))
entries = {e["id"]: e for e in reg["entries"]}
cases = {c["id"]: c for c in corpus["cases"]}
assert set(entries) == set(range(46, 51))
assert set(cases) == set(entries)
assert reg["runtime_features_admitted"] == 0
assert reg["source_execution"] == "NOT_PERFORMED"
assert reg["raw_pointers"] == "DENY"
for item in reg["entries"]:
    assert item["decision"] in {"RESEARCH", "ABSTAIN_UNTIL_EVIDENCE"}
    assert item["guard"]
    for token in FORBIDDEN:
        assert token not in item["guard"].lower()
for case in corpus["cases"]:
    assert case["decision"] == entries[case["id"]]["decision"]
    assert case["positive"] and case["counterexample"]
print("ATTACHED_MECHANISMS_46_50_CHECK=PASS")
print("RUNTIME_FEATURES_ADMITTED=0")
print("COUNTEREXAMPLES_PRESENT=PASS")
print("SOURCE_EXECUTION=NOT_PERFORMED")
print("BASELINE_MODIFIED=NO")
print("STATUS=0")
