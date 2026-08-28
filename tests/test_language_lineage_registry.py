#!/usr/bin/env python3
"""Static, deterministic checks for the MAL language-lineage registry."""
from __future__ import annotations

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
REGISTRY = ROOT / "protocol" / "MAL_LANGUAGE_LINEAGE_REGISTRY_AR.json"
ALLOWED = {"PROVEN", "EXTENSION_SCOPED_PROVEN", "RESEARCH", "DENY", "ABSTAIN"}


def main() -> int:
    data = json.loads(REGISTRY.read_text(encoding="utf-8"))
    entries = data["entries"]
    ids = [entry["id"] for entry in entries]
    assert len(ids) == len(set(ids)), "duplicate registry id"
    assert all(entry["decision"] in ALLOWED for entry in entries)
    timeline = [entry for entry in entries if entry["id"] not in {"raw_pointer_access", "ambiguous_semantics"}]
    assert timeline == sorted(timeline, key=lambda entry: (entry["year_start"], entry["id"]))
    raw_pointer = next(entry for entry in entries if entry["id"] == "raw_pointer_access")
    ambiguous = next(entry for entry in entries if entry["id"] == "ambiguous_semantics")
    assert raw_pointer["decision"] == "DENY"
    assert ambiguous["decision"] == "ABSTAIN"
    assert data["default_on_ambiguity"] == "ABSTAIN"
    print("MAL_LANGUAGE_LINEAGE_REGISTRY=PASS")
    print(f"ENTRIES={len(entries)}")
    print("DECISION_SET=PASS")
    print("CHRONOLOGICAL_ORDER=PASS")
    print("RAW_POINTER_POLICY=DENY")
    print("AMBIGUITY_POLICY=ABSTAIN")
    print("STATUS=0")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
