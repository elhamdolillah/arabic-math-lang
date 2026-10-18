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
    page.wait_for_timeout(6000)
    els = page.query_selector_all("[class*='message']")
    print("عدد عناصر message:", len(els))
    for i, el in enumerate(els):
        t = el.inner_text().strip().replace("
", " | ")[:120]
        print(i, ":", t)
    print("---BODY---")
    print(page.inner_text("body")[:2000])
    browser.close()
PYEOF
