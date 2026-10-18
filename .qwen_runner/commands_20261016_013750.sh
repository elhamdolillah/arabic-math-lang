pkill -f chromium
sleep 2
cat > /tmp/open_qwen.py << 'PYEOF'
from playwright.sync_api import sync_playwright
with sync_playwright() as p:
    browser = p.chromium.launch_persistent_context(
        user_data_dir="/root/qwen_profile",
        headless=False,
        args=["--no-sandbox", "--disable-gpu", "--start-maximized"]
    )
    page = browser.pages[0] if browser.pages else browser.new_page()
    page.goto("https://chat.qwen.ai", timeout=60000)
    print("Browser opened - waiting...")
    page.wait_for_timeout(3600000)
PYEOF
DISPLAY=:99 nohup python3 /tmp/open_qwen.py > /tmp/qwen_browser.log 2>&1 &
sleep 8
ps aux | grep open_qwen | grep -v grep | head -2
tail -5 /tmp/qwen_browser.log
