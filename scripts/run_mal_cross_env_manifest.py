#!/usr/bin/env python3
"""Generate a canonical MAL cross-environment audit manifest.

This script is intentionally passive with respect to MAL source: it invokes only
repository-owned audit scripts, never imports or executes user source, and hashes
an explicit allowlist of deterministic evidence files.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import os
import subprocess
import sys
from pathlib import Path

SCHEMA = "mal-cross-env-manifest-v0.1"
ALLOWLIST = (
    "protocol/MAL_GRAMMAR_SPEC_v0.1_AR.md",
    "protocol/MAL_DIR_SPEC_v0.1_AR.md",
    "protocol/MAL_DENY_POLICY_v0.1_AR.md",
    "protocol/UORI_EXPANSION_POLICY_AR.md",
    "evidence/MAL_GRAMMAR_CORPUS_PARSER.stdout",
    "evidence/MAL_GRAMMAR_GATE_COMPARATOR.stdout",
    "evidence/MAL_DIR_VALIDATOR.stdout",
    "evidence/MAL_DIR_NODE_ANALYSIS.stdout",
    "evidence/MAL_DENY_POLICY_CI.stdout",
)


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def canonical_bytes(value: object) -> bytes:
    return (json.dumps(value, ensure_ascii=False, sort_keys=True, separators=(",", ":")) + "\n").encode("utf-8")


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--root", type=Path, default=Path(__file__).resolve().parents[1])
    parser.add_argument("--label", required=True)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    root = args.root.resolve()
    output = args.output if args.output.is_absolute() else root / args.output
    output.parent.mkdir(parents=True, exist_ok=True)

    env = os.environ.copy()
    env.update({
        "LC_ALL": "C.UTF-8",
        "LANG": "C.UTF-8",
        "SOURCE_DATE_EPOCH": "0",
        "PYTHONHASHSEED": "0",
        "UORI_POLICY_PATH": str(root / "protocol/UORI_EXPANSION_POLICY_AR.md"),
    })
    run = subprocess.run(
        ["bash", "scripts/run_mal_deterministic_ci.sh"],
        cwd=root,
        env=env,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        text=True,
        encoding="utf-8",
        errors="strict",
        check=False,
    )
    (output.parent / f"{output.stem}.stdout").write_text(run.stdout, encoding="utf-8")
    if run.returncode != 0:
        print(run.stdout, end="")
        print(f"CROSS_ENV_AUDIT=FAIL\nLABEL={args.label}\nSTATUS={run.returncode}")
        return run.returncode or 1

    artifacts = []
    for relative in ALLOWLIST:
        path = root / relative
        if not path.is_file():
            print(f"MISSING_ARTIFACT={relative}")
            return 2
        artifacts.append({"path": relative, "sha256": sha256_file(path), "bytes": path.stat().st_size})

    comparable = {"schema": SCHEMA, "artifacts": artifacts}
    comparable_hash = hashlib.sha256(canonical_bytes(comparable)).hexdigest()
    manifest = {
        **comparable,
        "environment_label": args.label,
        "python": sys.version.split()[0],
        "source_commit": os.environ.get("GITHUB_SHA", "LOCAL"),
        "comparable_sha256": comparable_hash,
        "execution": "NOT_PERFORMED",
        "network": "DISABLED_BY_CONTRACT",
    }
    output.write_bytes(canonical_bytes(manifest))
    print(f"CROSS_ENV_AUDIT=PASS")
    print(f"LABEL={args.label}")
    print(f"COMPARABLE_SHA256={comparable_hash}")
    print("EXECUTION=NOT_PERFORMED")
    print("NETWORK=DISABLED_BY_CONTRACT")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
