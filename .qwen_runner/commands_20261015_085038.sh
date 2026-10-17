# 1. تثبيت playwright
pip3 install playwright
# 2. تثبيت Chromium (المتصفح)
playwright install chromium
# 3. تثبيت التبعيات النظامية
playwright install-deps chromium
# 4. اختبار التثبيت
python3 -c "from playwright.sync_api import sync_playwright; print('✅ playwright يعمل')"
