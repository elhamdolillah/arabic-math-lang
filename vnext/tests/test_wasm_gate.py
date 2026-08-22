#!/usr/bin/env python3
import sys
from pathlib import Path
sys.path.insert(0, str(Path(__file__).parents[1] / "tools"))
from wasm_gate import admit_wat


def main() -> None:
    good = '(module (import "env" "print_i64" (func $print_i64 (param i64))))'
    result = admit_wat(good)
    assert result.accepted and len(result.fingerprint) == 64
    assert result.imports == ("print_i64",)

    assert not admit_wat('(module (import "env" "exec" (func $exec)))').accepted
    assert not admit_wat('(module memory.grow)').accepted
    assert not admit_wat('(module ' + ('x' * 100) + ')', max_bytes=32).accepted
    print("VNEXT_WASM_GATE_ALLOWLIST=PASS")
    print("VNEXT_WASM_GATE_FINGERPRINT=PASS")
    print("VNEXT_WASM_GATE_FORBIDDEN_FEATURES=PASS")
    print("VNEXT_WASM_GATE_RESOURCE_LIMIT=PASS")


if __name__ == "__main__":
    main()
