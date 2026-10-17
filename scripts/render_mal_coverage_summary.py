#!/usr/bin/env python3
"""Render a compact Arabic reconnect summary from an audit report."""
from __future__ import annotations

import json
import sys
from pathlib import Path


def main() -> int:
    if len(sys.argv) != 3:
        print("USAGE=render_mal_coverage_summary.py REPORT OUTPUT", file=sys.stderr)
        return 2
    report = json.loads(Path(sys.argv[1]).read_text(encoding="utf-8"))
    candidate = report.get("next_candidate") or {}
    aggregate = report["aggregate"]
    text = "\n".join([
        "# ملخص تدقيق تغطية اللغة العربية الرياضية",
        "",
        f"- القرار: `{report['decision']}`",
        f"- عدد الملفات المقاسة: `{report['file_count']}`",
        f"- نسبة المحارف العربية في المؤشر: `{aggregate['arabic_coverage_ratio']:.8f}`",
        f"- المرشح التالي للمراجعة: `{candidate.get('path', 'NONE')}`",
        "- التنفيذ: `NOT_PERFORMED`",
        "- الشبكة: `DISABLED_BY_CONTRACT`",
        "- تعديل baseline: `NO`",
        "- الدمج التلقائي: `DENY`",
        "",
        "> هذا التقرير يقيس التغطية فقط. لا يترجم المصدر، ولا يثبت التكافؤ الدلالي، ولا يرفع أي ميزة إلى `PROVEN`.",
        "",
    ])
    Path(sys.argv[2]).write_text(text, encoding="utf-8")
    print("MAL_ARABIC_COVERAGE_SUMMARY=PASS")
    print("STATUS=0")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
