#!/usr/bin/env python3
"""تحقق ساكن من عقد reproducible build؛ لا ينفذ source_ref أو كود المصدر."""
from __future__ import annotations

import hashlib
import json
import os
import sys
from pathlib import Path

REQUIRED_ENV = {
    "SOURCE_DATE_EPOCH": "0",
    "LC_ALL": "C.UTF-8",
    "LANG": "C.UTF-8",
}
ALLOWLIST = (
    "protocol/REPRODUCIBLE_BUILD_CONTRACT_AR.md",
    "protocol/UORI_FOUR_RULES_ADOPTION_CONTRACT_AR.md",
    "corpus/four_rules_corpus.json",
    "knowledge/UORI_MATH_BOOK_INDEX_FINDINGS.md",
    "extensions/uori_validated_math.py",
    "tests_four_rules.py",
)


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def main(argv: list[str]) -> int:
    if len(argv) != 2:
        print("USAGE=verify_reproducible_build.py ROOT")
        return 2
    root = Path(argv[1]).resolve()
    print("REPRO_BUILD_CHECK=START")
    print("SOURCE_REF_EXECUTED=NO")
    print("NETWORK=DISABLED_BY_CONTRACT")
    errors: list[str] = []
    env_status = {}
    for key, expected in REQUIRED_ENV.items():
        actual = os.environ.get(key)
        env_status[key] = actual
        if actual != expected:
            errors.append(f"ENV_{key}_MISMATCH")
    print("ENV=" + json.dumps(env_status, ensure_ascii=False, sort_keys=True, separators=(",", ":")))

    records = []
    for relative in ALLOWLIST:
        path = root / relative
        if not path.is_file():
            errors.append(f"MISSING:{relative}")
            continue
        records.append({"path": relative, "sha256": sha256(path), "bytes": path.stat().st_size})
    manifest = {"files": records, "policy": "canonical-sha256-v1"}
    canonical = json.dumps(manifest, ensure_ascii=False, sort_keys=True, separators=(",", ":"))
    print("MANIFEST_SHA256=" + hashlib.sha256(canonical.encode("utf-8")).hexdigest())
    print("FILES=" + str(len(records)))
    if errors:
        print("STATUS=ABSTAIN")
        print("REASONS=" + json.dumps(errors, ensure_ascii=False, separators=(",", ":")))
        return 2
    print("STATUS=PASS")
    print("CLASS=EXTENSION_SCOPED_POLICY")
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv))
