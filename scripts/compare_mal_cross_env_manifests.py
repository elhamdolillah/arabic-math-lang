#!/usr/bin/env python3
"""Compare MAL cross-environment manifests without trusting host metadata."""
from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path

SCHEMA = "mal-cross-env-manifest-v0.1"


def canonical_bytes(value: object) -> bytes:
    return (json.dumps(value, ensure_ascii=False, sort_keys=True, separators=(",", ":")) + "\n").encode("utf-8")


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--input-dir", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    manifests = sorted(
        path for path in args.input_dir.glob("*.json")
        if path.name != args.output.name
    )
    if len(manifests) < 2:
        print("CROSS_ENV_COMPARE=ABSTAIN")
        print("REASON=INSUFFICIENT_ENVIRONMENTS")
        return 2

    loaded = []
    for path in manifests:
        try:
            value = json.loads(path.read_text(encoding="utf-8"))
        except (OSError, UnicodeError, json.JSONDecodeError):
            print(f"CROSS_ENV_COMPARE=FAIL\nREASON=INVALID_MANIFEST\nFILE={path.name}")
            return 3
        if value.get("schema") != SCHEMA or not value.get("comparable_sha256"):
            print(f"CROSS_ENV_COMPARE=FAIL\nREASON=SCHEMA_OR_DIGEST_INVALID\nFILE={path.name}")
            return 3
        comparable = {"schema": value["schema"], "artifacts": value.get("artifacts")}
        expected = hashlib.sha256(canonical_bytes(comparable)).hexdigest()
        if expected != value["comparable_sha256"]:
            print(f"CROSS_ENV_COMPARE=FAIL\nREASON=SELF_HASH_MISMATCH\nFILE={path.name}")
            return 4
        loaded.append((path.name, value))

    digests = sorted({value["comparable_sha256"] for _, value in loaded})
    status = "PASS" if len(digests) == 1 else "FAIL"
    report = {
        "schema": "mal-cross-env-comparison-v0.1",
        "manifests": [
            {"file": name, "environment_label": value.get("environment_label"), "comparable_sha256": value["comparable_sha256"]}
            for name, value in loaded
        ],
        "unique_comparable_sha256": digests,
        "status": status,
        "execution": "NOT_PERFORMED",
        "network": "DISABLED_BY_CONTRACT",
    }
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_bytes(canonical_bytes(report))
    print(f"CROSS_ENV_COMPARE={status}")
    print(f"ENVIRONMENTS={len(loaded)}")
    print(f"UNIQUE_DIGESTS={len(digests)}")
    print("EXECUTION=NOT_PERFORMED")
    print("NETWORK=DISABLED_BY_CONTRACT")
    return 0 if status == "PASS" else 5


if __name__ == "__main__":
    raise SystemExit(main())
