cd ~/ilm-al-kitab
# 1. إنشاء ملف اختبار بسيط
cat > /tmp/test.mal << 'EOF'
fn main() -> i32 {
    return 42;
}
EOF
# 2. ترجمة الملف باستخدام الصيغة الصحيحة
MAL/src/cli/target/release/malc /tmp/test.mal -o /tmp/test_bin
# 3. التحقق من نجاح الترجمة وتشغيل الناتج
if [ -f "/tmp/test_bin" ]; then
    echo "✅ الترجمة ناجحة!"
    echo "📊 حجم الـ Binary الناتج:"
    ls -lh /tmp/test_bin
    echo "🚀 تشغيل البرنامج:"
    /tmp/test_bin
    echo "✅ النتيجة المتوقعة: 42"
else
    echo "❌ فشل إنشاء الـ Binary"
fi
