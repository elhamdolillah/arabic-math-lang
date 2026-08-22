"""توليد آثار وصفية من عقد ABI العربي؛ الملفات الناتجة ليست مصدر صلاحيات."""
from __future__ import annotations

import json
from pathlib import Path

from arabic_abi import validate_abi


def generate(abi_path: str | Path, json_path: str | Path, shell_path: str | Path) -> None:
    summary = validate_abi(abi_path)
    lines = [line.strip() for line in Path(abi_path).read_text(encoding="utf-8").splitlines()]
    fields = {}
    calls = []
    for line in lines:
        if not line or line.startswith("#"):
            continue
        if line.startswith("نداء:"):
            calls.append(line.split(":", 1)[1].strip())
        elif ":" in line:
            key, value = (part.strip() for part in line.split(":", 1))
            fields[key] = value
    payload = {"interface": fields.get("واجهة_النواة"), "version": fields.get("الإصدار"), "calls": calls, "summary": summary}
    Path(json_path).write_text(json.dumps(payload, ensure_ascii=False, sort_keys=True, indent=2) + "\n", encoding="utf-8")
    shell = "#!/bin/sh\n# مولد من uori_abi.ar؛ لا يمنح صلاحية تنفيذ أو عتاد.\n"
    shell += "UORI_ABI_INTERFACE='" + str(payload["interface"]) + "'\n"
    shell += "UORI_ABI_VERSION='" + str(payload["version"]) + "'\n"
    shell += "UORI_ABI_CALLS='" + "|".join(calls) + "'\n"
    Path(shell_path).write_text(shell, encoding="utf-8")


if __name__ == "__main__":
    root = Path(__file__).parents[1]
    generate(root / "source" / "uori_abi.ar", root / "generated" / "uori_abi.json", root / "generated" / "uori_abi.sh")
