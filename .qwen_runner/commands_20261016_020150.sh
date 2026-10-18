curl -s http://localhost:80/vnc/vnc.html | head -5
echo "---DEFAULT---"
grep -rn "default_server" /etc/nginx/sites-enabled/
echo "---VNC LOC---"
grep -rn "location /vnc/" /etc/nginx/sites-enabled/
echo "---FILES---"
ls /etc/nginx/sites-enabled/
