python3 << 'PYEOF'
import base64
script = '''#!/usr/bin/env python3
import sys
from playwright.sync_api import sync_playwright
URL = "http://localhost:8090"
with sync_playwright() as p:
    browser = p.chromium.launch(headless=True)
    page = browser.new_page()
    page.goto(URL, wait_until="networkidle", timeout=30000)
    page.wait_for_timeout(3000)
    # جرّب selectors شائعة لآخر رسالة
    selectors = [
        ".message:last-child",
        ".chat-message:last-child",
        "[class*=message]:last-child",
        "[class*=response]:last-child",
        "[class*=assistant]:last-child",
        "pre:last-of-type",
        "code:last-of-type",
    ]
    text = None
    for sel in selectors:
        try:
            el = page.query_selector(sel)
            if el:
                t = el.inner_text().strip()
                if t:
                    text = t
                    print(f"SELECTOR: {sel}")
                    break
        except Exception:
            pass
    if not text:
        # اطبع كل نص الصفحة للتشخيص
        text = page.inner_text("body")
        print("SELECTOR: body (fallback)")
    print("--- LAST RESPONSE ---")
    print(text)
    print("--- END ---")
    browser.close()
'''
b64 = base64.b64encode(script.encode()).decode()
open('/tmp/qtxt.b64','w').write(b64)
print("OK")
PYEOF
base64 -d /tmp/qtxt.b64 > /usr/local/bin/qtxt
chmod +x /usr/local/bin/qtxt
timeout 60 qtxt
