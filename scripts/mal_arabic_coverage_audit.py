#!/usr/bin/env python3
"""Deterministic, read-only MAL Arabic coverage audit."""
from __future__ import annotations

import argparse
import hashlib
import json
import os
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
INCLUDE_ROOTS = (ROOT / "frontend", ROOT / "extensions", ROOT / "scripts")
EXCLUDED_PARTS = {"tests", "research", "archive", "__pycache__", ".git", "node_modules"}
ARABIC = re.compile(r"[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF]")
LATIN = re.compile(r"[A-Za-z0-9_]")


def canonical(value: object) -> bytes:
    return (json.dumps(value, ensure_ascii=False, sort_keys=True, separators=(",", ":")) + "\n").encode("utf-8")


def in_scope(path: Path) -> bool:
    try:
        relative = path.relative_to(ROOT)
    except ValueError:
        return False
    return path.suffix == ".py" and not any(part in EXCLUDED_PARTS for part in relative.parts)


def metrics(path: Path) -> dict[str, object]:
    data = path.read_bytes()
    text = data.decode("utf-8", errors="strict")
    arabic = len(ARABIC.findall(text))
    latin = len(LATIN.findall(text))
    denominator = arabic + latin
    return {
        "path": path.relative_to(ROOT).as_posix(),
        "bytes": len(data),
        "lines": text.count("\n") + (1 if text and not text.endswith("\n") else 0),
        "arabic_identifier_chars": arabic,
        "latin_identifier_chars": latin,
        "arabic_coverage_ratio": round(arabic / denominator, 8) if denominator else 0.0,
        "sha256": hashlib.sha256(data).hexdigest(),
    }


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    os.environ.setdefault("LC_ALL", "C.UTF-8")
    os.environ.setdefault("LANG", "C.UTF-8")
    os.environ.setdefault("PYTHONHASHSEED", "0")

    files = sorted({path for root in INCLUDE_ROOTS if root.is_dir() for path in root.rglob("*.py") if in_scope(path)}, key=lambda p: p.relative_to(ROOT).as_posix())
    records = []
    abstain = []
    for path in files:
        try:
            records.append(metrics(path))
        except (UnicodeDecodeError, OSError) as exc:
            abstain.append({"path": path.relative_to(ROOT).as_posix(), "reason": type(exc).__name__})
    if abstain:
        decision = "ABSTAIN"
        candidate = None
    else:
        candidate = min(records, key=lambda item: (item["arabic_coverage_ratio"], item["path"])) if records else None
        decision = "ALLOW_MEASUREMENT" if records else "ABSTAIN"
    arabic = sum(int(item["arabic_identifier_chars"]) for item in records)
    latin = sum(int(item["latin_identifier_chars"]) for item in records)
    denominator = arabic + latin
    report = {
        "schema": "MAL_ARABIC_COVERAGE_AUDIT_v0.1",
        "execution": "NOT_PERFORMED",
        "network": "DISABLED_BY_CONTRACT",
        "baseline_modified": False,
        "auto_merge": "DENY",
        "roots": [root.relative_to(ROOT).as_posix() for root in INCLUDE_ROOTS],
        "file_count": len(records),
        "files": records,
        "aggregate": {"arabic_identifier_chars": arabic, "latin_identifier_chars": latin, "arabic_coverage_ratio": round(arabic / denominator, 8) if denominator else 0.0},
        "next_candidate": candidate,
        "abstentions": abstain,
        "decision": decision,
    }
    output = args.output if args.output.is_absolute() else ROOT / args.output
    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_bytes(canonical(report))
    print("MAL_ARABIC_COVERAGE_AUDIT=PASS" if decision == "ALLOW_MEASUREMENT" else "MAL_ARABIC_COVERAGE_AUDIT=ABSTAIN")
    print(f"FILES={len(records)}")
    print(f"ARABIC_COVERAGE_RATIO={report['aggregate']['arabic_coverage_ratio']:.8f}")
    print(f"NEXT_CANDIDATE={candidate['path'] if candidate else 'NONE'}")
    print("SOURCE_EXECUTION=NOT_PERFORMED")
    print("NETWORK=DISABLED_BY_CONTRACT")
    print("BASELINE_MODIFIED=NO")
    print("AUTO_MERGE=DENY")
    print("STATUS=0" if decision != "ABSTAIN" else "STATUS=ABSTAIN")
    return 0 if decision != "ABSTAIN" else 2


if __name__ == "__main__":
    raise SystemExit(main())
