from __future__ import annotations

import json
import tempfile
import unittest
from pathlib import Path

from vnext.tools.validate_manifest import validate


ROOT = Path(__file__).resolve().parents[2]
MANIFEST = ROOT / "vnext" / "manifest.json"


class VNextManifestTests(unittest.TestCase):
    def test_manifest_is_valid(self) -> None:
        validate(ROOT, MANIFEST)

    def test_manifest_forbids_destructive_replace(self) -> None:
        data = json.loads(MANIFEST.read_text(encoding="utf-8"))
        data["acceptance"]["no_destructive_replace"] = False
        with tempfile.TemporaryDirectory() as directory:
            candidate = Path(directory) / "manifest.json"
            candidate.write_text(json.dumps(data), encoding="utf-8")
            with self.assertRaises(ValueError):
                validate(ROOT, candidate)

    def test_manifest_rejects_error_above_sixteen(self) -> None:
        data = json.loads(MANIFEST.read_text(encoding="utf-8"))
        data["components"][1]["max_error"] = 17
        with tempfile.TemporaryDirectory() as directory:
            candidate = Path(directory) / "manifest.json"
            candidate.write_text(json.dumps(data), encoding="utf-8")
            with self.assertRaises(ValueError):
                validate(ROOT, candidate)


if __name__ == "__main__":
    unittest.main()
