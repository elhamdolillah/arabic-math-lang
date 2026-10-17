#!/usr/bin/env python3
"""مقارنة حتمية لمدقق MAL-DIR v0.2 العربي ومدقق Python."""
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
OUT = ROOT / "evidence/MAL_DIR_VALIDATOR_DIFFERENTIAL_V02.json"
TMP = ROOT / "evidence/.mal_dir_dual_tmp"
TIMEOUT = 10
KNOWN = {
    "program": 1, "type": 2, "literal_real": 3, "literal_int": 4,
    "literal_text": 5, "name": 6, "literal_bool": 7, "binary": 8,
    "call": 9, "decl": 10, "return": 11, "block": 12, "if": 13,
    "loop": 14, "function": 15, "struct": 16,
}
FORBIDDEN_KEYS = {"pointer", "ptr", "address", "callable", "execute", "eval", "exec"}


def canonical(value: object) -> bytes:
    return (json.dumps(value, ensure_ascii=False, sort_keys=True, separators=(",", ":")) + "\n").encode("utf-8")


def ar_num(value: int) -> str:
    return str(int(value))


def conjunction(items: list[str]) -> str:
    return " ∧ ".join(items) if items else "1 = 1"


def source_for(ir: dict[str, object]) -> str:
    nodes = ir.get("nodes")
    rows: list[list[int]] = []
    flat_children: list[int] = []
    node_checks: list[str] = []
    child_checks: list[str] = []
    if not isinstance(nodes, list):
        nodes = []
    for expected_id, raw in enumerate(nodes, 1):
        node = raw if isinstance(raw, dict) else {}
        children = node.get("children", [])
        if not isinstance(children, list):
            children = []
        start = len(flat_children) + 1 if children else 0
        count = len(children)
        flat_children.extend(int(child) if isinstance(child, int) else 0 for child in children)
        kind_code = KNOWN.get(str(node.get("kind", "")), 0)
        forbidden = 1 if any(key in FORBIDDEN_KEYS for key in node) else 0
        node_id = node.get("id") if isinstance(node.get("id"), int) else 0
        rows.append([int(node_id), kind_code, start, count, forbidden])
        base = (expected_id - 1) * 5
        node_checks.extend([
            f"ساحة_العقد[{base}] = {ar_num(expected_id)}",
            f"ساحة_العقد[{base + 1}] > 0 ∧ ساحة_العقد[{base + 1}] < 17",
            f"ساحة_العقد[{base + 4}] = 0",
            f"ساحة_العقد[{base + 2}] > -1",
            f"ساحة_العقد[{base + 3}] > -1",
        ])
        for offset, child in enumerate(children):
            flat_index = start + offset
            child_value = int(child) if isinstance(child, int) else 0
            child_checks.extend([
                f"أبناء[{flat_index - 1}] = {ar_num(child_value)}",
                f"أبناء[{flat_index - 1}] > 0",
                f"أبناء[{flat_index - 1}] < {ar_num(expected_id)}",
            ])
    total_children = len(flat_children)
    for row_index in range(len(rows)):
        base = row_index * 5
        node_checks.append(f"{total_children + 1} > ساحة_العقد[{base + 2}] + ساحة_العقد[{base + 3}] - 1")
    directory = str(ir.get("dir", ""))
    version = str(ir.get("version", ""))
    node_count = len(nodes)
    root = ir.get("root", -1)
    executed = 1 if ir.get("source_ref_executed") is not False else 0
    flat_nodes = [value for row in rows for value in row]
    rows_text = "⟨" + ", ".join(ar_num(v) for v in flat_nodes) + "⟩"
    children_text = "⟨" + ", ".join(ar_num(v) for v in flat_children) + "⟩" if flat_children else "⟨0⟩"
    return "\n".join([
        f'رأس_الدليل ≔ ⟨"{directory}", "{version}", {ar_num(node_count)}, {ar_num(root) if isinstance(root, int) else "-1"}, {ar_num(executed)}⟩',
        f"ساحة_العقد ≔ {rows_text if rows else '⟨0, 0, 0, 0, 1⟩'}",
        f"أبناء ≔ {children_text}",
        'تحقق_الرأس ≡ λس. س = "MAL-DIR"',
        'تحقق_الإصدار ≡ λس. س = "0.1.0"',
        'تحقق_عدد_العقد ≡ λس. س > 0',
        'تحقق_الجذر ≡ λس. س = رأس_الدليل[2]',
        'تحقق_التنفيذ ≡ λس. س = 0',
        f"الرأس_صالح ≔ تحقق_الرأس(رأس_الدليل[0]) ∧ تحقق_الإصدار(رأس_الدليل[1])",
        f"الهيكل_صالح ≔ تحقق_عدد_العقد(رأس_الدليل[2]) ∧ تحقق_الجذر(رأس_الدليل[3])",
        f"العقد_صحيحة ≔ {conjunction(node_checks)}",
        f"مراجع_صحيحة ≔ {conjunction(child_checks)}",
        'التنفيذ_صالح ≔ تحقق_التنفيذ(رأس_الدليل[4])',
        'المدقق_صالح ≔ الرأس_صالح ∧ الهيكل_صالح ∧ العقد_صحيحة ∧ مراجع_صحيحة ∧ التنفيذ_صالح',
        '⎕ رأس_الدليل[0]',
        '⎕ (المدقق_صالح ؟ "VALID" : "ABSTAIN")',
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
    base = cases[0]["ir"]
    invalid_header = dict(base)
    invalid_header["version"] = "9.9.9"
    invalid_root = dict(base)
    invalid_root["root"] = 2
    invalid_kind = json.loads(json.dumps(base))
    invalid_kind["nodes"][0]["kind"] = "unknown_kind"
    invalid_child = json.loads(json.dumps(base))
    invalid_child["nodes"][0]["children"] = [1]
    invalid_exec = dict(base)
    invalid_exec["source_ref_executed"] = True
    cases.extend([
        {"id": "synthetic_invalid_header", "ir": invalid_header},
        {"id": "synthetic_invalid_root", "ir": invalid_root},
        {"id": "synthetic_invalid_kind", "ir": invalid_kind},
        {"id": "synthetic_invalid_child", "ir": invalid_child},
        {"id": "synthetic_invalid_execution", "ir": invalid_exec},
    ])
    TMP.mkdir(parents=True, exist_ok=True)
    env = {
        "PATH": os.environ.get("PATH", ""), "PYTHONPATH": str(ROOT / "lexicon"),
        "PYTHONHASHSEED": "0", "SOURCE_DATE_EPOCH": "0", "LC_ALL": "C.UTF-8",
        "LANG": "C.UTF-8", "NO_NETWORK": "1",
    }
    results = []
    try:
        for index, case in enumerate(cases, 1):
            ir = case["ir"]
            stem = f"mal_dual_v02_case_{index:03d}"
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
                run_rc, ar_out, _ = run([str(exe)], ROOT, env)
                if run_rc == 0:
                    lines = [line for line in ar_out.splitlines() if line]
                    ar_status = lines[-1] if lines else "ABSTAIN"
            py_status = python_decision(ir)
            decision = "MATCH" if ar_status == py_status else "ABSTAIN_MISMATCH"
            results.append({
                "id": case["id"], "decision": decision, "ar_status": ar_status,
                "py_status": py_status, "compile_rc": compile_rc, "run_rc": run_rc,
                "ar_stdout_sha256": hashlib.sha256(ar_out.encode("utf-8")).hexdigest(),
                "compile_stdout_sha256": hashlib.sha256(compile_out.encode("utf-8")).hexdigest(),
                "compile_stderr_sha256": hashlib.sha256(compile_err.encode("utf-8")).hexdigest(),
            })
            for suffix in ("", ".asm", ".o"):
                (ROOT / f"{stem}{suffix}").unlink(missing_ok=True)
    finally:
        for path in TMP.glob("*.ar"):
            path.unlink(missing_ok=True)
        if TMP.exists() and not any(TMP.iterdir()):
            TMP.rmdir()
    failures = sum(1 for result in results if result["decision"] != "MATCH")
    payload = {
        "schema": "MAL_DIR_VALIDATOR_DIFFERENTIAL_v0.2",
        "cases": results, "matches": len(results) - failures, "failures": failures,
        "source_execution": "PERFORMED_ON_GENERATED_TRUSTED_FIXTURES",
        "auto_promotion": "DENY",
    }
    OUT.write_bytes(canonical(payload))
    print("MAL_DIR_DIFFERENTIAL_V02=PASS" if failures == 0 else "MAL_DIR_DIFFERENTIAL_V02=FAIL")
    print(f"CASES={len(results)}")
    print(f"MATCHES={len(results) - failures}")
    print(f"FAILURES={failures}")
    print("SOURCE_EXECUTION=PERFORMED_ON_GENERATED_TRUSTED_FIXTURES")
    print("AUTO_PROMOTION=DENY")
    return 0 if failures == 0 else 1


if __name__ == "__main__":
    raise SystemExit(main())
