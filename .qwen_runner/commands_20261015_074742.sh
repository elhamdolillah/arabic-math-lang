cd ~/ilm-al-kitab
# 1. الرجوع إلى الـ Tag الأقدم والأكثر استقراراً
git reset --hard v2.1-grammar-type-checker
# 2. تنظيف البيئة من أي ملفات عالقة
git clean -fdx -e .qwen_runner
# 3. التحقق من النظافة
git status
# 4. محاولة البناء من الصفر
cd MAL/src/cli
cargo build --release
