# نفّذ هذه الأوامر على VPS:
ss -tlnp | grep 1128
# أو
netstat -tlnp | grep 1128
# اختبر ما هو البروتوكول
curl -v http://localhost:1128 2>&1 | head -20
nc -zv localhost 1128
