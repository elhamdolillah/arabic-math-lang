#!/usr/bin/env python3
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
REG = ROOT / "protocol" / "MAL_ATTACHED_MECHANISMS_40_45_REGISTRY_AR.json"
CORPUS = ROOT / "tests" / "MAL_ATTACHED_MECHANISMS_40_45_CORPUS_AR.json"

FORBIDDEN = {"PROVEN", "EXTENSION_SCOPED_PROVEN", "ALLOW_RUNTIME"}
REQUIRED = {
    40: "RESEARCH",
    41: "RESEARCH",
    42: "RESEARCH",
    43: "RESEARCH",
    44: "POLICY_RESEARCH",
    45: "RESEARCH",
}

def main() -> int:
    reg = json.loads(REG.read_text(encoding="utf-8"))
    corpus = json.loads(CORPUS.read_text(encoding="utf-8"))
    assert reg["baseline"] == "MAL_GRAMMAR_SPEC_v0.1_AR.md"
    assert reg["source_execution"] == "NOT_PERFORMED"
    assert reg["network"] == "DISABLED_BY_CONTRACT"
    assert reg["raw_pointers"] == "DENY"
    assert reg["runtime_features_admitted"] == 0
    entries = {e["id"]: e for e in reg["entries"]}
    cases = {e["id"]: e for e in corpus["cases"]}
    assert set(entries) == set(REQUIRED) == set(cases)
    for ident, expected in REQUIRED.items():
        decision = entries[ident]["decision"]
        assert decision == expected, (ident, decision, expected)
        assert decision not in FORBIDDEN
        assert entries[ident]["guard"]
        assert cases[ident]["decision"] == expected
        assert cases[ident]["counterexample"]
    text = (REG.read_text(encoding="utf-8") + CORPUS.read_text(encoding="utf-8")).lower()
    # Match standalone forbidden primitive names, not the metadata word `execution`.
    for token in ('"eval"', '"exec"', '"shell"', '"source_ref"'):
        assert token not in text, token
    print("MECHANISMS=40,41,42,43,44,45")
    print("REGISTRY_CASES=6")
    print("RUNTIME_FEATURES_ADMITTED=0")
    print("SOURCE_EXECUTION=NOT_PERFORMED")
    print("NETWORK=DISABLED_BY_CONTRACT")
    print("FORBIDDEN_PROMOTION=PASS")
    print("COUNTEREXAMPLES_PRESENT=PASS")
    print("STATUS=0")
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
