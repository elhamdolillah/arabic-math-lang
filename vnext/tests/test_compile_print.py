#!/usr/bin/env python3
import json
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parents[1] / "tools"))
from compile_print import compile_source
from parser import ParseError


def main() -> None:
    result = compile_source('⎕ "مرحبا"\n', "hello.ar")
    assert result["version"] == "uori-v9"
    assert result["result"]["inference_mode"] == "deterministic"
    assert result["result"]["evidence_label"] == "DETERMINISTIC"
    assert result["result"]["error_bound"] <= 16
    assert result["result"]["backend"] == "reference-only"
    assert result["result"]["output"] == "مرحبا\n"

    try:
        compile_source('⎕ بلا_اقتباس\n', "bad.ar")
    except ParseError:
        pass
    else:
        raise AssertionError("لم يُرفض الإدخال غير الصالح")

    print("VNEXT_RESULT_CONTRACT=PASS")
    print("VNEXT_DETERMINISTIC_PATH=PASS")
    print("VNEXT_ABSTENTION_ON_PARSE_ERROR=PASS")


if __name__ == "__main__":
    main()
