cat > ~/storage/shared/ilm-al-kitab-runner/results/ملف.txt << 'EOF'
pkill -f open_qwen 2>/dev/null
pkill -f chromium 2>/dev/null
sleep 2
cat > /tmp/open_duck.py << 'PYEOF'
from playwright.sync_api import sync_playwright
with sync_playwright() as p:
    browser = p.chromium.launch_persistent_context(
        user_data_dir="/root/duck_profile",
        headless=False,
        args=["--no-sandbox", "--disable-gpu", "--start-maximized"]
    )
    page = browser.pages[0] if browser.pages else browser.new_page()
    page.goto("https://duck.ai", timeout=60000)
    print("Duck.ai opened - waiting...")
    page.wait_for_timeout(3600000)
PYEOF
DISPLAY=:99 nohup python3 /tmp/open_duck.py > /tmp/duck_browser.log 2>&1 &
sleep 8
ps aux | grep -E "chromium|open_duck" | grep -v grep | head -2
EOF
qtxt
