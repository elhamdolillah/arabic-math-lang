echo 'ps aux | grep x11vnc | grep -v grep
echo "---"
curl -s -o /dev/null -w "WS: HTTP %{http_code}" http://localhost:80/vnc/websockify
echo ""
echo "---"
curl -s -o /dev/null -w "VNC: HTTP %{http_code}" http://localhost:80/vnc/vnc.html
echo ""' > ~/storage/shared/ilm-al-kitab-runner/results/ملف.txt
qtxt
