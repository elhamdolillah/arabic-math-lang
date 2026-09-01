from __future__ import annotations
import json
from fractions import Fraction
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parent
sys.path.insert(0, str(ROOT / "extensions"))
from uori_validated_math import Interval, MathBoundaryError, convergence_guard, interval_sum, require_same_shape

CORPUS = json.loads((ROOT / "corpus/four_rules_corpus.json").read_text(encoding="utf-8"))

def interval(pair):
    return Interval(Fraction(pair[0]), Fraction(pair[1]))

def canon(value):
    if isinstance(value, Interval):
        return {"lower": str(value.lower), "upper": str(value.upper)}
    if isinstance(value, tuple):
        return list(value)
    return value

def run(case):
    rule = case["rule"]
    if rule == "interval":
        try:
            out = getattr(interval(case["a"]), case["op"])(interval(case["b"]))
            return {"status": "ALLOW", "value": canon(out)}
        except MathBoundaryError as exc:
            return {"status": "ABSTAIN", "reason": str(exc)}
    if rule == "shape":
        try:
            return {"status": "ALLOW", "value": list(require_same_shape(*case["vectors"]))}
        except MathBoundaryError as exc:
            return {"status": "ABSTAIN", "reason": str(exc)}
    if rule == "sum":
        out = interval_sum(interval(v) for v in case["values"])
        return {"status": "ALLOW", "value": canon(out)}
    if rule == "convergence":
        try:
            return {"status": convergence_guard(Fraction(case["error"]), Fraction(case["tolerance"]), case["fuel_left"])}
        except MathBoundaryError as exc:
            return {"status": "ABSTAIN", "reason": str(exc)}
    raise AssertionError(rule)

def main():
    outputs = []
    for case in CORPUS["cases"]:
        outputs.append({"id": case["id"], "result": run(case)})
    expected = {
        "interval_add": {"status": "ALLOW", "value": {"lower": "5/2", "upper": "11/2"}},
        "interval_sub": {"status": "ALLOW", "value": {"lower": "-4", "upper": "1"}},
        "interval_mul": {"status": "ALLOW", "value": {"lower": "-10", "upper": "15"}},
        "interval_div": {"status": "ALLOW", "value": {"lower": "1/2", "upper": "2"}},
        "interval_div_zero": {"status": "ABSTAIN", "reason": "DIVISOR_CONTAINS_ZERO"},
        "shape_equal": {"status": "ALLOW", "value": [3]},
        "shape_mismatch": {"status": "ABSTAIN", "reason": "SHAPE_MISMATCH"},
        "sum_ordered": {"status": "ALLOW", "value": {"lower": "6", "upper": "6"}},
        "converged": {"status": "ALLOW"},
        "not_converged": {"status": "ABSTAIN"},
        "fuel_invalid": {"status": "ABSTAIN", "reason": "FUEL_INVALID"},
    }
    for item in outputs:
        got = item["result"]
        want = expected[item["id"]]
        assert got == want, (item["id"], got, want)
    print("REPRO_CHECK=PASS")
    print("RULES=interval,shape,ordered_sum,convergence_guard")
    print(f"CASES={len(outputs)}")
    print("EXPECTED_MATCH=YES")
    print("FAILURE_CASES_VERIFIED=YES")
    print("SOURCE_REF_EXECUTED=NO")
    print("EXECUTION_SCOPE=TRUSTED_EXTENSION_ONLY")
    print("CLASS=EXTENSION_SCOPED_PROVEN")
    print(json.dumps(outputs, ensure_ascii=False, sort_keys=True, separators=(",", ":")))

if __name__ == "__main__":
    main()
