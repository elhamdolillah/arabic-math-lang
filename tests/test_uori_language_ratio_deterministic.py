from pathlib import Path
import importlib.util
import os
import tempfile


SCRIPT = Path(__file__).parents[1] / "scripts" / "uori_language_ratio_deterministic.py"
spec = importlib.util.spec_from_file_location("uori_language_ratio_deterministic", SCRIPT)
module = importlib.util.module_from_spec(spec)
spec.loader.exec_module(module)


def test_report_is_stable_with_fixed_epoch_and_sorted_manifest():
    previous = os.environ.get("SOURCE_DATE_EPOCH")
    os.environ["SOURCE_DATE_EPOCH"] = "0"
    try:
        with tempfile.TemporaryDirectory() as temp_dir:
            root = Path(temp_dir)
            (root / "z.ar").write_text("امتنع\n", encoding="utf-8")
            (root / "a.py").write_text("x = 1\n", encoding="utf-8")
            first = module.analyze_project(root)
            second = module.analyze_project(root)

            assert first == second
            assert first["meta"]["project_root"] == "."
            assert first["meta"]["timestamp"] == "1970-01-01T00:00:00Z"
            assert first["meta"]["analyzer_version"] == "1.1.0-deterministic"
            assert [entry["path"] for entry in first["file_manifest"]] == ["a.py", "z.ar"]
            assert len(first["meta"]["report_sha256"]) == 64
    finally:
        if previous is None:
            os.environ.pop("SOURCE_DATE_EPOCH", None)
        else:
            os.environ["SOURCE_DATE_EPOCH"] = previous


if __name__ == "__main__":
    test_report_is_stable_with_fixed_epoch_and_sorted_manifest()
    print("DETERMINISTIC_RATIO_REPORT=PASS")
