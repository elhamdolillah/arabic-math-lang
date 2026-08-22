#!/usr/bin/env python3
import sys
from pathlib import Path
sys.path.insert(0, str(Path(__file__).parents[1] / "tools"))
from algorithm_acceptance import SafetyReport, Vote, evaluate

SAFE = SafetyReport(True, True, True, True, False, False)
VOTES = [Vote("u1", True), Vote("u2", True), Vote("u3", False)]


def main() -> None:
    accepted = evaluate(SAFE, VOTES)
    assert accepted["status"] == "ACCEPTED_FOR_ADMISSION"
    assert accepted["positive"] == 2 and accepted["negative"] == 1

    unsafe_loop = evaluate(SafetyReport(True, False, True, True, False, False), [Vote("u1", True)] * 5)
    assert unsafe_loop["status"] == "ABSTAIN"
    assert "termination_proven" in unsafe_loop["missing"]

    hardware = evaluate(SafetyReport(True, True, True, True, True, False), VOTES)
    assert hardware["status"] == "REJECTED"

    secret = evaluate(SafetyReport(True, True, True, True, False, True), VOTES)
    assert secret["status"] == "REJECTED"

    duplicated = evaluate(SAFE, [Vote("u1", True), Vote("u1", False), Vote("u2", True), Vote("u3", False)])
    assert duplicated["positive"] == 2 and duplicated["negative"] == 1

    tie = evaluate(SAFE, [Vote("u1", True), Vote("u2", False), Vote("u3", True), Vote("u4", False)])
    assert tie["status"] == "REJECTED"
    print("VNEXT_ACCEPTANCE_SAFETY_FIRST=PASS")
    print("VNEXT_ACCEPTANCE_TERMINATION_GATE=PASS")
    print("VNEXT_ACCEPTANCE_HARDWARE_GUARD=PASS")
    print("VNEXT_ACCEPTANCE_CONFIDENTIALITY_GUARD=PASS")
    print("VNEXT_ACCEPTANCE_MAJORITY_VOTE=PASS")
    print("VNEXT_ACCEPTANCE_VOTE_DEDUP=PASS")


if __name__ == "__main__":
    main()
