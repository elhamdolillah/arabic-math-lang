#!/usr/bin/env python3
"""Regression test for fail-closed runtime fingerprinting.

The fixture keeps the runtime length unchanged while changing its content.
The loader must invalidate the cache on metadata change and reject the
mutated artifact by SHA-256 before returning it.
"""

import hashlib
import importlib.util
import os
import pathlib
import shutil
import tempfile

ROOT = pathlib.Path(__file__).resolve().parent
COMPILER_PATH = ROOT / "math_complete.py"
RUNTIME_PATH = ROOT / "sha256_runtime_generated.asm"

spec = importlib.util.spec_from_file_location("math_complete_runtime_cache_test", COMPILER_PATH)
compiler = importlib.util.module_from_spec(spec)
assert spec.loader is not None
spec.loader.exec_module(compiler)

original = RUNTIME_PATH.read_bytes()
original_digest = hashlib.sha256(original).hexdigest()
assert original_digest == compiler._RUNTIME_EXPECTED_SHA256["sha256_runtime_generated.asm"]

with tempfile.TemporaryDirectory(prefix="runtime-fingerprint-regression-") as temp_dir:
    mutated_path = pathlib.Path(temp_dir) / RUNTIME_PATH.name
    shutil.copyfile(RUNTIME_PATH, mutated_path)

    # Mutate one byte while preserving the exact file size.
    mutated = bytearray(original)
    index = next((i for i, value in enumerate(mutated) if value not in (10, 13)), None)
    assert index is not None
    mutated[index] ^= 1
    assert len(mutated) == len(original)
    mutated_path.write_bytes(mutated)
    assert mutated_path.stat().st_size == RUNTIME_PATH.stat().st_size
    assert hashlib.sha256(mutated).hexdigest() != original_digest

    try:
        compiler._load_runtime_cached(str(mutated_path), "SHA-256")
    except Exception as exc:
        message = str(exc)
        assert "fingerprint mismatch" in message
        print("SAME_SIZE_MUTATION=REJECTED")
        print("FINGERPRINT_GUARD=PASS")
    else:
        raise AssertionError("same-size runtime mutation was not rejected")

print("STATUS=PASS")
