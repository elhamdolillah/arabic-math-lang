#!/usr/bin/env python3
import json
import subprocess
import sys
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
GEN = ROOT / "tools" / "generate_result_contract.py"
VAL = ROOT / "tools" / "validate_result_contract.py"
SPEC = ROOT / "specs" / "functions" / "watar.json"


def run_validator(value):
    with tempfile.NamedTemporaryFile("w", suffix=".json", encoding="utf-8", delete=False) as handle:
        json.dump(value, handle, ensure_ascii=False)
        path = handle.name
    try:
        return subprocess.run([sys.executable, str(VAL), path], capture_output=True, text=True)
    finally:
        Path(path).unlink(missing_ok=True)


result = subprocess.run(
    [sys.executable, str(GEN), str(SPEC)], capture_output=True, text=True, check=True
)
contract = json.loads(result.stdout)
assert run_validator(contract).returncode == 0
print("UORI_VALIDATOR_VALID_CONTRACT=PASS")

missing = dict(contract)
missing.pop("الدالة")
assert run_validator(missing).returncode != 0
print("UORI_VALIDATOR_REQUIRED_FIELD_REJECTION=PASS")

mismatch = dict(contract)
mismatch["وسم_الدليل"] = "DETERMINISTIC"
assert run_validator(mismatch).returncode != 0
print("UORI_VALIDATOR_EVIDENCE_MISMATCH_REJECTION=PASS")

medical = dict(contract)
medical["الاستخدام_المسموح"] = ["تشخيص آلي"]
assert run_validator(medical).returncode != 0
print("UORI_VALIDATOR_MEDICAL_SAFETY_REJECTION=PASS")

bounded = dict(contract)
bounded["نمط_الاستدلال"] = "حتمي"
bounded["حالة_الدليل"] = "كافٍ"
bounded["وسم_الدليل"] = "DETERMINISTIC"
bounded["التقريب"] = dict(contract["التقريب"], **{"حد_الخطأ": 16})
assert run_validator(bounded).returncode == 0
print("UORI_VALIDATOR_DETERMINISTIC_ACCEPTANCE=PASS")
