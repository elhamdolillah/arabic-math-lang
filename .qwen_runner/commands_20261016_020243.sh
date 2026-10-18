python3 << 'PYEOF'
import glob
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
for f in glob.glob("/etc/nginx/sites-enabled/*"):
    s = open(f).read()
    if "/vnc/" in s:
        print("skip:", f)
        continue
    idx = s.rfind("}")
    if idx == -1:
        print("skip no brace:", f)
        continue
    s = s[:idx] + block + s[idx:]
    open(f, "w").write(s)
    print("added:", f)
PYEOF
nginx -t && systemctl reload nginx
sleep 2
curl -s -o /dev/null -w "VNC: HTTP %{http_code}" http://localhost:80/vnc/vnc.html
echo ""
