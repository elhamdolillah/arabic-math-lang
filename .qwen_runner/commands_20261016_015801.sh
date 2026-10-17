rm -f /etc/nginx/sites-enabled/default
cat > /etc/nginx/sites-available/novnc << 'EOF'
server {
    listen 80 default_server;
    server_name _;
    location / {
        proxy_pass http://localhost:6080;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
        proxy_read_timeout 3600;
    }
}
EOF
ln -sf /etc/nginx/sites-available/novnc /etc/nginx/sites-enabled/novnc
nginx -t && systemctl reload nginx
sleep 2
curl -s -o /dev/null -w "PORT80: HTTP %{http_code}" http://localhost:80/vnc.html
echo ""
