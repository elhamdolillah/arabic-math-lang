#!/usr/bin/env python3
"""مقارنة حتمية للمدقق العربي وPython على نفس حمولات MAL-DIR."""
from __future__ import annotations

import hashlib
import json
import os
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))
CORPUS = ROOT / "evidence/MAL_DIR_CORPUS_RUN1.json"
OUT = ROOT / "evidence/MAL_DIR_VALIDATOR_DIFFERENTIAL.json"
TMP = ROOT / "evidence/.mal_dir_dual_tmp"
TIMEOUT = 10


def canonical(value: object) -> bytes:
    return (json.dumps(value, ensure_ascii=False, sort_keys=True, separators=(",", ":")) + "\n").encode("utf-8")


def source_for(ir: dict[str, object]) -> str:
    # الساحة لا تحمل إلا الحقول الخمسة التي يثبتها العقد؛ بقية العقد يفحصها Python.
    directory = str(ir.get("dir", ""))
    version = str(ir.get("version", ""))
    nodes = ir.get("nodes")
    node_count = len(nodes) if isinstance(nodes, list) else -1
    root = ir.get("root", -1)
    executed = 1 if ir.get("source_ref_executed") is not False else 0
    return "\n".join([
        f'رأس_الدليل ≔ ⟨"{directory}", "{version}", {node_count}, {root}, {executed}⟩',
        'تحقق_الرأس ≡ λس. س = "MAL-DIR"',
        'تحقق_الإصدار ≡ λس. س = "0.1.0"',
        'تحقق_عدد_العقد ≡ λس. س > 0',
        'تحقق_الجذر ≡ λس. س = رأس_الدليل[2]',
        'تحقق_التنفيذ ≡ λس. س = 0',
        'أ ≔ تحقق_الرأس(رأس_الدليل[0]) ∧ تحقق_الإصدار(رأس_الدليل[1])',
        'ب ≔ تحقق_عدد_العقد(رأس_الدليل[2]) ∧ تحقق_الجذر(رأس_الدليل[3])',
        'ج ≔ تحقق_التنفيذ(رأس_الدليل[4])',
        'د ≔ أ ∧ ب ∧ ج',
        '⎕ رأس_الدليل[0]',
        '⎕ (د ؟ "VALID" : "ABSTAIN")',
        '',
    ])


def run(argv: list[str], cwd: Path, env: dict[str, str]) -> tuple[int, str, str]:
    proc = subprocess.run(argv, cwd=cwd, env=env, capture_output=True, text=True, timeout=TIMEOUT, check=False)
    return proc.returncode, proc.stdout.replace("\r\n", "\n").replace("\r", "\n"), proc.stderr.replace("\r\n", "\n").replace("\r", "\n")


def python_decision(ir: dict[str, object]) -> str:
    from extensions.mal_dir_validator import MALDIRValidationError, validate
    try:
        validate(ir)
        return "VALID"
    except MALDIRValidationError:
        return "ABSTAIN"


def main() -> int:
    corpus = json.loads(CORPUS.read_text(encoding="utf-8"))
    cases = list(corpus["cases"])
    # حالات سالبة مستقلة للتحقق من fail-closed، من غير تعديل corpus المجمد.
    base = cases[0]["ir"]
    invalid_header = dict(base)
    invalid_header["version"] = "9.9.9"
    invalid_root = dict(base)
    invalid_root["root"] = 2
    cases.extend([
        {"id": "synthetic_invalid_header", "ir": invalid_header},
        {"id": "synthetic_invalid_root", "ir": invalid_root},
    ])

    TMP.mkdir(parents=True, exist_ok=True)
    env = {
        "PATH": os.environ.get("PATH", ""),
        "PYTHONPATH": str(ROOT / "lexicon"),
        "PYTHONHASHSEED": "0",
        "SOURCE_DATE_EPOCH": "0",
        "LC_ALL": "C.UTF-8",
        "LANG": "C.UTF-8",
        "NO_NETWORK": "1",
    }
    results = []
    try:
        for index, case in enumerate(cases, 1):
            ir = case["ir"]
            stem = f"mal_dual_case_{index:03d}"
            source = TMP / f"{stem}.ar"
            source.write_text(source_for(ir), encoding="utf-8", newline="\n")
            exe = ROOT / stem
            for suffix in ("", ".asm", ".o"):
                (ROOT / f"{stem}{suffix}").unlink(missing_ok=True)
            compile_rc, compile_out, compile_err = run([sys.executable, "math_complete.py", str(source)], ROOT, env)
            ar_status = "ABSTAIN"
            ar_out = ""
            run_rc = None
            if compile_rc == 0 and exe.exists() and os.access(exe, os.X_OK):
                run_rc, ar_out, run_err = run([str(exe)], ROOT, env)
                if run_rc == 0:
                    lines = [line for line in ar_out.splitlines() if line]
                    ar_status = lines[-1] if lines else "ABSTAIN"
            py_status = python_decision(ir)
            decision = "MATCH" if ar_status == py_status else "ABSTAIN_MISMATCH"
            results.append({
                "id": case["id"],
                "decision": decision,
                "ar_status": ar_status,
                "py_status": py_status,
                "compile_rc": compile_rc,
                "run_rc": run_rc,
                "ar_stdout_sha256": hashlib.sha256(ar_out.encode("utf-8")).hexdigest(),
                "compile_stdout_sha256": hashlib.sha256(compile_out.encode("utf-8")).hexdigest(),
                "compile_stderr_sha256": hashlib.sha256(compile_err.encode("utf-8")).hexdigest(),
            })
            for suffix in ("", ".asm", ".o"):
                (ROOT / f"{stem}{suffix}").unlink(missing_ok=True)
    finally:
        for path in TMP.glob("*.ar"):
            path.unlink(missing_ok=True)
        TMP.rmdir() if TMP.exists() and not any(TMP.iterdir()) else None

    failures = sum(1 for result in results if result["decision"] != "MATCH")
    payload = {
        "schema": "MAL_DIR_VALIDATOR_DIFFERENTIAL_v0.1",
        "cases": results,
        "matches": len(results) - failures,
        "failures": failures,
        "source_execution": "PERFORMED_ON_GENERATED_TRUSTED_FIXTURES",
        "auto_promotion": "DENY",
    }
    OUT.write_bytes(canonical(payload))
    print("MAL_DIR_DIFFERENTIAL=PASS" if failures == 0 else "MAL_DIR_DIFFERENTIAL=FAIL")
    print(f"CASES={len(results)}")
    print(f"MATCHES={len(results) - failures}")
    print(f"FAILURES={failures}")
    print("SOURCE_EXECUTION=PERFORMED_ON_GENERATED_TRUSTED_FIXTURES")
    print("AUTO_PROMOTION=DENY")
    return 0 if failures == 0 else 1


if __name__ == "__main__":
    raise SystemExit(main())
