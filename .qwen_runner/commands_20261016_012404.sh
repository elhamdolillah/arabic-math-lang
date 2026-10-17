python3 << 'PYEOF'
from playwright.sync_api import sync_playwright
with sync_playwright() as p:
    browser = p.chromium.launch_persistent_context(
        user_data_dir="/root/qwen_profile",
        headless=True,
        args=["--no-sandbox"]
    )
    page = browser.pages[0] if browser.pages else browser.new_page()
    page.goto("https://chat.qwen.ai", wait_until="networkidle", timeout=60000)
    page.wait_for_timeout(5000)
    selectors = [
        "[class*='assistant']:last-of-type",
        "[class*='answer']:last-of-type",
        "[class*='response']:last-of-type",
        "[class*='message']:last-of-type",
        ".markdown-body:last-of-type",
    ]
    text = None
    for sel in selectors:
        el = page.query_selector(sel)
        if el and el.inner_text().strip():
            text = el.inner_text().strip()
            print("SELECTOR:", sel)
            break
    if not text:
        text = page.inner_text("body")
        print("SELECTOR: body (fallback)")
    print("--- LAST RESPONSE ---")
    print(text[:3000])
    browser.close()
PYEOF
