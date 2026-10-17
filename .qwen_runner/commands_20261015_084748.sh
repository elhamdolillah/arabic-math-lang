#!/bin/bash
# ═══════════════════════════════════════════════════════════
# qtxt.sh — قراءة آخر رد من Chat UI (Qwen 3.6/3.7) وتنفيذ الكود
# ═══════════════════════════════════════════════════════════
set -e
# ═══════════════════════════════════════════════════════════
# الإعدادات
# ═══════════════════════════════════════════════════════════
# عنوان Chat UI (Open WebUI / Chatbot UI)
CHAT_UI_URL="${CHAT_UI_URL:-http://localhost:3000}"
CHAT_UI_API="${CHAT_UI_API:-http://localhost:3000/api}"
API_KEY="${API_KEY:-}"
# مجلد الإخراج
OUTPUT_DIR="${OUTPUT_DIR:-$HOME/qtxt_output}"
LOG_FILE="${LOG_FILE:-$HOME/qtxt.log}"
mkdir -p "$OUTPUT_DIR"
# ═══════════════════════════════════════════════════════════
# دالة: قراءة آخر رد من Chat UI
# ═══════════════════════════════════════════════════════════
read_last_response() {
    # طريقة 1: عبر API (إذا كان متاحاً)
    if [ -n "$API_KEY" ]; then
        LAST_RESPONSE=$(curl -s "$CHAT_UI_API/chat/completions" \
            -H "Authorization: Bearer $API_KEY" \
            -H "Content-Type: application/json" \
            -d '{"model": "qwen3.6", "messages": [{"role": "user", "content": "last"}]}' \
            | jq -r '.choices[0].message.content' 2>/dev/null)
    fi
    # طريقة 2: عبر scraping (إذا لم يكن API متاحاً)
    if [ -z "$LAST_RESPONSE" ] || [ "$LAST_RESPONSE" == "null" ]; then
        # استخدام playwright/puppeteer لقراءة الصفحة
        LAST_RESPONSE=$(python3 -c "
from playwright.sync_api import sync_playwright
with sync_playwright() as p:
    browser = p.chromium.launch()
    page = browser.new_page()
    page.goto('$CHAT_UI_URL')
    page.wait_for_selector('.message-assistant:last-child')
    response = page.query_selector('.message-assistant:last-child').inner_text()
    print(response)
    browser.close()
")
    fi
    if [ -z "$LAST_RESPONSE" ]; then
        echo "❌ خطأ: لم يتم العثور على رد"
        exit 1
    fi
    echo "$LAST_RESPONSE"
}
# ═══════════════════════════════════════════════════════════
# دالة: استخراج الكود
# ═══════════════════════════════════════════════════════════
extract_code() {
    local response="$1"
    # استخراج الكود من code blocks
    MAL_CODE=$(echo "$response" | sed -n '/```mal/,/```/p' | sed '1d;$d')
    BASH_CODE=$(echo "$response" | sed -n '/```bash/,/```/p' | sed '1d;$d')
    C_CODE=$(echo "$response" | sed -n '/```c/,/```/p' | sed '1d;$d')
    PY_CODE=$(echo "$response" | sed -n '/```python/,/```/p' | sed '1d;$d')
    if [ -n "$MAL_CODE" ]; then
        echo "MAL"
        echo "$MAL_CODE"
    elif [ -n "$BASH_CODE" ]; then
        echo "BASH"
        echo "$BASH_CODE"
    elif [ -n "$C_CODE" ]; then
        echo "C"
        echo "$C_CODE"
    elif [ -n "$PY_CODE" ]; then
        echo "PYTHON"
        echo "$PY_CODE"
    else
        echo "NONE"
    fi
}
# ═══════════════════════════════════════════════════════════
# دالة: تنفيذ الكود
# ═══════════════════════════════════════════════════════════
execute_code() {
    local code_type="$1"
    local code="$2"
    local timestamp=$(date +%Y%m%d_%H%M%S)
    case "$code_type" in
        "MAL")
            local mal_file="$OUTPUT_DIR/code_${timestamp}.mal"
            echo "$code" > "$mal_file"
            echo "📝 MAL: $mal_file"
            local c_file="$OUTPUT_DIR/code_${timestamp}.c"
            /root/ilm-al-kitab/MAL/src/cli/target/release/malc compile "$mal_file" --emit-c > "$c_file" 2>&1
            if [ $? -eq 0 ]; then
                local binary="$OUTPUT_DIR/code_${timestamp}"
                gcc -O3 -march=native "$c_file" -o "$binary" -lm
                if [ $? -eq 0 ]; then
                    echo "🚀 تنفيذ..."
                    "$binary"
                fi
            fi
            ;;
        "BASH")
            local bash_file="$OUTPUT_DIR/script_${timestamp}.sh"
            echo "$code" > "$bash_file"
            chmod +x "$bash_file"
            echo "🚀 تنفيذ..."
            bash "$bash_file"
            ;;
        "C")
            local c_file="$OUTPUT_DIR/code_${timestamp}.c"
            echo "$code" > "$c_file"
            local binary="$OUTPUT_DIR/code_${timestamp}"
            gcc -O3 -march=native "$c_file" -o "$binary" -lm
            if [ $? -eq 0 ]; then
                echo "🚀 تنفيذ..."
                "$binary"
            fi
            ;;
        "PYTHON")
            local py_file="$OUTPUT_DIR/script_${timestamp}.py"
            echo "$code" > "$py_file"
            echo "🚀 تنفيذ..."
            python3 "$py_file"
            ;;
        "NONE")
            echo "⚠️ لا يوجد كود"
            return 1
            ;;
    esac
}
# ═══════════════════════════════════════════════════════════
# الدالة الرئيسية
# ═══════════════════════════════════════════════════════════
main() {
    echo "═══════════════════════════════════════════════════════════"
    echo "  qtxt.sh — قراءة آخر رد من Chat UI وتنفيذ الكود"
    echo "═══════════════════════════════════════════════════════════"
    echo ""
    echo "📖 قراءة آخر رد من Chat UI..."
    LAST_RESPONSE=$(read_last_response)
    echo "🔍 استخراج الكود..."
    CODE_RESULT=$(extract_code "$LAST_RESPONSE")
    CODE_TYPE=$(echo "$CODE_RESULT" | head -1)
    CODE=$(echo "$CODE_RESULT" | tail -n +2)
    if [ "$CODE_TYPE" == "NONE" ]; then
        echo "❌ لا يوجد كود"
        exit 1
    fi
    echo "✅ نوع الكود: $CODE_TYPE"
    echo ""
    echo "═══════════════════════════════════════════════════════════"
    echo "  تنفيذ..."
    echo "═══════════════════════════════════════════════════════════"
    execute_code "$CODE_TYPE" "$CODE"
    local exit_code=$?
    echo ""
    echo "═══════════════════════════════════════════════════════════"
    if [ $exit_code -eq 0 ]; then
        echo "✅ نجح"
    else
        echo "❌ فشل"
    fi
    echo "═══════════════════════════════════════════════════════════"
    echo "[$(date)] $CODE_TYPE, Exit: $exit_code" >> "$LOG_FILE"
    exit $exit_code
}
main "$@"
