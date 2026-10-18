pkill chromium
pkill chromium-browser
sleep 2
DISPLAY=:99 nohup chromium-browser --no-sandbox --user-data-dir=/root/qwen_profile --start-maximized https://chat.qwen.ai > /tmp/chrome.log 2>&1 &
sleep 5
echo "Chromium launched with qwen_profile"
