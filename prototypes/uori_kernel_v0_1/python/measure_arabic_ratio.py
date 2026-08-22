"""قياس محافظ لنسبة ملفات وأسطر المصدر العربي الرياضي المتتبعة في Git."""
from __future__ import annotations

import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
SOURCE_SUFFIXES = {".py", ".asm", ".sh", ".v", ".rs", ".wat", ".json", ".ar"}


def tracked_files() -> list[Path]:
    raw = subprocess.check_output(["git", "ls-files", "-z"], cwd=ROOT)
    return [ROOT / item for item in raw.decode().split("\0") if item]


def line_count(path: Path) -> int:
    try:
        return len(path.read_text(encoding="utf-8").splitlines())
    except (UnicodeDecodeError, OSError):
        return 0


def main() -> None:
    files = [path for path in tracked_files() if path.suffix in SOURCE_SUFFIXES]
    arabic = [path for path in files if path.suffix == ".ar"]
    total_lines = sum(line_count(path) for path in files)
    arabic_lines = sum(line_count(path) for path in arabic)
    if not files or not total_lines:
        raise SystemExit("لا توجد ملفات مصدر قابلة للقياس")
    print(f"SOURCE_FILES={len(files)}")
    print(f"SOURCE_LINES={total_lines}")
    print(f"ARABIC_FILES={len(arabic)}")
    print(f"ARABIC_LINES={arabic_lines}")
    print(f"ARABIC_FILE_RATIO={len(arabic) / len(files) * 100:.4f}%")
    print(f"ARABIC_LINE_RATIO={arabic_lines / total_lines * 100:.4f}%")


if __name__ == "__main__":
    main()
