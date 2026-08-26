#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
UORI — Language Ratio Analyzer
═══════════════════════════════════════════════════════════════════════════════
يقيس نسبة كود اللغة العربية الرياضية (.ar) مقابل Python وJSON وstdout وباقي
الملفات في المشروع ككل.

الاستخدام:
    python uori_language_ratio.py [مسار_المشروع] [--output تقرير.json]

المؤشرات المُخرَجة:
    - sloc: أسطر المصدر الفعلية (بدون فراغات/تعليقات)
    - ratio: النسبة المئوية
    - abstain_nodes: عدد عقد الامتناع (إن وُجدت)
    - provenance_fingerprint: بصمة SHA-256 للتقرير

المؤلف: HAMDANI SIDI MOHAMED
الترخيص: MIT — بسم الله الرحمن الرحيم
═══════════════════════════════════════════════════════════════════════════════
"""

import os
import sys
import json
import hashlib
import argparse
from pathlib import Path
from collections import defaultdict
from typing import Dict, List, Tuple


# ═══════════════════════════════════════════════════════════════════════════════
# التصنيف
# ═══════════════════════════════════════════════════════════════════════════════

CATEGORIES = {
    "arabic_math_lang": {
        "exts": {".ar"},
        "desc": "اللغة العربية الرياضية (المصدر)",
        "comment_prefixes": ("--", "#"),
    },
    "python": {
        "exts": {".py"},
        "desc": "Python (النواة + الأدوات)",
        "comment_prefixes": ("#",),
    },
    "json": {
        "exts": {".json"},
        "desc": "JSON (بيانات وبصمات)",
        "comment_prefixes": (),  # JSON لا يحتوي على تعليقات
    },
    "stdout_logs": {
        "exts": {".txt", ".log", ".out", ".stdout", ".stderr"},
        "desc": "stdout / سجلات / مخرجات نصية",
        "comment_prefixes": (),
    },
    "web_frontend": {
        "exts": {".html", ".js", ".css", ".mjs"},
        "desc": "واجهة الويب (PWA/WebView)",
        "comment_prefixes": ("//", "/*", "<!--"),
    },
    "assembly": {
        "exts": {".asm", ".s", ".S"},
        "desc": "Assembly (x86/ARM/WASM)",
        "comment_prefixes": (";", "#", "//"),
    },
    "wasm": {
        "exts": {".wasm", ".wat"},
        "desc": "WebAssembly binary/text",
        "comment_prefixes": (";;",),
    },
    "shell": {
        "exts": {".sh", ".bash"},
        "desc": "Shell scripts",
        "comment_prefixes": ("#",),
    },
    "config": {
        "exts": {".yml", ".yaml", ".toml", ".ini", ".cfg", ".spec"},
        "desc": "إعدادات (Buildozer, etc.)",
        "comment_prefixes": ("#",),
    },
    "docs": {
        "exts": {".md", ".rst", ".tex", ".bib"},
        "desc": "توثيق Markdown/LaTeX",
        "comment_prefixes": (),
    },
    "binary_assets": {
        "exts": {".png", ".jpg", ".jpeg", ".webp", ".gif", ".ico", ".ttf", ".woff", ".woff2", ".db", ".zip", ".tar", ".gz"},
        "desc": "ملفات ثنائية (صور/خطوط/أرشيف)",
        "comment_prefixes": (),
    },
    "other": {
        "exts": set(),
        "desc": "أخرى / غير مصنفة",
        "comment_prefixes": (),
    },
}

# ملفات تُستثنى دائماً
EXCLUDE_DIRS = {
    ".git", ".buildozer", "__pycache__", "node_modules",
    ".pytest_cache", ".mypy_cache", "venv", ".venv",
    "build", "dist", "*.egg-info", ".tox", ".coverage",
    "/home/ubuntu/p4a_patched",  # من حزمة المشروع
}

EXCLUDE_FILES = {
    ".gitignore", "*.pyc", "*.pyo", "*.so", "*.dylib", "*.dll",
    "*.class", "*.o", "*.obj", "*.a", "*.lib",
}


# ═══════════════════════════════════════════════════════════════════════════════
# دوال القياس
# ═══════════════════════════════════════════════════════════════════════════════

def classify_file(path: Path) -> str:
    """تصنيف الملف حسب الامتداد."""
    ext = path.suffix.lower()
    for cat, info in CATEGORIES.items():
        if ext in info["exts"]:
            return cat
    return "other"


def is_excluded(path: Path, root: Path) -> bool:
    """التحقق مما إذا كان الملف/المجلد مُستثنى."""
    rel = path.relative_to(root)
    for part in rel.parts:
        if part in EXCLUDE_DIRS:
            return True
        if any(part.endswith(pat.replace("*", "")) for pat in EXCLUDE_DIRS if "*" in pat):
            return True
    if path.name in EXCLUDE_FILES:
        return True
    for pat in EXCLUDE_FILES:
        if "*" in pat and path.name.endswith(pat.replace("*", "")):
            return True
    return False


def count_sloc(lines: List[str], comment_prefixes: Tuple[str, ...]) -> int:
    """
    حساب Source Lines of Code (SLOC):
    - تستبعد الأسطر الفارغة
    - تستبعد التعليقات (حسب بادئة التعليق)
    - تستبعد الأسطر التي تحتوي فقط على فراغات
    """
    count = 0
    in_block_comment = False

    for raw in lines:
        line = raw.strip()
        if not line:
            continue

        # تعليقات كتلة /* */
        if "/*" in line:
            in_block_comment = True
        if "*/" in line:
            in_block_comment = False
            continue
        if in_block_comment:
            continue

        # تعليقات سطرية
        is_comment = any(line.startswith(p) for p in comment_prefixes)
        if is_comment:
            continue

        count += 1

    return count


def count_abstain_nodes(lines: List[str]) -> int:
    """عد عقد الامتناع (abstain) في كود اللغة العربية."""
    count = 0
    for line in lines:
        stripped = line.strip()
        if "امتنع" in stripped or "abstain" in stripped.lower():
            count += 1
    return count


def sha256_file(path: Path) -> str:
    """حساب بصمة SHA-256 لملف."""
    h = hashlib.sha256()
    with open(path, "rb") as f:
        for chunk in iter(lambda: f.read(8192), b""):
            h.update(chunk)
    return h.hexdigest()


# ═══════════════════════════════════════════════════════════════════════════════
# المحرك الرئيسي
# ═══════════════════════════════════════════════════════════════════════════════

def analyze_project(project_root: Path) -> Dict:
    """تحليل المشروع كامل وإرجاع التقرير."""

    stats = defaultdict(lambda: {
        "files": 0,
        "sloc": 0,
        "bytes": 0,
        "abstain_nodes": 0,
    })

    file_list = []

    for path in sorted(project_root.rglob("*"), key=lambda candidate: candidate.relative_to(project_root).as_posix()):
        if path.is_dir():
            continue
        if is_excluded(path, project_root):
            continue

        cat = classify_file(path)
        stats[cat]["files"] += 1
        stats[cat]["bytes"] += path.stat().st_size

        try:
            with open(path, "r", encoding="utf-8", errors="replace") as f:
                lines = f.readlines()
        except (UnicodeDecodeError, PermissionError):
            lines = []

        prefixes = CATEGORIES.get(cat, CATEGORIES["other"])["comment_prefixes"]
        sloc = count_sloc(lines, prefixes)
        stats[cat]["sloc"] += sloc

        if cat == "arabic_math_lang":
            stats[cat]["abstain_nodes"] += count_abstain_nodes(lines)

        file_list.append({
            "path": str(path.relative_to(project_root)),
            "category": cat,
            "sloc": sloc,
            "size": path.stat().st_size,
            "sha256": sha256_file(path),
        })

    # ── الحسابات الإجمالية ──
    total_sloc = sum(v["sloc"] for v in stats.values())
    total_files = sum(v["files"] for v in stats.values())
    total_bytes = sum(v["bytes"] for v in stats.values())
    total_abstain = stats["arabic_math_lang"]["abstain_nodes"]

    # ── النسب المئوية ──
    ratios = {}
    for cat in CATEGORIES.keys():
        s = stats[cat]["sloc"]
        ratios[cat] = {
            "sloc": s,
            "files": stats[cat]["files"],
            "bytes": stats[cat]["bytes"],
            "abstain_nodes": stats[cat]["abstain_nodes"],
            "ratio_sloc": round((s / total_sloc * 100), 2) if total_sloc else 0.0,
            "ratio_files": round((stats[cat]["files"] / total_files * 100), 2) if total_files else 0.0,
        }

    # ── المؤشرات الرئيسية ──
    arabic_sloc = ratios["arabic_math_lang"]["sloc"]
    python_sloc = ratios["python"]["sloc"]
    json_sloc = ratios["json"]["sloc"]
    stdout_sloc = ratios["stdout_logs"]["sloc"]
    web_sloc = ratios["web_frontend"]["sloc"]
    asm_sloc = ratios["assembly"]["sloc"]
    wasm_sloc = ratios["wasm"]["sloc"]

    # النسبة المطلوبة: العربية مقابل (Python + JSON + stdout + باقي)
    non_arabic_sloc = total_sloc - arabic_sloc
    arabic_vs_all = round((arabic_sloc / total_sloc * 100), 2) if total_sloc else 0.0
    arabic_vs_python = round((arabic_sloc / (arabic_sloc + python_sloc) * 100), 2) if (arabic_sloc + python_sloc) else 0.0
    python_vs_all = round((python_sloc / total_sloc * 100), 2) if total_sloc else 0.0
    json_vs_all = round((json_sloc / total_sloc * 100), 2) if total_sloc else 0.0
    stdout_vs_all = round((stdout_sloc / total_sloc * 100), 2) if total_sloc else 0.0

    # ── التقرير الحتمي ──
    # المسار والتوقيت ثابتان حتى لا تتغير البصمة بين البيئات.
    epoch = int(os.environ.get("SOURCE_DATE_EPOCH", "0"))
    timestamp = __import__("datetime").datetime.fromtimestamp(epoch, __import__("datetime").timezone.utc).isoformat().replace("+00:00", "Z")
    canonical_body = {
        "analyzer_version": "1.1.0-deterministic",
        "total_sloc": total_sloc,
        "total_files": total_files,
        "total_bytes": total_bytes,
        "key_ratios": {
            "arabic_math_lang_vs_all": f"{arabic_vs_all}%",
            "arabic_math_lang_vs_python": f"{arabic_vs_python}%",
            "python_vs_all": f"{python_vs_all}%",
            "json_vs_all": f"{json_vs_all}%",
            "stdout_logs_vs_all": f"{stdout_vs_all}%",
            "web_frontend_vs_all": f"{round((web_sloc/total_sloc*100),2) if total_sloc else 0}%",
            "assembly_vs_all": f"{round((asm_sloc/total_sloc*100),2) if total_sloc else 0}%",
            "wasm_vs_all": f"{round((wasm_sloc/total_sloc*100),2) if total_sloc else 0}%",
            "non_arabic_vs_all": f"{round((non_arabic_sloc/total_sloc*100),2) if total_sloc else 0}%",
        },
        "abstain_nodes": {
            "total_in_arabic_source": total_abstain,
            "per_1000_sloc": round((total_abstain / arabic_sloc * 1000), 2) if arabic_sloc else 0,
        },
        "categories": ratios,
        "file_manifest": file_list,
    }
    report_payload = json.dumps(canonical_body, sort_keys=True, ensure_ascii=False, separators=(",", ":"))
    report_fingerprint = hashlib.sha256(report_payload.encode("utf-8")).hexdigest()

    report = {
        "meta": {
            "project_root": ".",
            "timestamp": timestamp,
            "analyzer_version": "1.1.0-deterministic",
            "total_sloc": total_sloc,
            "total_files": total_files,
            "total_bytes": total_bytes,
            "report_sha256": report_fingerprint,
        },
        "key_ratios": {
            "arabic_math_lang_vs_all": f"{arabic_vs_all}%",
            "arabic_math_lang_vs_python": f"{arabic_vs_python}%",
            "python_vs_all": f"{python_vs_all}%",
            "json_vs_all": f"{json_vs_all}%",
            "stdout_logs_vs_all": f"{stdout_vs_all}%",
            "web_frontend_vs_all": f"{round((web_sloc/total_sloc*100),2) if total_sloc else 0}%",
            "assembly_vs_all": f"{round((asm_sloc/total_sloc*100),2) if total_sloc else 0}%",
            "wasm_vs_all": f"{round((wasm_sloc/total_sloc*100),2) if total_sloc else 0}%",
            "non_arabic_vs_all": f"{round((non_arabic_sloc/total_sloc*100),2) if total_sloc else 0}%",
        },
        "abstain_nodes": {
            "total_in_arabic_source": total_abstain,
            "per_1000_sloc": round((total_abstain / arabic_sloc * 1000), 2) if arabic_sloc else 0,
        },
        "categories": ratios,
        "file_manifest": file_list,
    }

    return report


def print_report(report: Dict):
    """طباعة التقرير بشكل مقروء."""
    m = report["meta"]
    k = report["key_ratios"]

    print("=" * 70)
    print("  تقرير نسب اللغة — UORI Language Ratio Report")
    print("=" * 70)
    print(f"  المسار: {m['project_root']}")
    print(f"  الوقت:  {m['timestamp']}")
    print(f"  البصمة: {m['report_sha256'][:16]}...")
    print("-" * 70)

    print(f"\n  📊 إجمالي SLOC: {m['total_sloc']:,}  |  الملفات: {m['total_files']:,}")
    print(f"\n  🎯 النسب الرئيسية:")
    print(f"     العربية / الكل:          {k['arabic_math_lang_vs_all']}")
    print(f"     العربية / (عربية+بايثون): {k['arabic_math_lang_vs_python']}")
    print(f"     بايثون / الكل:           {k['python_vs_all']}")
    print(f"     JSON / الكل:             {k['json_vs_all']}")
    print(f"     stdout/logs / الكل:      {k['stdout_logs_vs_all']}")
    print(f"     Web Frontend / الكل:     {k['web_frontend_vs_all']}")
    print(f"     Assembly / الكل:        {k['assembly_vs_all']}")
    print(f"     WASM / الكل:             {k['wasm_vs_all']}")
    print(f"     غير العربية / الكل:     {k['non_arabic_vs_all']}")

    a = report["abstain_nodes"]
    print(f"\n  🛡️ عقد الامتناع (Abstain):")
    print(f"     العدد: {a['total_in_arabic_source']}")
    print(f"     لكل 1000 SLOC: {a['per_1000_sloc']}")

    print(f"\n  📁 التفصيل حسب التصنيف:")
    print(f"     {'التصنيف':<25} {'ملفات':>8} {'SLOC':>10} {'%SLOC':>8}")
    print("     " + "-" * 55)
    for cat, data in report["categories"].items():
        if data["sloc"] > 0 or data["files"] > 0:
            name = CATEGORIES.get(cat, CATEGORIES["other"])["desc"]
            print(f"     {name:<25} {data['files']:>8} {data['sloc']:>10} {data['ratio_sloc']:>7.2f}%")

    print("\n" + "=" * 70)


# ═══════════════════════════════════════════════════════════════════════════════
# الدخول
# ═══════════════════════════════════════════════════════════════════════════════

def main():
    parser = argparse.ArgumentParser(
        description="UORI Language Ratio Analyzer — قياس نسبة كود اللغة العربية الرياضية",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
أمثلة:
  python uori_language_ratio.py ./arabic-math-lang
  python uori_language_ratio.py . --output report.json
  python uori_language_ratio.py . --format markdown
        """
    )
    parser.add_argument("path", nargs="?", default=".", help="مسار جذر المشروع (افتراضي: .)")
    parser.add_argument("-o", "--output", help="حفظ التقرير كـ JSON")
    parser.add_argument("-f", "--format", choices=["json", "markdown", "both"], default="json",
                        help="صيغة الإخراج")
    parser.add_argument("--no-exclude", action="store_true",
                        help="عدم استبعاد .git و buildozer (للتدقيق)")

    args = parser.parse_args()
    root = Path(args.path).resolve()

    if not root.exists():
        print(f"❌ المسار غير موجود: {root}", file=sys.stderr)
        sys.exit(1)

    if args.no_exclude:
        global EXCLUDE_DIRS, EXCLUDE_FILES
        EXCLUDE_DIRS = set()
        EXCLUDE_FILES = set()

    report = analyze_project(root)
    print_report(report)

    if args.output:
        out_path = Path(args.output)
        with open(out_path, "w", encoding="utf-8") as f:
            json.dump(report, f, ensure_ascii=False, indent=2)
        print(f"\n💾 حُفظ التقرير: {out_path}")

    if args.format in ("markdown", "both"):
        md = generate_markdown(report)
        md_path = Path(args.output).with_suffix(".md") if args.output else Path("uori_ratio_report.md")
        with open(md_path, "w", encoding="utf-8") as f:
            f.write(md)
        print(f"💾 حُفظ التقرير Markdown: {md_path}")


