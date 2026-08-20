#!/usr/bin/env python3
"""اختبار عقد الربط الدلالي لمولد قوة Q32.32.

هذا اختبار بنيوي للمولد، وليس برهاناً على أن CPU نفذ كل تعليمة وفق النموذج.
"""
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT))
import math_complete as mc


def lines_for_pow():
    mc._counters["empty"] = 0
    expr = ("استدعاء", "قوة", [("عدد", 3 * 4294967296), ("عدد", 5)])
    return mc.compile_expr(expr, {}, {})


def assert_in_order(lines, *needles):
    pos = -1
    for needle in needles:
        found = next((i for i, line in enumerate(lines) if needle in line and i > pos), None)
        assert found is not None, f"لم يوجد المقطع بعد الموضع {pos}: {needle!r}"
        pos = found


def main():
    lines = lines_for_pow()
    text = "\n".join(lines)
    required = [
        "mov rcx, rax",
        "pop rax",
        "test rax, rax",
        "test rcx, rcx",
        "js .pow_reject_1",
        "cmp rcx, 31",
        "mov r9, rax",
        "mov r8, 4294967296",
        ".pow_loop_1:",
        "imul r9",
        "shrd rax, rdx, 32",
        "sar rdx, 32",
        "shr rcx, 1",
        "mov rax, r8",
        "mov rax, 60",
        "mov rdi, 1",
        "syscall",
    ]
    for item in required:
        assert item in text, f"تعليمة/وسم مفقود: {item}"

    assert_in_order(
        lines,
        "mov rcx, rax",
        "pop rax",
        "cmp rcx, 31",
        "mov r9, rax",
        "mov r8, 4294967296",
        ".pow_loop_1:",
        "imul r9",
        "shrd rax, rdx, 32",
        "sar rdx, 32",
        "shr rcx, 1",
        "mov rax, r8",
    )

    # يمنع الاختبار تحول الأس إلى Q32.32: قيمة الأس الخام هي 5.
    assert "mov r8, 4294967296" in text
    assert "cmp rcx, 31" in text
    print("✅ اختبار الربط البنيوي لقوة: ناجح")
    print("الحالة: semantic_link_draft — لا يثبت تطابق CPU أو Coq")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
