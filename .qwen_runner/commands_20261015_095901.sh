for PORT in 7860 8787 8000 8090; do
  echo "=== PORT $PORT ==="
  curl -s -m 5 "http://localhost:$PORT/" | head -c 500
  echo ""
  echo ""
done
