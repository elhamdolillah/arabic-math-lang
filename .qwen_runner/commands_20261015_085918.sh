#!/bin/bash
# ═══════════════════════════════════════════════════════════
# fix_qtxt.sh — إصلاح playwright بشكل صحيح
# ═══════════════════════════════════════════════════════════
set -e
echo "═══════════════════════════════════════════════════════════"
echo "  إصلاح playwright"
echo "═══════════════════════════════════════════════════════════"
# 1. تثبيت playwright مع --break-system-packages
echo "📦 تثبيت playwright..."
pip3 install playwright --break-system-packages
# 2. تثبيت Chromium
echo "🌐 تثبيت Chromium..."
python3 -m playwright install chromium
# 3. تثبيت التبعيات النظامية
echo "🔧 تثبيت التبعيات..."
python3 -m playwright install-deps chromium || {
    echo "⚠️ تثبيت يدوي للتبعيات..."
    apt-get update
    apt-get install -y \
        libnss3 libnspr4 libatk1.0-0 libatk-bridge2.0-0 \
        libcups2 libdrm2 libxkbcommon0 libxcomposite1 \
        libxdamage1 libxfixes3 libxrandr2 libgbm1 \
        libasound2 libpango-1.0-0 libcairo2
}
# 4. اختبار
echo "🧪 اختبار..."
python3 -c "
from playwright.sync_api import sync_playwright
with sync_playwright() as p:
    browser = p.chromium.launch(headless=True)
    browser.close()
print('✅ playwright يعمل!')
"
echo ""
echo "✅ تم الإصلاح بنجاح!"
