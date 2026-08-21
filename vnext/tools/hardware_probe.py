#!/usr/bin/env python3
"""مجس بيئة التنفيذ لتمييز العتاد الأصلي من الافتراضية بأدلة قابلة للحفظ."""
from __future__ import annotations

import hashlib
import json
import platform
from pathlib import Path
from typing import Mapping


def _sha(value: object) -> str:
    raw = json.dumps(value, ensure_ascii=False, sort_keys=True, separators=(",", ":")).encode()
    return hashlib.sha256(raw).hexdigest()


def classify(uname_machine: str, systemd_virt: str = "", cpu_flags: str = "") -> dict[str, object]:
    machine = uname_machine.strip()
    virtualization = systemd_virt.strip().lower()
    if virtualization and virtualization not in {"none", "unknown"}:
        execution = "VIRTUALIZED"
    elif machine in {"x86_64", "aarch64", "arm64"}:
        execution = "NATIVE_CANDIDATE"
    else:
        execution = "INSUFFICIENT-EVIDENCE"
    return {
        "machine": machine,
        "virtualization": virtualization or "unknown",
        "cpu_flags_sha256": hashlib.sha256(cpu_flags.encode()).hexdigest(),
        "execution_class": execution,
        "evidence_mode": "DETERMINISTIC",
        "hardware_proof": False,
    }


def probe() -> dict[str, object]:
    virt = ""
    detect = Path("/usr/bin/systemd-detect-virt")
    if detect.exists():
        import subprocess
        completed = subprocess.run([str(detect)], capture_output=True, text=True, check=False)
        virt = completed.stdout.strip()
    flags = ""
    cpuinfo = Path("/proc/cpuinfo")
    if cpuinfo.exists():
        flags = " ".join(line.strip() for line in cpuinfo.read_text(errors="replace").splitlines() if "flags" in line or "Features" in line)
    result = classify(platform.machine(), virt, flags)
    result["probe_hash"] = _sha(result)
    return result


if __name__ == "__main__":
    print(json.dumps(probe(), ensure_ascii=False, indent=2, sort_keys=True))
