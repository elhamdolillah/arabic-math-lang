tee /usr/local/bin/qtxt > /dev/null << 'ENDOFSCRIPT'
#!/bin/bash
set -e
CHAT_UI_URL="${CHAT_UI_URL:-http://localhost:3000}"
OUTPUT_DIR="${OUTPUT_DIR:-$HOME/qtxt_output}"
LOG_FILE="${LOG_FILE:-$HOME/qtxt.log}"
mkdir -p "$OUTPUT_DIR"
read_last_response() {
python3 << PYEOF
from playwright.sync_api import sync_playwright
with sync_playwright() as p:
    browser = p.chromium.launch(headless=True)
    page = browser.new_page()
    page.goto("$CHAT_UI_URL")
    page.wait_for_selector(".message-assistant:last-child", timeout=5000)
    print(page.query_selector(".message-assistant:last-child").inner_text())
    browser.close()
PYEOF
}
extract_code() {
    local r="$1"
    MAL=$(echo "$r" | sed -n '/```mal/,/```/p' | sed '1d;$d')
    BASH=$(echo "$r" | sed -n '/```bash/,/```/p' | sed '1d;$d')
    C=$(echo "$r" | sed -n '/```c/,/```/p' | sed '1d;$d')
    PY=$(echo "$r" | sed -n '/```python/,/```/p' | sed '1d;$d')
    if [ -n "$MAL" ]; then echo "MAL"; echo "$MAL"
    elif [ -n "$BASH" ]; then echo "BASH"; echo "$BASH"
    elif [ -n "$C" ]; then echo "C"; echo "$C"
    elif [ -n "$PY" ]; then echo "PYTHON"; echo "$PY"
    else echo "NONE"; fi
}
execute_code() {
    local type="$1" code="$2" ts=$(date +%Y%m%d_%H%M%S)
    case "$type" in
        "MAL")
            f="$OUTPUT_DIR/code_${ts}.mal"
            echo "$code" > "$f"
            echo "MAL: $f"
            cf="$OUTPUT_DIR/code_${ts}.c"
            /root/ilm-al-kitab/MAL/src/cli/target/release/malc compile "$f" --emit-c > "$cf" 2>&1
            if [ $? -eq 0 ]; then
                b="$OUTPUT_DIR/code_${ts}"
                gcc -O3 -march=native "$cf" -o "$b" -lm
                if [ $? -eq 0 ]; then
                    echo "RUN..."
                    "$b"
                fi
            fi
            ;;
        "BASH")
            f="$OUTPUT_DIR/s_${ts}.sh"
            echo "$code" > "$f"
            chmod +x "$f"
            bash "$f"
            ;;
        "C")
            f="$OUTPUT_DIR/code_${ts}.c"
            echo "$code" > "$f"
            b="$OUTPUT_DIR/code_${ts}"
            gcc -O3 -march=native "$f" -o "$b" -lm
            if [ $? -eq 0 ]; then
                echo "RUN..."
                "$b"
            fi
            ;;
        "PYTHON")
            f="$OUTPUT_DIR/s_${ts}.py"
            echo "$code" > "$f"
            python3 "$f"
            ;;
        "NONE")
            echo "NO CODE"
            return 1
            ;;
    esac
}
main() {
    echo "======================================"
    echo "  qtxt - read last response & execute"
    echo "======================================"
    R=$(read_last_response)
    CR=$(extract_code "$R")
    T=$(echo "$CR" | head -1)
    C=$(echo "$CR" | tail -n +2)
    if [ "$T" == "NONE" ]; then
        echo "NO CODE FOUND"
        exit 1
    fi
    echo "CODE TYPE: $T"
    execute_code "$T" "$C"
    E=$?
    echo "[$(date)] $T, Exit: $E" >> "$LOG_FILE"
    exit $E
}
main "$@"
ENDOFSCRIPT
chmod +x /usr/local/bin/qtxt
echo "✅ qtxt installed"
which qtxt
timeout 30 qtxt
