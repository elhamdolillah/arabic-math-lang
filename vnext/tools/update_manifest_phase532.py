from __future__ import annotations
import json
from pathlib import Path

path = Path(__file__).resolve().parents[1] / "manifest.json"
data = json.loads(path.read_text(encoding="utf-8"))
components = data["components"]
new = [
    {
        "id": "runtime/kernel-runtime-bridge-v1",
        "kind": "runtime",
        "path": "vnext/tools/kernel_runtime_bridge.py",
        "owner": "uori-v9-integration",
        "evidence_mode": "DETERMINISTIC",
        "status": "implemented",
        "max_error": 0,
        "depends_on": ["abi/v1-deterministic-lowering", "kernel/gateway-v1", "runtime/execution-pipeline-v1", "file/pipeline-audit-v1", "file/acceptance-gate-v1"]
    },
    {
        "id": "test/kernel-runtime-bridge-v1",
        "kind": "test",
        "path": "vnext/tests/test_kernel_runtime_bridge.py",
        "owner": "uori-v9-integration",
        "evidence_mode": "DETERMINISTIC",
        "status": "verified",
        "max_error": 0,
        "depends_on": ["runtime/kernel-runtime-bridge-v1"]
    }
]
ids = {item["id"] for item in components}
for item in new:
    if item["id"] not in ids:
        components.append(item)
data["components"] = components
path.write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
print("MANIFEST_UPDATED=YES")
print(f"COMPONENTS={len(components)}")
