from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
STAGE0 = ROOT / "corpus" / "stage0_18_files"
STAGE1 = ROOT / "corpus" / "stage1_9_files"
STAGE2 = ROOT / "corpus" / "stage2_12_files"
STAGE3 = ROOT / "corpus" / "stage3_15_files"
STAGE4 = ROOT / "corpus" / "stage4_16_files"
STAGE5 = ROOT / "corpus" / "stage5_15_files"
STAGE6 = ROOT / "corpus" / "stage6_15_files"


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

    stage4 = (
        ("01_if_true_equal.ar", "إذا 5 == 5 فإن\nبنية_نتيجة = 1\nنهاية"),
        ("02_if_false_equal.ar", "إذا 5 == 6 فإن\nبنية_نتيجة = 1\nنهاية"),
        ("03_if_greater.ar", "إذا 9 > 3 فإن\nبنية_نتيجة = 9\nنهاية"),
        ("04_if_less.ar", "إذا 2 < 8 فإن\nبنية_نتيجة = 8\nنهاية"),
        ("05_if_not_equal.ar", "إذا 2 != 3 فإن\nبنية_نتيجة = 3\nنهاية"),
        ("06_if_with_expression.ar", "إذا 2 + 3 == 5 فإن\nبنية_نتيجة = 5\nنهاية"),
        ("07_if_nested_expression.ar", "إذا (2 * 3) > (1 + 4) فإن\nبنية_نتيجة = 6\nنهاية"),
        ("08_if_multiline_sequence.ar", "بنية_س = 4\nإذا بنية_س > 0 فإن\nبنية_ص = بنية_س + 1\nنهاية"),
        ("09_scope_shadowing.ar", "بنية_س = 1\nإذا 1 == 1 فإن\nبنية_س = 2\nنهاية"),
        ("10_scope_unknown_after_exit.ar", "إذا 1 == 1 فإن\nبنية_محلي = 7\nنهاية\nبنية_خارج = بنية_محلي"),
        ("11_scope_depth_overflow.ar", "إذا 1 == 1 فإن\nإذا 1 == 1 فإن\nبنية_عميق = 1\nنهاية\nنهاية"),
        ("12_unclosed_if.ar", "إذا 1 == 1 فإن\nبنية_ناقص = 1"),
        ("13_invalid_condition_divzero.ar", "إذا 1 / 0 == 0 فإن\nبنية_نتيجة = 1\nنهاية"),
        ("14_forbidden_eval_in_if.ar", "إذا 1 == 1 فإن\neval(code)\nنهاية"),
        ("15_forbidden_exec_in_if.ar", "إذا 1 == 1 فإن\nexec(code)\nنهاية"),
        ("16_forbidden_unsafe_in_if.ar", "إذا 1 == 1 فإن\nunsafe { block }\nنهاية"),
    )
    for name, source in stage4:
        write(STAGE4, name, source)

    stage5 = (
        ("01_loop_false.ar", "طالما 0 == 1 كرر\nبنية_نتيجة = 1\nنهاية"),
        ("02_loop_false_less.ar", "طالما 5 < 2 كرر\nبنية_نتيجة = 9\nنهاية"),
        ("03_func_basic.ar", "دالة بنية_ضعف(بنية_س) فإن\nبنية_نتيجة = بنية_س + بنية_س\nنهاية\nبنية_قيمة = بنية_ضعف(5)"),
        ("04_func_constant.ar", "دالة بنية_ثابت(بنية_س) فإن\nبنية_نتيجة = 7\nنهاية\nبنية_قيمة = بنية_ثابت(2)"),
        ("05_func_expression.ar", "دالة بنية_زيادة(بنية_س) فإن\nبنية_نتيجة = بنية_س + 1\nنهاية\nبنية_قيمة = بنية_زيادة(8)"),
        ("06_func_zero.ar", "دالة بنية_صفر(بنية_س) فإن\nبنية_نتيجة = بنية_س * 0\nنهاية\nبنية_قيمة = بنية_صفر(8)"),
        ("07_func_shadow_scope.ar", "بنية_س = 10\nدالة بنية_محلية(بنية_س) فإن\nبنية_نتيجة = بنية_س + 1\nنهاية\nبنية_قيمة = بنية_محلية(4)"),
        ("08_func_chained.ar", "دالة بنية_زيادة(بنية_س) فإن\nبنية_نتيجة = بنية_س + 1\nنهاية\nبنية_أ = بنية_زيادة(2)\nبنية_ب = بنية_زيادة(بنية_أ)"),
        ("09_fuel_exhausted.ar", "طالما 1 == 1 كرر\nبنية_دورة = 1\nنهاية"),
        ("10_fuel_expression.ar", "طالما 2 > 1 كرر\nبنية_دورة = 0\nنهاية"),
        ("11_recursive_call.ar", "دالة بنية_ذاتية(بنية_س) فإن\nبنية_نتيجة = بنية_ذاتية(بنية_س)\nنهاية\nبنية_قيمة = بنية_ذاتية(1)"),
        ("12_unclosed_loop.ar", "طالما 0 == 1 كرر\nبنية_ناقص = 1"),
        ("13_forbidden_loop_eval.ar", "طالما 0 == 1 كرر\neval(code)\nنهاية"),
        ("14_forbidden_func_exec.ar", "دالة بنية_خطر(بنية_س) فإن\nexec(code)\nنهاية"),
        ("15_forbidden_func_unsafe.ar", "دالة بنية_خطر(بنية_س) فإن\nunsafe { block }\nنهاية"),
    )
    for name, source in stage5:
        write(STAGE5, name, source)

    stage6 = (
        ("01_hesab_basic.ar", "بنية_أ = 2\nبنية_ب = 3\nبنية_نتيجة = حسب(بنية_أ + بنية_ب)\nبنية_تحقق = 1\nبنية_مقياس = وزن(بنية_تحقق)"),
        ("02_count_number.ar", "بنية_أ = 7\nبنية_ب = عدّ(بنية_أ)\nبنية_نتيجة = وزن(بنية_ب)\nبنية_تحقق = 1\nبنية_مقياس = وزن(بنية_تحقق)"),
        ("03_capacity_valid.ar", "بنية_أ = 32\nبنية_ب = 32\nبنية_نتيجة = قدر(بنية_أ + بنية_ب)\nبنية_تحقق = 1\nبنية_مقياس = وزن(بنية_تحقق)"),
        ("04_weight_expression.ar", "بنية_أ = 4\nبنية_ب = 5\nبنية_نتيجة = وزن(بنية_أ * بنية_ب)\nبنية_تحقق = 1\nبنية_مقياس = وزن(بنية_تحقق)"),
        ("05_string_ascii.ar", 'بنية_نص = "مرحبا"\nبنية_طول = سلسلة(بنية_نص)\nبنية_نتيجة = وزن(بنية_طول)\nبنية_تحقق = 1\nبنية_مقياس = وزن(بنية_تحقق)'),
        ("06_string_utf8.ar", 'بنية_نص = "لغة عربية"\nبنية_طول = سلسلة(بنية_نص)\nبنية_نتيجة = عدّ(بنية_طول)\nبنية_تحقق = 1\nبنية_مقياس = وزن(بنية_تحقق)'),
        ("07_string_length.ar", 'بنية_نص = "abc"\nبنية_طول = سلسلة(بنية_نص)\nبنية_نتيجة = حسب(بنية_طول)\nبنية_تحقق = 1\nبنية_مقياس = وزن(بنية_تحقق)'),
        ("08_quran_chain.ar", "بنية_أ = 3\nبنية_ب = عدّ(بنية_أ)\nبنية_ج = قدر(4)\nبنية_نتيجة = وزن(حسب(بنية_ب + بنية_ج))\nبنية_تحقق = 1\nبنية_مقياس = وزن(بنية_تحقق)"),
        ("09_string_boundary.ar", 'بنية_نص = "1234567890123456789012345678901234567890123456789012345678901234"\nبنية_تحقق = 1\nبنية_مقياس = وزن(بنية_تحقق)\nبنية_حد = قدر(64)'),
        ("10_string_overflow.ar", 'بنية_نص = "12345678901234567890123456789012345678901234567890123456789012345"\nبنية_تحقق = 1\nبنية_مقياس = وزن(بنية_تحقق)'),
        ("11_capacity_overflow.ar", "بنية_نتيجة = قدر(65)\nبنية_تحقق = 1\nبنية_مقياس = وزن(بنية_تحقق)"),
        ("12_fuel_limit.ar", "طالما 1 == 1 كرر\nبنية_دورة = 1\nنهاية\nبنية_تحقق = 1\nبنية_مقياس = وزن(بنية_تحقق)"),
        ("13_forbidden_eval.ar", "بنية_تحقق = 1\nبنية_مقياس = وزن(بنية_تحقق)\nبنية_نتيجة = حسب(eval(code))"),
        ("14_invalid_keyword.ar", "بنية_تحقق = 1\nبنية_مقياس = وزن(بنية_تحقق)\nبنية_نتيجة = ميزان(1)"),
        ("15_unclosed_string.ar", 'بنية_تحقق = 1\nبنية_مقياس = وزن(بنية_تحقق)\nبنية_نص = "غير مغلق'),
    )
    for name, source in stage6:
        write(STAGE6, name, source)


if __name__ == "__main__":
    main()
