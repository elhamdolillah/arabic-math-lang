ps aux | grep -E "x11vnc|Xvfb|websockify|chromium" | grep -v grep
echo "=== DISPLAY ==="
DISPLAY=:99 xdpyinfo 2>&1 | head -5
echo "=== BROWSER LOG ==="
tail -20 /tmp/qwen_browser.log
echo "=== X11VNC LOG ==="
journalctl -u x11vnc --no-pager -n 10 2>/dev/null || true
