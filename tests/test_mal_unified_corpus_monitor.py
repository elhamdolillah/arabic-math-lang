#!/usr/bin/env python3
"""Tests for the fail-closed unified corpus checksum monitor."""
from __future__ import annotations

import hashlib
import subprocess
import sys
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
MONITOR = ROOT / "scripts" / "monitor_mal_unified_corpus.py"


def run_monitor(corpus: Path, expected: str) -> subprocess.CompletedProcess[str]:
    return subprocess.run(
        [
            sys.executable,
            str(MONITOR),
            "--corpus",
            str(corpus),
            "--expected-sha256",
            expected,
        ],
        cwd=ROOT,
        text=True,
        capture_output=True,
        check=False,
    )


def main() -> int:
    with tempfile.TemporaryDirectory() as directory:
        corpus = Path(directory) / "corpus.json"
        corpus.write_bytes(b'{"deterministic":true}\n')
        expected = hashlib.sha256(corpus.read_bytes()).hexdigest()

        matched = run_monitor(corpus, expected)
        assert matched.returncode == 0, matched.stdout + matched.stderr
        assert "CHECKSUM_MATCH=YES" in matched.stdout
        assert "STATUS=0" in matched.stdout

        corpus.write_bytes(b'{"deterministic":false}\n')
        mismatched = run_monitor(corpus, expected)
        assert mismatched.returncode == 1
        assert "CHECKSUM_MATCH=NO" in mismatched.stdout
        assert "STATUS=1" in mismatched.stdout

        missing = run_monitor(Path(directory) / "missing.json", expected)
        assert missing.returncode == 1
        assert "CORPUS_PRESENT=NO" in missing.stdout
        assert "STATUS=1" in missing.stdout

    print("MAL_UNIFIED_CORPUS_MONITOR_TEST=PASS")
    print("FAIL_CLOSED_MISMATCH=PASS")
    print("FAIL_CLOSED_MISSING=PASS")
    print("STATUS=0")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
