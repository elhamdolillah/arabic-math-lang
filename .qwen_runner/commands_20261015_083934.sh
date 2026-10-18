cd /tmp/mal_benchmark_final
echo "═══════════════════════════════════════════════════════"
echo " 1. استخراج كود C للبرنامج البسيط (الذي يعطي خطأ 40)"
echo "═══════════════════════════════════════════════════════"
# الصيغة الصحيحة حسب المساعدة: malc <input> --emit-c
~/ilm-al-kitab/MAL/src/cli/target/release/malc simple.mal --emit-c > simple_gen.c 2>&1
echo "📄 محتوى كود C المولد:"
cat simple_gen.c
echo -e "\n═══════════════════════════════════════════════════════"
echo " 2. استخراج كود C لبرنامج Fibonacci"
echo "═══════════════════════════════════════════════════════"
~/ilm-al-kitab/MAL/src/cli/target/release/malc fib.mal --emit-c > fib_gen.c 2>&1
echo "📄 محتوى كود C المولد:"
cat fib_gen.c
