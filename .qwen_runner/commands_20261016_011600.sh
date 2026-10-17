#!/bin/bash
set -e
echo "═══════════════════════════════════════════════════════"
echo " 1. إنشاء بيئة افتراضية لـ playwright"
echo "═══════════════════════════════════════════════════════"
python3 -m venv /root/playwright-env
source /root/playwright-env/bin/activate
echo "═══════════════════════════════════════════════════════"
echo " 2. تثبيت playwright داخل البيئة الافتراضية"
echo "═══════════════════════════════════════════════════════"
pip install playwright
echo "═══════════════════════════════════════════════════════"
echo " 3. تثبيت Chromium والمتصفح"
echo "═══════════════════════════════════════════════════════"
playwright install chromium
playwright install-deps chromium
echo "═══════════════════════════════════════════════════════"
echo " 4. اختبار التثبيت"
echo "═══════════════════════════════════════════════════════"
python3 -c "from playwright.sync_api import sync_playwright; print('✅ playwright يعمل بنجاح')"
echo -e "\n✅ تم تثبيت playwright بنجاح!"
echo "💡 لاستخدام playwright لاحقاً، فعّل البيئة أولاً:"
echo "   source /root/playwright-env/bin/activate"
