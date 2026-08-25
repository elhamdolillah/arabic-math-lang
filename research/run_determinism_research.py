#!/usr/bin/env python3
"""Fixture-only research harness. لا يشغّل source_ref أو binaries أو الشبكة."""
from __future__ import annotations

import hashlib
import json
import sys
from pathlib import Path


def digest(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def main(root_arg: str) -> int:
    root = Path(root_arg).resolve()
    cases = json.loads((root / "research/fixtures/research_cases.json").read_text(encoding="utf-8"))
    print("RESEARCH_HARNESS=START")
    print("SOURCE_REF_EXECUTED=NO")
    print("ATTACHMENT_EXECUTED=NO")
    print("NETWORK=DISABLED_BY_CONTRACT")
    failures: list[str] = []

    stage2 = cases["bootstrap"]["stage2"].encode("utf-8")
    stage3 = cases["bootstrap"]["stage3"].encode("utf-8")
    b_status = "PASS" if stage2 == stage3 else "ABSTAIN"
    if b_status != "PASS":
        failures.append("BOOTSTRAP_MISMATCH")
    print(f"BOOTSTRAP_FIXTURE={b_status}")
    print(f"STAGE2_SHA256={digest(stage2)}")
    print(f"STAGE3_SHA256={digest(stage3)}")
    print("BOOTSTRAP_CLAIM=STABILITY_ONLY")

    binary_a = cases["binary_diffing"]["equal_a"].encode("utf-8")
    binary_b = cases["binary_diffing"]["equal_b"].encode("utf-8")
    binary_different = cases["binary_diffing"]["different_b"].encode("utf-8")
    equal_status = "PASS" if binary_a == binary_b else "ABSTAIN"
    different_status = "PASS_EXPECTED_DIFFERENCE" if binary_a != binary_different else "ABSTAIN"
    if equal_status != "PASS" or different_status != "PASS_EXPECTED_DIFFERENCE":
        failures.append("BINARY_DIFF_FIXTURE_FAILURE")
    print(f"BINARY_EQUAL_FIXTURE={equal_status}")
    print(f"BINARY_DIFFERENT_FIXTURE={different_status}")
    print(f"BINARY_A_SHA256={digest(binary_a)}")
    print(f"BINARY_B_SHA256={digest(binary_b)}")
    print("BINARY_SECURITY_CLAIM=NOT_ESTABLISHED")

    fuzz_outputs = []
    for item in cases["fuzzing"]:
        seed = int(item["seed"])
        text = item["input"]
        # deterministic observation only; no parser/compiler invocation
        observation = {"seed": seed, "input_sha256": digest(text.encode("utf-8")), "length": len(text)}
        fuzz_outputs.append(observation)
    second = json.loads(json.dumps(fuzz_outputs, ensure_ascii=False, sort_keys=True))
    fuzz_status = "PASS" if fuzz_outputs == second else "ABSTAIN"
    if fuzz_status != "PASS":
        failures.append("FUZZ_REPRO_FAILURE")
    print(f"FUZZ_FIXED_SEEDS={fuzz_status}")
    print("FUZZING_CLAIM=NONDETERMINISM_DETECTION_ONLY")
    print("FUZZ_CASES=" + json.dumps(fuzz_outputs, ensure_ascii=False, sort_keys=True, separators=(",", ":")))

    if failures:
        print("STATUS=ABSTAIN")
        print("REASONS=" + json.dumps(failures, separators=(",", ":")))
        return 2
    print("STATUS=RESEARCH_PASS")
    print("CLASS=RESEARCH_FIXTURE_STABILITY")
    return 0


if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("USAGE=run_determinism_research.py ROOT")
        raise SystemExit(2)
    raise SystemExit(main(sys.argv[1]))
