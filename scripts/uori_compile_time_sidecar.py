#!/usr/bin/env python3
"""Temporary, fail-closed verifier for MAL عند_الترجمة v0.1.

This bridge is intentionally outside the MAL kernel. It does not parse or
execute MAL and does not implement runtime conditional dispatch. It only
canonicalizes a declared manifest, hashes supplied source/AST/artifact bytes,
verifies an optional existing sidecar, and writes a new sidecar after all
preconditions pass.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import os
import sys
from pathlib import Path
from typing import Any

CONTRACT_ID = "MAL-COMPILE-TIME-0.1"
SIDECAR_SCHEMA = "UORI-ARTIFACT-0.1"
SCHEMA_KEYS = (
    "contract_id",
    "compiler_version",
    "target",
    "word_size",
    "endianness",
    "profile",
    "features",
    "source_path",
    "source_sha256",
    "ast_raw_sha256",
    "ast_filtered_sha256",
)
ALLOWED_HASHES = {
    "artifact_sha256",
    "configuration_sha256",
    "source_sha256",
    "ast_raw_sha256",
    "ast_filtered_sha256",
}


class Abstain(Exception):
    def __init__(self, code: str, detail: str) -> None:
        self.code = code
        self.detail = detail
        super().__init__(f"ABSTAIN/{code}: {detail}")


class Reject(Exception):
    def __init__(self, code: str, detail: str) -> None:
        self.code = code
        self.detail = detail
        super().__init__(f"REJECT/{code}: {detail}")


def sha256_bytes(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def read_bytes(path: Path) -> bytes:
    try:
        return path.read_bytes()
    except OSError as exc:
        raise Abstain("TOOL_UNAVAILABLE", f"cannot read {path}: {exc}") from exc


def reject_control(text: str, field: str) -> None:
    if any(ord(ch) < 0x20 and ch not in "\t\n" for ch in text):
        raise Abstain("NON_CANONICAL_INPUT", f"control character in {field}")
    if any(ch in text for ch in ("\u200b", "\u200c", "\u200d", "\ufeff")):
        raise Abstain("NON_CANONICAL_INPUT", f"invisible character in {field}")


def canonical_text(value: Any, field: str) -> str:
    if not isinstance(value, str) or value == "":
        raise Abstain("TYPE_MISMATCH", f"{field} must be a non-empty string")
    if value != value.strip():
        raise Abstain("NON_CANONICAL_INPUT", f"surrounding whitespace in {field}")
    reject_control(value, field)
    encoded = value.encode("utf-8")
    if encoded.decode("utf-8") != value:
        raise Abstain("NON_CANONICAL_INPUT", f"invalid UTF-8 in {field}")
    return value


def canonical_word_size(value: Any) -> str:
    if isinstance(value, bool) or not isinstance(value, int) or value <= 0:
        raise Abstain("TYPE_MISMATCH", "word_size must be a positive integer")
    return str(value)


def canonical_features(value: Any) -> list[str]:
    if not isinstance(value, list):
        raise Abstain("TYPE_MISMATCH", "features must be a list")
    result = []
    for index, item in enumerate(value):
        result.append(canonical_text(item, f"features[{index}]") )
    if len(set(result)) != len(result):
        raise Abstain("DUPLICATE_CONFLICT", "duplicate feature in ordered feature list")
    return result


def canonical_manifest(raw: Any) -> dict[str, Any]:
    if not isinstance(raw, dict):
        raise Abstain("TYPE_MISMATCH", "manifest must be an object")
    required = set(SCHEMA_KEYS) | {"allowed_keys"}
    missing = sorted(required - set(raw))
    if missing:
        raise Abstain("MISSING_CONFIGURATION", ",".join(missing))
    unknown = sorted(set(raw) - required)
    if unknown:
        raise Abstain("UNKNOWN_CONFIGURATION", ",".join(unknown))
    allowed = raw["allowed_keys"]
    if not isinstance(allowed, list) or any(not isinstance(x, str) for x in allowed):
        raise Abstain("TYPE_MISMATCH", "allowed_keys must be a list of strings")
    if allowed != sorted(set(allowed)):
        raise Abstain("NON_CANONICAL_INPUT", "allowed_keys must be sorted and unique")
    if set(SCHEMA_KEYS) - set(allowed):
        raise Abstain("MISSING_CONFIGURATION", "allowed_keys omits schema fields")
    if raw["contract_id"] != CONTRACT_ID:
        raise Abstain("CONTRACT_VERSION_MISMATCH", "unsupported contract_id")
    result: dict[str, Any] = {
        "contract_id": canonical_text(raw["contract_id"], "contract_id"),
        "compiler_version": canonical_text(raw["compiler_version"], "compiler_version"),
        "target": canonical_text(raw["target"], "target"),
        "word_size": canonical_word_size(raw["word_size"]),
        "endianness": canonical_text(raw["endianness"], "endianness"),
        "profile": canonical_text(raw["profile"], "profile"),
        "features": canonical_features(raw["features"]),
        "source_path": canonical_text(raw["source_path"], "source_path"),
        "source_sha256": canonical_text(raw["source_sha256"], "source_sha256"),
        "ast_raw_sha256": canonical_text(raw["ast_raw_sha256"], "ast_raw_sha256"),
        "ast_filtered_sha256": canonical_text(raw["ast_filtered_sha256"], "ast_filtered_sha256"),
    }
    for key in ("source_sha256", "ast_raw_sha256", "ast_filtered_sha256"):
        if len(result[key]) != 64 or any(ch not in "0123456789abcdef" for ch in result[key]):
            raise Abstain("TYPE_MISMATCH", f"{key} is not lowercase SHA-256")
    return result


def canonical_config_bytes(manifest: dict[str, Any]) -> bytes:
    lines = [
        "uori-config-v=0.1",
        f"contract_id={manifest['contract_id']}",
        f"compiler_version={manifest['compiler_version']}",
        f"target={manifest['target']}",
        f"word_size={manifest['word_size']}",
        f"endianness={manifest['endianness']}",
        f"profile={manifest['profile']}",
    ]
    lines.extend(f"feature[{i}]={feature}" for i, feature in enumerate(manifest["features"]))
    lines.extend(
        [
            f"source_path={manifest['source_path']}",
            f"source_sha256={manifest['source_sha256']}",
            f"ast_raw_sha256={manifest['ast_raw_sha256']}",
            f"ast_filtered_sha256={manifest['ast_filtered_sha256']}",
        ]
    )
    return ("\n".join(lines) + "\n").encode("utf-8")


def canonical_json_bytes(path: Path) -> bytes:
    raw = read_bytes(path)
    try:
        value = json.loads(raw.decode("utf-8"))
    except (UnicodeDecodeError, json.JSONDecodeError) as exc:
        raise Abstain("NON_CANONICAL_INPUT", f"invalid JSON in {path}: {exc}") from exc
    return json.dumps(value, ensure_ascii=False, sort_keys=True, separators=(",", ":"), allow_nan=False).encode("utf-8")


def verify_hex(name: str, value: Any) -> str:
    if not isinstance(value, str) or len(value) != 64 or any(ch not in "0123456789abcdef" for ch in value):
        raise Reject("SIDECAR_INVALID", f"{name} must be lowercase SHA-256")
    return value


def verify_sidecar(path: Path, expected: dict[str, str]) -> None:
    try:
        sidecar = json.loads(read_bytes(path).decode("utf-8"))
    except (UnicodeDecodeError, json.JSONDecodeError) as exc:
        raise Reject("SIDECAR_INVALID", str(exc)) from exc
    if not isinstance(sidecar, dict) or sidecar.get("artifact_schema") != SIDECAR_SCHEMA:
        raise Reject("SIDECAR_INVALID", "wrong artifact_schema")
    for key, expected_value in expected.items():
        if verify_hex(key, sidecar.get(key)) != expected_value:
            raise Reject("HASH_MISMATCH", key)
    if sidecar.get("status") != "PASS":
        raise Reject("SIDECAR_INVALID", "status is not PASS")


def build(args: argparse.Namespace) -> int:
    manifest_raw = json.loads(read_bytes(Path(args.manifest)).decode("utf-8"))
    manifest = canonical_manifest(manifest_raw)
    source = read_bytes(Path(args.source))
    raw_ast = canonical_json_bytes(Path(args.ast_raw))
    filtered_ast = canonical_json_bytes(Path(args.ast_filtered))
    artifact = read_bytes(Path(args.artifact))

    hs = sha256_bytes(source)
    hr = sha256_bytes(raw_ast)
    hf = sha256_bytes(filtered_ast)
    if hs != manifest["source_sha256"]:
        raise Reject("SOURCE_HASH_MISMATCH", "manifest source_sha256 does not match source")
    if hr != manifest["ast_raw_sha256"]:
        raise Reject("AST_HASH_MISMATCH", "manifest ast_raw_sha256 does not match AST")
    if hf != manifest["ast_filtered_sha256"]:
        raise Reject("AST_HASH_MISMATCH", "manifest ast_filtered_sha256 does not match filtered AST")

    hc = sha256_bytes(canonical_config_bytes(manifest))
    ha = sha256_bytes(artifact)
    expected = {
        "artifact_sha256": ha,
        "configuration_sha256": hc,
        "source_sha256": hs,
        "ast_raw_sha256": hr,
        "ast_filtered_sha256": hf,
    }
    if args.verify_sidecar:
        verify_sidecar(Path(args.verify_sidecar), expected)

    sidecar = {
        "artifact_schema": SIDECAR_SCHEMA,
        "artifact_path": Path(args.artifact).as_posix(),
        **expected,
        "compiler_version": manifest["compiler_version"],
        "target": manifest["target"],
        "status": "PASS",
    }
    output = Path(args.sidecar)
    output.parent.mkdir(parents=True, exist_ok=True)
    temp = output.with_name(output.name + ".tmp")
    temp.write_bytes((json.dumps(sidecar, ensure_ascii=False, sort_keys=True, separators=(",", ":")) + "\n").encode("utf-8"))
    os.replace(temp, output)
    print("STATUS=PASS")
    print(f"CONFIGURATION_SHA256={hc}")
    print(f"ARTIFACT_SHA256={ha}")
    print(f"SIDECAR={output.as_posix()}")
    return 0


def main() -> int:
    parser = argparse.ArgumentParser(description="Fail-closed UORI configuration/artifact verifier")
    parser.add_argument("--manifest", required=True)
    parser.add_argument("--source", required=True)
    parser.add_argument("--ast-raw", required=True)
    parser.add_argument("--ast-filtered", required=True)
    parser.add_argument("--artifact", required=True)
    parser.add_argument("--sidecar", required=True)
    parser.add_argument("--verify-sidecar")
    args = parser.parse_args()
    try:
        return build(args)
    except Abstain as exc:
        print(f"STATUS=ABSTAIN\nCODE={exc.code}\nDETAIL={exc.detail}", file=sys.stderr)
        return 2
    except Reject as exc:
        print(f"STATUS=REJECT\nCODE={exc.code}\nDETAIL={exc.detail}", file=sys.stderr)
        return 3
    except (OSError, json.JSONDecodeError, UnicodeDecodeError) as exc:
        print(f"STATUS=ABSTAIN\nCODE=TOOL_UNAVAILABLE\nDETAIL={exc}", file=sys.stderr)
        return 2


if __name__ == "__main__":
    raise SystemExit(main())
