#!/usr/bin/env python3
import sys
from pathlib import Path
sys.path.insert(0, str(Path(__file__).parents[1] / "tools"))
from ui_gateway import UiRequest, submit


def main() -> None:
    first = submit(UiRequest(" احسب ٢ + ٢ "))
    second = submit(UiRequest("احسب ٢ + ٢"))
    assert first == second
    assert first["status"] == "ADMITTED_FOR_ANALYSIS"
    assert first["execution"] is False
    assert first["external_side_effects"] is False
    assert submit(UiRequest("hello", "en"))["status"] == "ABSTAIN"
    assert submit(UiRequest("   "))["status"] == "ABSTAIN"
    print("VNEXT_UI_ARABIC_INPUT=PASS")
    print("VNEXT_UI_DETERMINISTIC_REQUEST_HASH=PASS")
    print("VNEXT_UI_NO_EXECUTION=PASS")
    print("VNEXT_UI_ABSTENTION=PASS")


if __name__ == "__main__":
    main()
