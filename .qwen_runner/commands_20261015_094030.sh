# اجعل qtxt يكتشف النموذج تلقائياً
FIRST_MODEL=$(curl -s http://localhost:11434/api/tags | jq -r '.models[0].name')
echo "Using model: $FIRST_MODEL"
sed -i "s|qwen2.5-coder:32b|$FIRST_MODEL|" /usr/local/bin/qtxt
timeout 60 qtxt
