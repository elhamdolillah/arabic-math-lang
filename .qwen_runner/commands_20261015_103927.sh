which chromium chromium-browser google-chrome firefox 2>/dev/null
echo "---"
DISPLAY=:99 nohup chromium-browser --no-sandbox --start-maximized https://chat.qwen.ai > /tmp/chrome.log 2>&1 &
sleep 5
echo "browser launched"
