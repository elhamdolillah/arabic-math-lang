python3 << 'PYEOF'
import base64
# السكريبت بدون backticks مباشرة — نستخدم متغيراً بدلاً منها
script = '''#!/bin/bash
set -e
OLLAMA_URL="${OLLAMA_URL:-http://localhost:11434}"
MODEL="${MODEL:-qwen2.5-coder:32b}"
OUTPUT_DIR="${OUTPUT_DIR:-$HOME/qtxt_output}"
LOG_FILE="${LOG_FILE:-$HOME/qtxt.log}"
mkdir -p "$OUTPUT_DIR"
BT='```'
read_last_response() {
curl -s "$OLLAMA_URL/api/chat" \\
  -H "Content-Type: application/json" \\
  -d "{\\"model\\": \\"$MODEL\\", \\"messages\\": [{\\"role\\": \\"user\\", \\"content\\": \\"Write a simple add function in MAL. Give only code in a code block.\\"}], \\"stream\\": false}" \\
  | jq -r '.message.content'
}
extract_code() {
    local r="$1"
    MAL=$(echo "$r" | awk -v bt="$BT" '/^'"'"''"'"'bt mal/,/^'"'"''"'"'bt/' | sed '1d;$d')
    BASH=$(echo "$r" | awk -v bt="$BT" '/^'"'"''"'"'bt bash/,/^'"'"''"'"'bt/' | sed '1d;$d')
    C=$(echo "$r" | awk -v bt="$BT" '/^'"'"''"'"'bt c/,/^'"'"''"'"'bt/' | sed '1d;$d')
    PY=$(echo "$r" | awk -v bt="$BT" '/^'"'"''"'"'bt python/,/^'"'"''"'"'bt/' | sed '1d;$d')
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
    echo "  qtxt - Ollama API direct"
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
'''
b64 = base64.b64encode(script.encode()).decode()
with open('/tmp/qtxt.b64', 'w') as f:
    f.write(b64)
print("B64 written to /tmp/qtxt.b64")
PYEOF
base64 -d /tmp/qtxt.b64 > /usr/local/bin/qtxt
chmod +x /usr/local/bin/qtxt
echo "✅ qtxt rebuilt"
timeout 60 qtxt
