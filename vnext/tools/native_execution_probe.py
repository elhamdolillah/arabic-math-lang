"""تحقق قابل لإعادة الإنتاج من تشغيل UORI في البيئة الحالية دون ادعاء bare metal."""
from __future__ import annotations
import hashlib
import json
import platform
import subprocess
from pathlib import Path
from typing import Any

from hardware_probe import probe
from kernel_runtime_bridge import execute


def _sha(value: Any) -> str:
    raw = json.dumps(value, ensure_ascii=False, sort_keys=True, separators=(",", ":")).encode("utf-8")
    return hashlib.sha256(raw).hexdigest()


def collect() -> dict[str, Any]:
    hardware = probe()
    uname = subprocess.run(["uname", "-a"], capture_output=True, text=True, check=False).stdout.strip()
    execution = execute(({"op": "print", "value": "UORI-NATIVE-CANDIDATE", "line": 1},))
    result = {
        "hardware": hardware,
        "platform": {"system": platform.system(), "release": platform.release(), "machine": platform.machine(), "uname_sha256": _sha(uname)},
        "runtime_status": execution["status"],
        "runtime_output_sha256": _sha(execution["runtime"]["result"]["output"]),
        "native_proof": False,
        "classification": hardware["execution_class"],
        "evidence_mode": "DETERMINISTIC",
    }
    result["probe_hash"] = _sha(result)
    return result


if __name__ == "__main__":
    print(json.dumps(collect(), ensure_ascii=False, indent=2, sort_keys=True))
