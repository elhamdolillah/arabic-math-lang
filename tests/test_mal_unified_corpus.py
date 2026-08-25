#!/usr/bin/env python3
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
CORPUS = ROOT / "tests/MAL_UNIFIED_GOVERNED_CORPUS_AR.json"

def main() -> int:
    data = json.loads(CORPUS.read_text(encoding="utf-8"))
    entries = data["entries"]
    assert data["baseline"] == "MAL_GRAMMAR_SPEC_v0.1_AR.md"
    assert data["source_execution"] == "NOT_PERFORMED"
    assert data["network"] == "DISABLED_BY_CONTRACT"
    assert data["raw_pointers"] == "DENY"
    assert data["runtime_features_admitted"] == 0
    assert len({str(e["id"]) for e in entries}) == len(entries)
    attached = {int(e["id"]) for e in entries if str(e["id"]).isdigit()}
    assert set(range(31, 51)) | {78, 79, 80} <= attached
    for entry in entries:
        assert entry["decision"] in {
            "RESEARCH", "ABSTAIN_UNTIL_EVIDENCE", "POLICY_RESEARCH", "UNCLASSIFIED"
        }
        assert entry["positive"] != "NOT_AVAILABLE" or entry["source_corpus"] != "NOT_AVAILABLE"
    assert [x["range"] for x in data["missing_ranges"]] == ["51-66", "67-77"]
    print("UNIFIED_CORPUS_CHECK=PASS")
    print(f"REGISTERED_ENTRIES={len(entries)}")
    print("ATTACHED_RANGE_CHECK=PASS")
    print("MISSING_RANGES_EXPLICIT=PASS")
    print("RUNTIME_FEATURES_ADMITTED=0")
    print("SOURCE_EXECUTION=NOT_PERFORMED")
    print("BASELINE_MODIFIED=NO")
    print("STATUS=0")
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
