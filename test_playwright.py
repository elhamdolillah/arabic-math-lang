from playwright.sync_api import sync_playwright
def run():
    with sync_playwright() as p:
        # تشغيل متصفح Chromium
        browser = p.chromium.launch(headless=True)
        page = browser.new_page()
        # الذهاب إلى موقع تجريبي
        page.goto("https://example.com")
        # أخذ لقطة شاشة وحفظها
        page.screenshot(path="example.png")
        print("✅ تم أخذ لقطة الشاشة بنجاح وحفظها باسم example.png")
        browser.close()
if __name__ == "__main__":
    run()
