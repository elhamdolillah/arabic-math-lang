cat > ~/fix_qtxt.sh << 'EOF'
#!/bin/bash
set -e
pip3 install playwright --break-system-packages
python3 -m playwright install chromium
python3 -m playwright install-deps chromium || {
    apt-get update
    apt-get install -y libnss3 libnspr4 libatk1.0-0 libatk-bridge2.0-0 libcups2 libdrm2 libxkbcommon0 libxcomposite1 libxdamage1 libxfixes3 libxrandr2 libgbm1 libasound2 libpango-1.0-0 libcairo2
}
python3 -c "from playwright.sync_api import sync_playwright; p=sync_playwright().start(); b=p.chromium.launch(headless=True); b.close(); p.stop(); print('OK')"
EOF
chmod +x ~/fix_qtxt.sh
~/fix_qtxt.sh
qtxt
