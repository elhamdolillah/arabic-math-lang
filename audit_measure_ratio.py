#!/usr/bin/env python3
import hashlib
import json
import os
import sys
from pathlib import Path

ROOT = Path(sys.argv[1]).resolve()
EXCLUDED_DIRS = {'.git', '__pycache__', '.buildozer', 'node_modules', '.venv', 'venv'}
BINARY_EXTS = {'.png', '.jpg', '.jpeg', '.gif', '.webp', '.ico', '.pdf', '.whl', '.so', '.o', '.a', '.wasm', '.pyc', '.zip', '.gz', '.tar', '.pptx', '.mp4', '.mp3'}
CATEGORIES = {'.ar': 'arabic_math_lang', '.py': 'python', '.json': 'json', '.asm': 'assembly', '.s': 'assembly', '.html': 'web_frontend', '.htm': 'web_frontend', '.js': 'web_frontend', '.css': 'web_frontend', '.wat': 'wasm', '.wasm': 'wasm'}
COMMENT_PREFIXES = {'.py': ('#',), '.ar': ('#', '//', '؛'), '.json': (), '.asm': (';',), '.s': (';',), '.js': ('//',), '.css': ('/*', '*', '*/'), '.html': ('<!--',), '.htm': ('<!--',)}

def count_sloc(path):
    ext = path.suffix.lower()
    if ext in BINARY_EXTS:
        return 0
    try:
        raw = path.read_bytes()
        text = raw.decode('utf-8')
    except (OSError, UnicodeDecodeError):
        return 0
    prefixes = COMMENT_PREFIXES.get(ext, ())
    count = 0
    for line in text.splitlines():
        stripped = line.strip()
        if not stripped:
            continue
        if prefixes and any(stripped.startswith(p) for p in prefixes):
            continue
        count += 1
    return count

rows = []
for p in sorted(ROOT.rglob('*'), key=lambda x: x.relative_to(ROOT).as_posix()):
    if not p.is_file():
        continue
    rel_parts = p.relative_to(ROOT).parts
    if any(part in EXCLUDED_DIRS for part in rel_parts):
        continue
    ext = p.suffix.lower()
    cat = CATEGORIES.get(ext, 'other')
    sloc = count_sloc(p)
    if sloc:
        rows.append((p.relative_to(ROOT).as_posix(), cat, sloc))

counts = {}
for _, cat, sloc in rows:
    counts[cat] = counts.get(cat, 0) + sloc
all_sloc = sum(counts.values())
ar = counts.get('arabic_math_lang', 0)
py = counts.get('python', 0)
report = {
    'schema': 'UORI-MAL-SLOC-RATIO-0.1',
    'root': str(ROOT),
    'source_date_epoch': os.environ.get('SOURCE_DATE_EPOCH', ''),
    'excluded_dirs': sorted(EXCLUDED_DIRS),
    'counts_sloc': dict(sorted(counts.items())),
    'total_sloc': all_sloc,
    'arabic_math_lang_vs_all_percent': round(ar * 100 / all_sloc, 8) if all_sloc else 0.0,
    'arabic_math_lang_vs_python_percent': round(ar * 100 / (ar + py), 8) if (ar + py) else 0.0,
    'python_vs_all_percent': round(py * 100 / all_sloc, 8) if all_sloc else 0.0,
    'file_count_counted': len(rows),
    'files_sorted_sha256': hashlib.sha256('\n'.join(f'{rel}\0{cat}\0{sloc}' for rel, cat, sloc in rows).encode()).hexdigest(),
}
print(json.dumps(report, ensure_ascii=False, indent=2, sort_keys=True))
