# 1. اعرض النماذج المتاحة
curl -s http://localhost:11434/api/tags | jq -r '.models[].name'
# 2. اختبر API يدوياً واعرض الرد الخام
curl -s http://localhost:11434/api/chat \
  -H "Content-Type: application/json" \
  -d '{"model": "qwen2.5-coder:32b", "messages": [{"role": "user", "content": "Write hello world in MAL"}], "stream": false}' \
  | head -c 2000
# 3. اعرض أول 500 حرف من الرد لمعرفة الخطأ
curl -s http://localhost:11434/api/chat \
  -H "Content-Type: application/json" \
  -d '{"model": "qwen2.5-coder:32b", "messages": [{"role": "user", "content": "hi"}], "stream": false}' \
  | jq -r '.error // .message.content // "EMPTY"'
