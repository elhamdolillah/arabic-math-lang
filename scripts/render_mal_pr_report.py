#!/usr/bin/env python3
"""Render a stable Arabic PR summary from a canonical comparison JSON file."""
from __future__ import annotations

import argparse
import json
from pathlib import Path


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--comparison", required=True, type=Path)
    parser.add_argument("--output", required=True, type=Path)
    args = parser.parse_args()

    data = json.loads(args.comparison.read_text(encoding="utf-8"))
    required = {"schema", "status", "execution", "network", "manifests", "unique_comparable_sha256"}
    missing = sorted(required - set(data))
    if missing:
        raise SystemExit(f"REPORT=ABSTAIN\nREASON=MISSING_FIELDS:{','.join(missing)}")
    if data["schema"] != "mal-cross-env-comparison-v0.1":
        raise SystemExit("REPORT=ABSTAIN\nREASON=SCHEMA_MISMATCH")

    manifests = sorted(data["manifests"], key=lambda item: item["environment_label"])
    digest = data["unique_comparable_sha256"][0] if len(data["unique_comparable_sha256"]) == 1 else "غير متطابقة"
    status = "PASS" if data["status"] == "PASS" and len(data["unique_comparable_sha256"]) == 1 else "FAIL"
    lines = [
        "## تدقيق MAL الحتمي للبصمات المتقاطعة",
        "",
        f"**الحالة:** `{status}`  ",
        f"**المخطط:** `{data['schema']}`  ",
        f"**عدد البيئات:** `{len(manifests)}`  ",
        f"**عدد البصمات المختلفة:** `{len(data['unique_comparable_sha256'])}`  ",
        f"**البصمة القابلة للمقارنة:** `{digest}`  ",
        f"**التنفيذ:** `{data['execution']}`  ",
        f"**الشبكة:** `{data['network']}`",
        "",
        "| البيئة | الملف | comparable SHA-256 |",
        "|---|---|---|",
    ]
    for item in manifests:
        lines.append(f"| `{item['environment_label']}` | `{item['file']}` | `{item['comparable_sha256']}` |")
    lines += [
        "",
        "> هذا التقرير ناتج عن مقارنة canonical manifests. تطابقه لا يعني السماح بتنفيذ المصدر؛ `ALLOW` هنا قبول ساكن فقط.",
        "",
        "<!-- mal-cross-env-sha256-report -->",
    ]
    args.output.write_text("\n".join(lines) + "\n", encoding="utf-8")
    print(f"PR_REPORT={status}")
    print(f"PR_ENVIRONMENTS={len(manifests)}")
    print(f"PR_UNIQUE_DIGESTS={len(data['unique_comparable_sha256'])}")
    return 0 if status == "PASS" else 1


if __name__ == "__main__":
    raise SystemExit(main())
