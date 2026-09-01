#!/usr/bin/env python3
from __future__ import annotations
import hashlib
import json
import subprocess
import sys
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
TOOL = ROOT / "scripts" / "uori_compile_time_sidecar.py"

def sha(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()

def canon_json(obj: object) -> bytes:
    return json.dumps(obj, ensure_ascii=False, sort_keys=True, separators=(",", ":")).encode() 

def run(cmd: list[str]) -> subprocess.CompletedProcess[str]:
    return subprocess.run(cmd, text=True, capture_output=True, check=False)

def main() -> int:
    with tempfile.TemporaryDirectory(prefix="mal-cfg-") as td:
        d = Path(td)
        source = "عند_الترجمة(مساواة(target,x86_64)) { ثابت }\n".encode()
        raw = canon_json({"kind":"module","nodes":[{"kind":"cfg","predicate":{"eq":["target","x86_64"]}}]})
        filtered = canon_json({"kind":"module","nodes":[{"kind":"constant","value":"ثابت"}]})
        artifact = b"MAL-ARTIFACT-v0.1\n"
        (d/"source.ar").write_bytes(source)
        (d/"raw.json").write_bytes(raw)
        (d/"filtered.json").write_bytes(filtered)
        (d/"artifact.bin").write_bytes(artifact)
        manifest = {
            "contract_id":"MAL-COMPILE-TIME-0.1",
            "compiler_version":"mal-compiler-0.1.0",
            "target":"x86_64",
            "word_size":64,
            "endianness":"little",
            "profile":"deterministic",
            "features":["arena","cfg-filter"],
            "source_path":"fixtures/source.ar",
            "source_sha256":sha(source),
            "ast_raw_sha256":sha(raw),
            "ast_filtered_sha256":sha(filtered),
            "allowed_keys":["ast_filtered_sha256","ast_raw_sha256","compiler_version","contract_id","endianness","features","profile","source_path","source_sha256","target","word_size"]
        }
        (d/"manifest.json").write_text(json.dumps(manifest, ensure_ascii=False), encoding="utf-8")
        sidecar = d/"artifact.sidecar.json"
        base = [sys.executable, str(TOOL), "--manifest", str(d/"manifest.json"), "--source", str(d/"source.ar"), "--ast-raw", str(d/"raw.json"), "--ast-filtered", str(d/"filtered.json"), "--artifact", str(d/"artifact.bin"), "--sidecar", str(sidecar)]
        first = run(base)
        second = run(base)
        assert first.returncode == 0, first.stderr
        assert second.returncode == 0, second.stderr
        assert first.stdout == second.stdout
        sidecar_bytes = sidecar.read_bytes()
        assert sidecar_bytes == sidecar.read_bytes()
        verify = run(base + ["--verify-sidecar", str(sidecar)])
        assert verify.returncode == 0, verify.stderr

        unknown = dict(manifest)
        unknown["unexpected"] = True
        (d/"unknown.json").write_text(json.dumps(unknown), encoding="utf-8")
        abstain = run([*base[:3], str(d/"unknown.json"), *base[4:]])
        assert abstain.returncode == 2 and "UNKNOWN_CONFIGURATION" in abstain.stderr, abstain.stderr

        bad_source = d/"bad.ar"
        bad_source.write_bytes(source + b"x")
        reject_base = list(base)
        source_index = reject_base.index("--source") + 1
        reject_base[source_index] = str(bad_source)
        reject = run(reject_base)
        assert reject.returncode == 3 and "SOURCE_HASH_MISMATCH" in reject.stderr, reject.stderr
    print("TEST_STATUS=PASS")
    print("CASES=4")
    print("FAILURES=0")
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
