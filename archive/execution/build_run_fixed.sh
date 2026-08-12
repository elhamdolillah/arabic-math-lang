#!/bin/sh

echo "=================================================="
echo "  مرحلة التوليد والتجميع والربط والتنفيذ"
echo "=================================================="

# تنظيف بسيط من بقايا سابقة
rm -f program program.o error_as.log error_ld.log aot_generator_fixed.py

# التأكد من وجود python3
if ! command -v python3 >/dev/null 2>&1; then
    echo "❌ خطأ: python3 غير متوفر في البيئة."
    exit 1
fi

# التأكد من وجود أدوات التجميع
if ! command -v as >/dev/null 2>&1 || ! command -v ld >/dev/null 2>&1; then
    echo "❌ خطأ: أدوات التجميع as أو ld غير متوفرة في البيئة."
    exit 1
fi

# ============================================================
# 1. توليد برنامج Assembly مع إصلاح مشكلة الالتصاق
# ============================================================

cat > aot_generator_fixed.py <<'PY'
# -*- coding: utf-8 -*-

class مولد_x86_64:
    def __init__(self):
        # قسم البيانات أولاً
        self.بيانات = [".section .data"]

        # قسم الكود لاحقًا
        self.كود = [
            ".section .text",
            ".globl _start",
            "",
            "_start:"
        ]

        self.عداد_النصوص = 0

    def اضف_تعليمة(self, سطر):
        self.كود.append(سطر)

    def اضف_بيانات(self, سطر):
        self.بيانات.append(سطر)

    def سجل_نص(self, نص):
        اسم = f"msg_{self.عداد_النصوص}"
        self.عداد_النصوص += 1

        بايتات = نص.encode("utf-8")
        بايتات_نص = ",".join(f"0x{ب:02x}" for ب in بايتات)

        self.اضف_بيانات(f"{اسم}:")
        self.اضف_بيانات(f"    .byte {بايتات_نص}")
        self.اضف_بيانات(f"{اسم}_len = . - {اسم}")

        return اسم, len(بايتات)

    def ولد_برنامج(self, برنامج):
        for بيان in برنامج:
            self.ولد_بيان(بيان)

        # رسالة النجاح النهائية
        اسم, طول = self.سجل_نص("✅ تم التنفيذ بنجاح\n")

        self.اضف_تعليمة("    # print success message")
        self.اضف_تعليمة("    mov $1, %rax")
        self.اضف_تعليمة("    mov $1, %rdi")
        self.اضف_تعليمة(f"    lea {اسم}(%rip), %rsi")
        self.اضف_تعليمة(f"    mov ${طول}, %rdx")
        self.اضف_تعليمة("    syscall")

        self.اضف_تعليمة("")
        self.اضف_تعليمة("    # sys_exit")
        self.اضف_تعليمة("    mov $60, %rax")
        self.اضف_تعليمة("    xor %rdi, %rdi")
        self.اضف_تعليمة("    syscall")

    def ولد_بيان(self, بيان):
        الأمر = بيان[0]

        if الأمر == "اطبع_نص":
            # إصلاح مهم: إضافة سطر جديد بعد كل نص
            نص = بيان[1] + "\n"
            اسم, طول = self.سجل_نص(نص)

            self.اضف_تعليمة("    # print")
            self.اضف_تعليمة("    mov $1, %rax")
            self.اضف_تعليمة("    mov $1, %rdi")
            self.اضف_تعليمة(f"    lea {اسم}(%rip), %rsi")
            self.اضف_تعليمة(f"    mov ${طول}, %rdx")
            self.اضف_تعليمة("    syscall")

        elif الأمر == "اسند_رقم":
            متغير = بيان[1]
            قيمة = بيان[2]

            self.اضف_تعليمة(f"    # assign immediate value")
            self.اضف_تعليمة(f"    mov ${قيمة}, %rbx")

        elif الأمر == "مخصص":
            # لا شيء في هذه النسخة
            pass

    def اكتب_ملف(self, اسم_الملف):
        with open(اسم_الملف, "w", encoding="utf-8") as ملف:
            for سطر in self.بيانات:
                ملف.write(سطر + "\n")

            ملف.write("\n")

            for سطر in self.كود:
                ملف.write(سطر + "\n")


برنامج_بسيط = [
    ("اطبع_نص", "مرحباً بالعالم العربي!"),
    ("اطبع_نص", "هذه لغة تُترجم إلى Assembly مباشرة"),
    ("اسند_رقم", "س", 42),
]

مولد = مولد_x86_64()
مولد.ولد_برنامج(برنامج_بسيط)
مولد.اكتب_ملف("program.s")

print("✅ تم توليد program.s")
PY

echo ""
echo "[1/4] توليد program.s..."
python3 aot_generator_fixed.py
gen_status=$?

if [ "$gen_status" -ne 0 ]; then
    echo "❌ فشل توليد program.s"
    exit "$gen_status"
fi

# ============================================================
# 2. التجميع
# ============================================================

echo ""
echo "[2/4] تجميع program.s إلى program.o..."
as program.s -o program.o 2> error_as.log
as_status=$?

if [ "$as_status" -ne 0 ]; then
    echo "❌ فشل التجميع. الأخطاء:"
    cat error_as.log
    exit "$as_status"
fi

echo "✅ تم التجميع بنجاح."

# ============================================================
# 3. الربط
# ============================================================

echo ""
echo "[3/4] ربط program.o لإنتاج برنامج تنفيذي..."
ld program.o -o program 2> error_ld.log
ld_status=$?

if [ "$ld_status" -ne 0 ]; then
    echo "❌ فشل الربط. الأخطاء:"
    cat error_ld.log
    exit "$ld_status"
fi

chmod +x program
echo "✅ تم إنتاج الملف التنفيذي program"

# ============================================================
# 4. التشغيل
# ============================================================

echo ""
echo "[4/4] تشغيل الملف التنفيذي..."
echo "---------------- المخرجات ----------------"

./program
exit_status=$?

echo "------------------------------------------"
echo ""

if [ "$exit_status" -eq 0 ]; then
    echo "✅ نجح التنفيذ! اللغة الآن تنتج برامج مستقلة تماماً."
else
    echo "❌ فشل التنفيذ بحالة خروج: $exit_status"
fi

# تنظيف مؤقت
rm -f program.o error_as.log error_ld.log

exit "$exit_status"