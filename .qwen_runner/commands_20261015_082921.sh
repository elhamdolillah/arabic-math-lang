#!/bin/bash
# لاحظ: إزالة set -e لمنع التوقف المفاجئ عند الأخطاء البسيطة
BENCH_DIR="/tmp/mal_benchmark_final"
cd "$BENCH_DIR"
echo "🔍 1. التحقق من صحة المخرجات (يجب أن يطبع كل برنامج: 832040)"
echo "================================================================"
echo -n "C      : "
./fib_c
echo -n "Rust   : "
./fib_rs
echo -n "MAL    : "
./fib_mal
MAL_EXIT=$?
if [ $MAL_EXIT -ne 0 ]; then
    echo "⚠️ تنبيه: برنامج MAL أرجع رمز خطأ ($MAL_EXIT)"
fi
echo -n "Python : "
python3 fib.py
echo -e "\n⏱️ 2. قياس الزمن (متوسط 10 تكرارات بطريقة آمنة)"
echo "================================================================"
printf "%-8s | %s\n" "اللغة" "متوسط الزمن (ثانية)"
echo "----------------------------------------"
# دالة قياس زمن مرنة
measure() {
    local cmd=$1
    local lang=$2
    > times.txt
    for i in {1..10}; do
        # نستخدم time ونمنع السكربت من التوقف عند الخطأ باستخدام || true
        /usr/bin/time -f "%e" $cmd > /dev/null 2>> times.txt || true
    done
    # حساب المتوسط باستخدام awk
    avg=$(awk '{sum+=$1; n++} END {if(n>0) printf "%.6f", sum/n; else print "N/A"}' times.txt)
    printf "%-8s | %s\n" "$lang" "$avg"
}
measure "./fib_c" "C"
measure "./fib_rs" "Rust"
measure "./fib_mal" "MAL"
measure "python3 fib.py" "Python"
echo -e "\n✅ اكتمل التشخيص والقياس!"
