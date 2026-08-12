#!/bin/sh

echo "=================================================="
echo "  مرحلة التجميع والربط (AOT Compilation to ELF) "
echo "=================================================="

# التحقق من وجود أدوات التجميع (binutils)
if ! command -v as >/dev/null 2>&1 || ! command -v ld >/dev/null 2>&1; then
    echo "❌ خطأ: أدوات التجميع (as, ld) غير متوفرة في بيئة الـ Sandbox."
    echo "لا يمكن إكمال المرحلة بدون binutils."
    exit 1
fi

# 1. التجميع (Assembly -> Object File)
echo "⚙️ [1/3] تجميع program.s إلى برنامج كائن (program.o)..."
if ! as program.s -o program.o 2> error_as.log; then
    echo "❌ فشل التجميع! الأخطاء:"
    cat error_as.log
    exit 1
fi
echo "✅ تم التجميع بنجاح."

# 2. الربط (Object File -> Executable ELF)
echo "🔗 [2/3] ربط program.o لإنتاج ملف تنفيذي (program)..."
if ! ld program.o -o program 2> error_ld.log; then
    echo "❌ فشل الربط! الأخطاء:"
    cat error_ld.log
    exit 1
fi
chmod +x program
echo "✅ تم إنتاج الملف التنفيذي المستقل."

# 3. التشغيل المباشر على العتاد (Bare Metal Execution)
echo "🚀 [3/3] تشغيل الملف التنفيذي (استدعاءات نظام مباشرة)..."
echo "---------------- المخرجات ----------------"
./program
حالة_الخروج=$?
echo "------------------------------------------"

if [ $حالة_الخروج -eq 0 ]; then
    echo "✅ نجح التنفيذ! اللغة الآن تنتج برامج مستقلة تماماً."
else
    echo "❌ فشل التنفيذ بحالة خروج: $حالة_الخروج"
fi

# تنظيف الملفات المؤقتة
rm -f program.o error_as.log error_ld.log
