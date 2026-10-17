cd /tmp/mal_benchmark_final
echo "═══════════════════════════════════════════════════════"
echo " 1. استخراج كود C المولد من قِبل MAL"
echo "═══════════════════════════════════════════════════════"
~/ilm-al-kitab/MAL/src/cli/target/release/malc --emit-c fib.mal > fib_generated.c
cat fib_generated.c
echo -e "\n═══════════════════════════════════════════════════════"
echo " 2. اختبار كود MAL أبسط (بدون تكرار أو if معقد)"
echo "═══════════════════════════════════════════════════════"
cat > simple.mal << 'EOF'
fn main() -> i32 {
    return 832040;
}
EOF
~/ilm-al-kitab/MAL/src/cli/target/release/malc simple.mal -o simple_bin
if [ -f "simple_bin" ]; then
    echo "🚀 تشغيل البرنامج البسيط:"
    ./simple_bin
    echo "✅ رمز الخروج: $?"
else
    echo "❌ فشل حتى في أبسط برنامج"
fi
