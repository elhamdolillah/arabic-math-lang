from __future__ import annotations
import json
from pathlib import Path

path = Path(__file__).resolve().parents[1] / "manifest.json"
data = json.loads(path.read_text(encoding="utf-8"))
components = data["components"]
new = [
    {
        "id": "hardware/native-execution-probe-v1",
        "kind": "runtime",
        "path": "vnext/tools/native_execution_probe.py",
        "owner": "uori-v9-hardware",
        "evidence_mode": "DETERMINISTIC",
        "status": "implemented",
        "max_error": 0,
        "depends_on": ["hardware/probe-classification", "runtime/kernel-runtime-bridge-v1"]
    },
    {
        "id": "test/native-execution-probe-v1",
        "kind": "test",
        "path": "vnext/tests/test_native_execution_probe.py",
        "owner": "uori-v9-hardware",
        "evidence_mode": "DETERMINISTIC",
        "status": "verified",
        "max_error": 0,
        "depends_on": ["hardware/native-execution-probe-v1"]
    }
]
ids = {item["id"] for item in components}
for item in new:
    if item["id"] not in ids:
        components.append(item)
data["components"] = components
path.write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
print("MANIFEST_NATIVE_UPDATED=YES")
print(f"COMPONENTS={len(components)}")
