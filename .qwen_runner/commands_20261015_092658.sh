# شغّل Open WebUI على المنفذ 1128
docker run -d -p 1128:8080 \
  -v open-webui:/app/backend/data \
  --name open-webui \
  ghcr.io/open-webui/open-webui:main
# عدّل qtxt ليستخدم 1128
sed -i 's|localhost:3000|localhost:1128|' /usr/local/bin/qtxt
qtxt
