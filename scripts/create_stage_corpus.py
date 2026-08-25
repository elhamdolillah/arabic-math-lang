from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
STAGE0 = ROOT / "corpus" / "stage0_18_files"
STAGE1 = ROOT / "corpus" / "stage1_9_files"


def write(directory: Path, name: str, source: str) -> None:
    directory.mkdir(parents=True, exist_ok=True)
    (directory / name).write_text(source + "\n", encoding="utf-8", newline="\n")


def main() -> None:
    for index in range(1, 19):
        write(STAGE0, f"{index:02d}_valid_stage0.ar", f"بنية_مرحلة0_{index:02d} = {index}")

    valid = (
        ("01_valid_node.ar", "بنية_عقدة_اختبار = 42"),
        ("04_valid_zero.ar", "بنية_صفر = 0"),
        ("05_valid_large.ar", "بنية_قيمة_كبرى = 18446744073709551615"),
        ("06_valid_unicode_name.ar", "بنية_اسم_عربي = 7"),
        ("07_valid_one.ar", "بنية_واحد = 1"),
        ("08_valid_repeatable.ar", "بنية_تكرار = 77"),
    )
    for name, source in valid:
        write(STAGE1, name, source)
    write(STAGE1, "02_invalid_eval.ar", "eval(malicious_code)")
    write(STAGE1, "03_unsupported_syntax.ar", "عدد_صحيح أ = ٧;")
    write(STAGE1, "09_invalid_missing_value.ar", "بنية_ناقص =")


if __name__ == "__main__":
    main()
