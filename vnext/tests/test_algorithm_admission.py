from __future__ import annotations

import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT))

from vnext.tools.algorithm_admission import AdmissionAbstention, Candidate, select


def main() -> None:
    deterministic = Candidate(
        "رياضيات.جمع.حتمي", "DETERMINISTIC",
        {"domain_satisfied": True, "error_acceptable": True, "identity_verified": True,
         "tests_passed": True, "static_check_passed": True, "reproducible_build": True,
         "isolation_ready": True},
        "a" * 64,
    )
    probabilistic = Candidate(
        "تعلم.تنبؤ.احتمالي", "PROBABILISTIC",
        {"data_sufficient": True, "calibrated": True, "identity_verified": True,
         "tests_passed": True, "isolation_ready": True},
        "b" * 64,
    )
    chosen = select([probabilistic, deterministic])
    assert chosen["mode"] == "DETERMINISTIC"
    assert chosen["candidate"] == "رياضيات.جمع.حتمي"
    assert chosen["rejected_before_selection"] == []
    print("VNEXT_ADMISSION_DETERMINISTIC_PRIORITY=PASS")

    incomplete = Candidate("رياضيات.غير.مكتمل", "DETERMINISTIC", {}, "c" * 64)
    chosen_interval = select([incomplete, Candidate(
        "رياضيات.فترة", "INTERVAL",
        {"bounds_guaranteed": True, "identity_verified": True, "tests_passed": True,
         "static_check_passed": True, "isolation_ready": True},
        "d" * 64,
    )])
    assert chosen_interval["mode"] == "INTERVAL"
    assert chosen_interval["rejected_before_selection"][0]["identity"] == "رياضيات.غير.مكتمل"
    print("VNEXT_ADMISSION_REJECTION_LOG=PASS")

    try:
        select([Candidate("مجهول", "UNKNOWN", {}, "e" * 64)])
    except AdmissionAbstention:
        print("VNEXT_ADMISSION_ABSTENTION=PASS")
    else:
        raise AssertionError("كان يجب الامتناع")


if __name__ == "__main__":
    main()
