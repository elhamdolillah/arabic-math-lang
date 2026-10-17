cd ~/ilm-al-kitab
# 1. الرجوع إلى الـ Tag السابق (v2.0)
git reset --hard v2.0-morphology-engine
# 2. تنظيف البيئة تماماً من أي ملفات عالقة
git clean -fdx -e .qwen_runner
# 3. التحقق من أن الشجرة نظيفة
git status
# 4. محاولة البناء من الصفر
cd MAL/src/cli
cargo build --release
