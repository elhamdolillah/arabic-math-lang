apt-get install -y xvfb x11vnc novnc websockify
Xvfb :99 -screen 0 1280x800x24 &
export DISPLAY=:99
x11vnc -display :99 -forever -nopw &
websockify --web /usr/share/novnc 6080 localhost:5900 &
echo "noVNC ready on port 6080"
