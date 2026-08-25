from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
STAGE0 = ROOT / "corpus" / "stage0_18_files"
STAGE1 = ROOT / "corpus" / "stage1_9_files"
STAGE2 = ROOT / "corpus" / "stage2_12_files"
STAGE3 = ROOT / "corpus" / "stage3_15_files"


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

    stage2 = (
        ("01_add_precedence.ar", "بنية_جمع = 10 + 20 * 3"),
        ("02_subtract.ar", "بنية_طرح = 100 - 7"),
        ("03_multiply.ar", "بنية_ضرب = 6 * 7"),
        ("04_divide.ar", "بنية_قسمة = 84 / 2"),
        ("05_mixed_precedence.ar", "بنية_مختلط = 100 - 10 * 2 + 4"),
        ("06_nested_precedence.ar", "بنية_تركيب = 2 * 3 + 4 * 5"),
        ("07_parenthesized_add.ar", "بنية_قوس_جمع = (5 + 5) / 2"),
        ("08_nested_parentheses.ar", "بنية_أقواس_متداخلة = ((2 + 3) * 4)"),
        ("09_parenthesized_precedence.ar", "بنية_قوس_أسبقية = 2 * (3 + 4)"),
        ("10_division_by_zero.ar", "بنية_قسمة_صفر = 9 / 0"),
        ("11_unclosed_parenthesis.ar", "بنية_قوس_مفتوح = (5 + 2"),
        ("12_expression_overflow.ar", "بنية_فيض = 18446744073709551615 + 1"),
    )
    for name, source in stage2:
        write(STAGE2, name, source)

    stage3 = (
        ("01_multi_assign_basic.ar", "بنية_س = 10\nبنية_ص = بنية_س + 20"),
        ("02_multi_assign_chained.ar", "بنية_أ = 5\nبنية_ب = بنية_أ * 2\nبنية_ج = بنية_ب + بنية_أ"),
        ("03_multi_assign_parens.ar", "بنية_س = 5\nبنية_ص = (بنية_س + 5) / 2"),
        ("04_multi_assign_precedence.ar", "بنية_س = 3\nبنية_ص = 2 + بنية_س * 4"),
        ("05_multi_assign_subtract.ar", "بنية_س = 100\nبنية_ص = بنية_س - 35"),
        ("06_multi_assign_nested.ar", "بنية_س = 2\nبنية_ص = (بنية_س + 3) * (بنية_س + 4)"),
        ("07_multi_assign_chain_long.ar", "بنية_أ = 1\nبنية_ب = بنية_أ + 2\nبنية_ج = بنية_ب * 3\nبنية_د = بنية_ج - بنية_أ"),
        ("08_multi_assign_complex.ar", "بنية_س = 8\nبنية_ص = 3\nبنية_ع = (بنية_س + بنية_ص) * 2 - بنية_ص"),
        ("09_div_zero_eval.ar", "بنية_س = 10\nبنية_ص = بنية_س / 0"),
        ("10_overflow_u64_eval.ar", "بنية_س = 18446744073709551615\nبنية_ص = بنية_س + 1"),
        ("11_capacity_symbol_overflow.ar", "بنية_س = 1\nبنية_ص = بنية_س + 1"),
        ("12_syntax_broken_chain.ar", "بنية_س = 10\nبنية_ص بنية_س + 1"),
        ("13_undefined_variable.ar", "بنية_ص = بنية_غير_موجود + 1"),
        ("14_forbidden_eval_chain.ar", "بنية_س = 1\neval(code)"),
        ("15_forbidden_exec_chain.ar", "بنية_س = 1\nexec(code)"),
    )
    for name, source in stage3:
        write(STAGE3, name, source)


if __name__ == "__main__":
    main()
