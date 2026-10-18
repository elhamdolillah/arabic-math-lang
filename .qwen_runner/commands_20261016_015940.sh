python3 << 'PYEOF'
import glob, re
target = None
for f in glob.glob("/etc/nginx/sites-enabled/*"):
    s = open(f).read()
    if "default_server" in s:
        target = f
        break
if not target:
    target = "/etc/nginx/sites-enabled/novnc"
s = open(target).read()
if "/vnc/" not in s:
    block = """
    location /vnc/ {
        proxy_pass http://localhost:6080/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
        proxy_read_timeout 3600;
    }
"""
    idx = s.rfind("}")
    s = s[:idx] + block + s[idx:]
    open(target, "w").write(s)
    print("Added /vnc/ to", target)
else:
    print("Already exists")
PYEOF
nginx -t && systemctl reload nginx
sleep 2
curl -s -o /dev/null -w "VNC: HTTP %{http_code}" http://localhost:80/vnc/vnc.html
echo ""
