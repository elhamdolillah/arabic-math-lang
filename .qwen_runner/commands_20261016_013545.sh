pkill -f chromium
sleep 2
rm -f /root/qwen_profile/SingletonLock /root/qwen_profile/SingletonCookie /root/qwen_profile/SingletonSocket
DISPLAY=:99 nohup chromium-browser --no-sandbox --disable-gpu --disable-dev-shm-usage --user-data-dir=/root/qwen_profile --start-maximized https://chat.qwen.ai > /tmp/chrome.log 2>&1 &
sleep 8
ps aux | grep -i chrom | grep -v grep | head -3
echo "---LOG---"
tail -10 /tmp/chrome.log
