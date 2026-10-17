ps aux | grep websockify | grep -v grep
echo "---"
curl -s -o /dev/null -w "HTTP %{http_code}" http://localhost:6080/vnc.html
echo ""
echo "---"
ls /usr/share/novnc/ | head -10
