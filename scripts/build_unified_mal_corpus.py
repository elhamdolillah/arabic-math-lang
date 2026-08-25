#!/usr/bin/env python3
"""Build a deterministic, read-only index of governed MAL research corpora."""
from __future__ import annotations
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
REGISTRIES = [
    ROOT / "protocol/MAL_ATTACHED_MECHANISMS_31_39_REGISTRY_AR.json",
    ROOT / "protocol/MAL_ATTACHED_MECHANISMS_40_45_REGISTRY_AR.json",
    ROOT / "protocol/MAL_ATTACHED_MECHANISMS_46_50_REGISTRY_AR.json",
    ROOT / "protocol/MAL_ATTACHED_MECHANISMS_78_80_REGISTRY_AR.json",
    ROOT / "protocol/MAL_ATTACHED_MECHANISMS_81_85_REGISTRY_AR.json",
    ROOT / "protocol/MAL_ATTACHED_MECHANISMS_94_100_REGISTRY_AR.json",
    ROOT / "protocol/MAL_ATTACHED_MECHANISMS_101_105_REGISTRY_AR.json",
    ROOT / "protocol/MAL_ATTACHED_MECHANISMS_116_120_REGISTRY_AR.json",
    ROOT / "protocol/MAL_ATTACHED_MECHANISMS_121_126_REGISTRY_AR.json",
]
CORPORA = [
    ROOT / "tests/MAL_ATTACHED_MECHANISMS_31_39_CORPUS_AR.json",
    ROOT / "tests/MAL_ATTACHED_MECHANISMS_40_45_CORPUS_AR.json",
    ROOT / "tests/MAL_ATTACHED_MECHANISMS_46_50_CORPUS_AR.json",
    ROOT / "tests/MAL_ATTACHED_MECHANISMS_78_80_CORPUS_AR.json",
    ROOT / "tests/MAL_ATTACHED_MECHANISMS_81_85_CORPUS_AR.json",
    ROOT / "tests/MAL_ATTACHED_MECHANISMS_94_100_CORPUS_AR.json",
    ROOT / "tests/MAL_ATTACHED_MECHANISMS_101_105_CORPUS_AR.json",
    ROOT / "tests/MAL_ATTACHED_MECHANISMS_116_120_CORPUS_AR.json",
    ROOT / "tests/MAL_ATTACHED_MECHANISMS_121_126_CORPUS_AR.json",
    ROOT / "tests/MAL_EXTENSIONS_V0_2_CORPUS_AR.json",
    ROOT / "tests/MAL_GADT_RANK_RESEARCH_CORPUS_AR.json",
    ROOT / "tests/MAL_DUAL_EXECUTION_CORPUS_AR.json",
]


def load(path: Path) -> dict:
    return json.loads(path.read_text(encoding="utf-8"))


def main() -> int:
    registry_entries = {}
    for path in REGISTRIES:
        data = load(path)
        for entry in data.get("entries", []):
            key = str(entry["id"])
            if key in registry_entries:
                raise SystemExit(f"DUPLICATE_REGISTRY_ID={key}")
            registry_entries[key] = {**entry, "source_registry": path.relative_to(ROOT).as_posix()}

    corpus_entries = {}
    for path in CORPORA:
        data = load(path)
        for case in data.get("cases", data.get("entries", [])):
            key = str(case["id"])
            if key in corpus_entries:
                raise SystemExit(f"DUPLICATE_CORPUS_ID={key}")
            corpus_entries[key] = {**case, "source_corpus": path.relative_to(ROOT).as_posix()}

    merged = []
    for key in sorted(set(registry_entries) | set(corpus_entries), key=lambda x: (not x.isdigit(), int(x) if x.isdigit() else x)):
        r = registry_entries.get(key, {})
        c = corpus_entries.get(key, {})
        merged.append({
            "id": r.get("id", c.get("id")),
            "name": r.get("name", c.get("name", key)),
            "target": r.get("target", c.get("target", "internal")),
            "decision": r.get("decision", c.get("decision", "UNCLASSIFIED")),
            "positive": c.get("positive", "NOT_AVAILABLE"),
            "counterexample": c.get("counterexample", "NOT_AVAILABLE"),
            "gap": c.get("gap", r.get("guard", "NOT_AVAILABLE")),
            "source_registry": r.get("source_registry", "NOT_AVAILABLE"),
            "source_corpus": c.get("source_corpus", "NOT_AVAILABLE"),
        })

    missing_ranges = [
        {"range": "51-66", "status": "FILE_GAP", "reason": "No governed registry/corpus file exists in the current checkout"},
        {"range": "67-77", "status": "FILE_GAP", "reason": "Mentioned in prior conversation but no governed registry/corpus file exists in the current checkout"},
    ]
    output = {
        "schema": "MAL_UNIFIED_GOVERNED_CORPUS_AR",
        "version": "0.1.0",
        "baseline": "MAL_GRAMMAR_SPEC_v0.1_AR.md",
        "source_execution": "NOT_PERFORMED",
        "network": "DISABLED_BY_CONTRACT",
        "raw_pointers": "DENY",
        "runtime_features_admitted": 0,
        "entries": merged,
        "missing_ranges": missing_ranges,
        "source_files": sorted([p.relative_to(ROOT).as_posix() for p in REGISTRIES + CORPORA]),
    }
    out = ROOT / "tests/MAL_UNIFIED_GOVERNED_CORPUS_AR.json"
    out.write_text(json.dumps(output, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print("UNIFIED_CORPUS=PASS")
    print(f"REGISTERED_ENTRIES={len(merged)}")
    print("ATTACHED_MECHANISMS=31-50,78-85,94-105,116-120,121-126")
    print("OTHER_GOVERNED_CORPORA=V0_2,GADT_RANK,DUAL_EXECUTION")
    print("MISSING_RANGES=51-77")
    print("SOURCE_EXECUTION=NOT_PERFORMED")
    print("RAW_POINTERS=DENY")
    print("BASELINE_MODIFIED=NO")
    print("STATUS=0")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
