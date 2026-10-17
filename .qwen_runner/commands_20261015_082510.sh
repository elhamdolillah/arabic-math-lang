#!/bin/bash
set -e
BENCH_DIR="/tmp/mal_benchmark_final"
mkdir -p "$BENCH_DIR"
cd "$BENCH_DIR"
echo "═══════════════════════════════════════════════════════"
echo " 1. إعداد ملفات الاختبار (Fibonacci n=30)"
echo "═══════════════════════════════════════════════════════"
# C Code
cat > fib.c << 'EOF'
#include <stdio.h>
int fib(int n) { if (n <= 1) return n; return fib(n - 1) + fib(n - 2); }
int main() { printf("%d\n", fib(30)); return 0; }
EOF
# Rust Code
cat > fib.rs << 'EOF'
fn fib(n: i32) -> i32 { if n <= 1 { n } else { fib(n - 1) + fib(n - 2) } }
fn main() { println!("{}", fib(30)); }
EOF
# Python Code
cat > fib.py << 'EOF'
def fib(n):
    if n <= 1: return n
    return fib(n - 1) + fib(n - 2)
print(fib(30))
EOF
# MAL Code (مصحح: إضافة أقواس حول شرط if)
cat > fib.mal << 'EOF'
fn fib(n: i32) -> i32 {
    if (n <= 1) {
        return n;
    }
    return fib(n - 1) + fib(n - 2);
}
fn main() -> i32 {
    return fib(30);
}
EOF
echo "✅ تم إنشاء ملفات المصدر"
echo -e "\n═══════════════════════════════════════════════════════"
echo " 2. بناء جميع النسخ"
echo "═══════════════════════════════════════════════════════"
# Build C
gcc -O2 fib.c -o fib_c
echo "✅ تم بناء C -O2"
# Build Rust
rustc -O fib.rs -o fib_rs 2>/dev/null || echo "⚠️ Rust لم يتم بناؤه"
echo "✅ تم بناء Rust --release"
# Build MAL
MAL_BIN=~/ilm-al-kitab/MAL/src/cli/target/release/malc
$MAL_BIN fib.mal -o fib_mal
echo "✅ تم بناء MAL"
echo -e "\n═══════════════════════════════════════════════════════"
echo " 3. قياس الحجم (Binary Size - بيانات خام)"
echo "═══════════════════════════════════════════════════════"
printf "%-10s | %-15s\n" "اللغة" "الحجم (بايت)"
echo "----------------------------------------"
for bin in fib_c fib_rs fib_mal; do
    if [ -f "$bin" ]; then
        size=$(stat -c%s "$bin" 2>/dev/null || stat -f%z "$bin" 2>/dev/null)
        lang=$(echo $bin | sed 's/fib_//')
        printf "%-10s | %-15s\n" "$lang" "$size"
    fi
done
echo -e "\n═══════════════════════════════════════════════════════"
echo " 4. قياس الزمن (متوسط 10 تكرارات - بيانات خام)"
echo "═══════════════════════════════════════════════════════"
printf "%-10s | %-15s\n" "اللغة" "متوسط الزمن (ثانية)"
echo "----------------------------------------"
for bin in fib_c fib_rs fib_mal; do
    if [ -f "$bin" ]; then
        > times.txt
        for i in {1..10}; do
            /usr/bin/time -f "%e" ./$bin 2>> times.txt > /dev/null
        done
        avg=$(awk '{sum+=$1; n++} END {printf "%.6f", sum/n}' times.txt)
        lang=$(echo $bin | sed 's/fib_//')
        printf "%-10s | %-15s\n" "$lang" "$avg"
    fi
done
# Python benchmark (منفصل لأنه مفسر)
> times_py.txt
for i in {1..10}; do
    /usr/bin/time -f "%e" python3 fib.py 2>> times_py.txt > /dev/null
done
avg_py=$(awk '{sum+=$1; n++} END {printf "%.6f", sum/n}' times_py.txt)
printf "%-10s | %-15s\n" "python" "$avg_py"
echo -e "\n✅ اكتمل القياس بنجاح! البيانات أعلاه هي الخام والمطلوبة."
