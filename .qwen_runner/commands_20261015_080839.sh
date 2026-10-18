cd ~/ilm-al-kitab
# 1. الرجوع إلى نسخة mal-tiny-v2.0 (النسخة المصغرة والمستقرة)
git reset --hard mal-tiny-v2.0
# 2. تنظيف البيئة تماماً من أي ملفات عالقة
git clean -fdx -e .qwen_runner
# 3. التحقق من النظافة
git status
# 4. محاولة البناء من الصفر
cd MAL/src/cli
cargo build --release
