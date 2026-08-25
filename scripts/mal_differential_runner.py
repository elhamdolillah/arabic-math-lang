"""حزام تفاضلي محكوم يقارن mal_runner بنموذج Python مستقل."""

from __future__ import annotations

import hashlib
import json
import subprocess
from pathlib import Path

from mal_reference_model import reference_case

ROOT = Path(__file__).resolve().parents[1]
RUNNER = ROOT / "rust" / "mal_ownership_arena" / "target" / "release" / "mal_runner"
CORPUS_DIRS = (
    ROOT / "corpus" / "stage0_18_files",
    ROOT / "corpus" / "stage1_9_files",
)
OUT = ROOT / "evidence" / "MAL_DIFFERENTIAL_EXECUTION_2026-08-25.json"


def sha256_bytes(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def run_one(path: Path) -> dict[str, object]:
    source = path.read_bytes()
    process = subprocess.run(
        [str(RUNNER), str(path)],
        cwd=ROOT,
        stdin=subprocess.DEVNULL,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        check=False,
    )
    stdout = process.stdout.decode("utf-8", errors="strict")
    stderr = process.stderr.decode("utf-8", errors="strict")
    if process.returncode == 0 and "STATUS=PARSED" in stdout:
        status = "PARSED_EXTENSION_SCOPED"
    elif "STATUS=ABSTAIN" in stdout:
        status = "ABSTAIN"
    else:
        status = "FAIL"

    expected = reference_case(path)
    actual_digest = sha256_bytes(stdout.encode("utf-8"))
    reference_digest = sha256_bytes(str(expected["stdout"]).encode("utf-8"))
    matches = (
        status == expected["status"]
        and stdout == expected["stdout"]
        and process.returncode == (0 if expected["status"] == "PARSED_EXTENSION_SCOPED" else 1)
    )
    return {
        "file": path.relative_to(ROOT).as_posix(),
        "file_sha256": sha256_bytes(source),
        "exit_code": process.returncode,
        "status": status,
        "stdout": stdout,
        "stderr": stderr,
        "reference_status": expected["status"],
        "reference_stdout": expected["stdout"],
        "rust_output_sha256": actual_digest,
        "reference_output_sha256": reference_digest,
        "canonical_match": matches,
    }


def main() -> int:
    cases: list[dict[str, object]] = []
    missing: list[str] = []
    for directory in CORPUS_DIRS:
        if not directory.is_dir():
            missing.append(directory.relative_to(ROOT).as_posix())
            continue
        for path in sorted(directory.glob("*.ar"), key=lambda item: item.name.encode("utf-8")):
            cases.append(run_one(path))

    counts = {"parsed": 0, "abstain": 0, "fail": 0}
    for case in cases:
        status = case["status"]
        if status == "PARSED_EXTENSION_SCOPED":
            counts["parsed"] += 1
        elif status == "ABSTAIN":
            counts["abstain"] += 1
        else:
            counts["fail"] += 1

    all_match = bool(cases) and not missing and all(bool(case["canonical_match"]) for case in cases)
    reference_comparison = "MATCHED_CANONICAL" if all_match else "MISMATCH_OR_INCOMPLETE"
    differential_status = "MATCHED_CANONICAL" if all_match else "ABSTAIN"
    report = {
        "schema": "MAL_DIFFERENTIAL_EXECUTION_v0.2",
        "runner": RUNNER.relative_to(ROOT).as_posix(),
        "corpus_dirs": [directory.relative_to(ROOT).as_posix() for directory in CORPUS_DIRS],
        "missing_corpus_dirs": missing,
        "summary": {
            "total_files": len(cases),
            "parsed_extension_scoped": counts["parsed"],
            "abstained": counts["abstain"],
            "failed": counts["fail"],
            "canonical_matches": sum(1 for case in cases if case["canonical_match"]),
            "canonical_mismatches": sum(1 for case in cases if not case["canonical_match"]),
        },
        "reference_model": "scripts/mal_reference_model.py",
        "reference_comparison": reference_comparison,
        "differential_status": differential_status,
        "details": cases,
    }
    OUT.write_text(
        json.dumps(report, ensure_ascii=False, sort_keys=True, separators=(",", ":")) + "\n",
        encoding="utf-8",
    )
    print(
        f"DIFFERENTIAL_STATUS={differential_status} "
        f"FILES={len(cases)} PARSED={counts['parsed']} "
        f"ABSTAIN={counts['abstain']} FAIL={counts['fail']} "
        f"MATCHES={report['summary']['canonical_matches']} "
        f"MISMATCHES={report['summary']['canonical_mismatches']} "
        f"MISSING_DIRS={len(missing)}"
    )
    return 0 if all_match else 1


if __name__ == "__main__":
    raise SystemExit(main())
