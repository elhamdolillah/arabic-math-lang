#!/usr/bin/env python3
import json
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
GENERATOR = ROOT / "tools" / "generate_result_contract.py"
WATAR = ROOT / "specs" / "functions" / "watar.json"


def generate(spec_path: Path) -> dict:
    completed = subprocess.run(
        [sys.executable, str(GENERATOR), str(spec_path)],
        cwd=ROOT,
        check=True,
        capture_output=True,
        text=True,
    )
    return json.loads(completed.stdout)


def write_spec(payload: dict) -> Path:
    path = ROOT / "tests" / ".tmp_evidence_policy_spec.json"
    path.write_text(json.dumps(payload, ensure_ascii=False), encoding="utf-8")
    return path


def main() -> None:
    generated = generate(WATAR)
    assert generated["نمط_الاستدلال"] == "امتناع"
    assert generated["حالة_الدليل"] == "غير_كافٍ"
    assert generated["وسم_الدليل"] == "INSUFFICIENT-EVIDENCE"
    assert generated["سبب_الامتناع"]

    base = json.loads(WATAR.read_text(encoding="utf-8"))
    base["نمط_الاستدلال"] = "حتمي"
    base["حالة_الدليل"] = "كافٍ"
    base["وسم_الدليل"] = "DETERMINISTIC"
    explicit_path = write_spec(base)
    try:
        generated = generate(explicit_path)
        assert generated["نمط_الاستدلال"] == "حتمي"
        assert generated["وسم_الدليل"] == "DETERMINISTIC"
    finally:
        explicit_path.unlink(missing_ok=True)

    inconsistent = json.loads(WATAR.read_text(encoding="utf-8"))
    inconsistent["نمط_الاستدلال"] = "حتمي"
    inconsistent["وسم_الدليل"] = "AI-HYPOTHESIS"
    inconsistent_path = write_spec(inconsistent)
    try:
        failed = subprocess.run(
            [sys.executable, str(GENERATOR), str(inconsistent_path)],
            cwd=ROOT,
            capture_output=True,
            text=True,
        )
        assert failed.returncode != 0
        assert "وسم الدليل لا يوافق" in failed.stderr
    finally:
        inconsistent_path.unlink(missing_ok=True)

    print("UORI_GENERATOR_EVIDENCE_POLICY=PASS")
    print("UORI_GENERATOR_ABSTAIN_DEFAULT=PASS")
    print("UORI_GENERATOR_INCONSISTENCY_REJECTION=PASS")


if __name__ == "__main__":
    main()