def generate_markdown(report: Dict) -> str:
    """توليد تقرير Markdown."""
    m = report["meta"]
    k = report["key_ratios"]

    lines = [
        "# تقرير نسب اللغة — UORI Language Ratio Report",
        "",
        f"**المسار:** `{m['project_root']}`  ",
        f"**الوقت:** {m['timestamp']}  ",
        f"**البصمة:** `{m['report_sha256']}`  ",
        "",
        "## المؤشرات الرئيسية",
        "",
        "| المؤشر | النسبة |",
        "|--------|--------|",
        f"| العربية / الكل | {k['arabic_math_lang_vs_all']} |",
        f"| العربية / (عربية+بايثون) | {k['arabic_math_lang_vs_python']} |",
        f"| بايثون / الكل | {k['python_vs_all']} |",
        f"| JSON / الكل | {k['json_vs_all']} |",
        f"| stdout/logs / الكل | {k['stdout_logs_vs_all']} |",
        f"| Web Frontend / الكل | {k['web_frontend_vs_all']} |",
        f"| Assembly / الكل | {k['assembly_vs_all']} |",
        f"| WASM / الكل | {k['wasm_vs_all']} |",
        f"| غير العربية / الكل | {k['non_arabic_vs_all']} |",
        "",
        "## التفصيل حسب التصنيف",
        "",
        "| التصنيف | الملفات | SLOC | %SLOC | بايت |",
        "|---------|---------|------|-------|------|",
    ]

    for cat, data in report["categories"].items():
        if data["sloc"] > 0 or data["files"] > 0:
            name = CATEGORIES.get(cat, CATEGORIES["other"])["desc"]
            lines.append(
                f"| {name} | {data['files']} | {data['sloc']:,} | {data['ratio_sloc']:.2f}% | {data['bytes']:,} |"
            )

    lines.extend([
        "",
        "## عقد الامتناع (Abstain)",
        "",
        f"- **العدد الإجمالي:** {report['abstain_nodes']['total_in_arabic_source']}",
        f"- **لكل 1000 SLOC:** {report['abstain_nodes']['per_1000_sloc']}",
        "",
        "---",
        "*تقرير مُولَّد تلقائياً بواسطة UORI Language Ratio Analyzer v1.0.0*",
    ])

    return "\n".join(lines)


if __name__ == "__main__":
    main()
