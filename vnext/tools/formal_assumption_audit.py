#!/usr/bin/env python3
"""مدقق حتمي لمسلمات نماذج Coq في UORI."""
from __future__ import annotations

import argparse
import json
import re
from pathlib import Path

PATTERNS = {
    "axiom": re.compile(r"^\s*Axiom\s+([A-Za-z_][A-Za-z0-9_]*)"),
    "parameter": re.compile(r"^\s*Parameter\s+([A-Za-z_][A-Za-z0-9_]*)"),
    "admitted": re.compile(r"\bAdmitted\b|\bAdmit\b"),
}


def audit(root: Path) -> dict[str, object]:
    findings: list[dict[str, object]] = []
    for path in sorted(root.glob("*.v")):
        for number, line in enumerate(path.read_text(encoding="utf-8").splitlines(), 1):
            for kind in ("axiom", "parameter"):
                match = PATTERNS[kind].search(line)
                if match:
                    findings.append({"file": str(path), "line": number, "kind": kind, "name": match.group(1)})
            if PATTERNS["admitted"].search(line):
                findings.append({"file": str(path), "line": number, "kind": "admitted", "name": "Admitted"})
    kinds = sorted({str(item["kind"]) for item in findings})
    return {
        "formal_root": str(root),
        "finding_count": len(findings),
        "kinds": kinds,
        "full_proof": len(findings) == 0,
        "findings": findings,
    }


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("root", type=Path)
    parser.add_argument("--json", action="store_true")
    args = parser.parse_args()
    result = audit(args.root)
    if args.json:
        print(json.dumps(result, ensure_ascii=False, indent=2, sort_keys=True))
    else:
        print(f"FINDINGS={result['finding_count']}")
        print(f"FULL_PROOF={'PASS' if result['full_proof'] else 'NOT_ESTABLISHED'}")
        for item in result["findings"]:
            print(f"{item['kind']} {item['file']}:{item['line']} {item['name']}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
