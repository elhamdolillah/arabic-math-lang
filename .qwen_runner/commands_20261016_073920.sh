qtxt
========== COMMANDS TO EXECUTE ==========
     1  ps aux | grep x11vnc | grep -v grep
     2  echo "---"
     3  curl -s -o /dev/null -w "WS: HTTP %{http_code}" http://localhost:80/vnc/websockify
     4  echo ""
=========================================
