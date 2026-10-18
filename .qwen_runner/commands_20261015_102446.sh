docker ps
sleep 30
curl -s -o /dev/null -w "HTTP %{http_code}
" http://localhost:3000
curl -s http://localhost:3000 | head -c 300
