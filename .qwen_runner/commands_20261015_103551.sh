pkill Xvfb
pkill x11vnc
pkill websockify
sleep 2
nohup Xvfb :99 -screen 0 1280x800x24 > /tmp/xvfb.log 2>&1 &
sleep 2
DISPLAY=:99 nohup x11vnc -display :99 -forever -nopw > /tmp/x11vnc.log 2>&1 &
sleep 2
nohup websockify --web /usr/share/novnc 6080 localhost:5900 > /tmp/websockify.log 2>&1 &
sleep 3
ss -tlnp | grep 6080
echo "noVNC ready on port 6080"
