from __future__ import annotations
import json
from pathlib import Path

path = Path(__file__).resolve().parents[1] / "manifest.json"
data = json.loads(path.read_text(encoding="utf-8"))
items = [
    {
        "id": "integrity/replay-validator-v1",
        "kind": "runtime",
        "path": "vnext/tools/replay_validator.py",
        "owner": "uori-v9-integrity",
        "evidence_mode": "DETERMINISTIC",
        "status": "implemented",
        "max_error": 0,
        "depends_on": ["runtime/kernel-runtime-bridge-v1", "file/evidence-chain-v1"]
    },
    {
        "id": "test/replay-validator-v1",
        "kind": "test",
        "path": "vnext/tests/test_replay_validator.py",
        "owner": "uori-v9-integrity",
        "evidence_mode": "DETERMINISTIC",
        "status": "verified",
        "max_error": 0,
        "depends_on": ["integrity/replay-validator-v1"]
    }
]
ids = {x["id"] for x in data["components"]}
for item in items:
    if item["id"] not in ids:
        data["components"].append(item)
path.write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
print("MANIFEST_REPLAY_UPDATED=YES")
print(f"COMPONENTS={len(data['components'])}")
