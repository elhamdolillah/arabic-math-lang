#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
OUT="${1:-$ROOT/bare_metal_evidence/$(date -u +%Y%m%dT%H%M%SZ)}"
mkdir -p "$OUT"
export PYTHONPATH="$ROOT${PYTHONPATH:+:$PYTHONPATH}"
{
  printf 'DATE_UTC=%s\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  printf 'HOSTNAME=%s\n' "$(hostname)"
  printf 'KERNEL=%s\n' "$(uname -a)"
  printf 'VIRTUALIZATION=%s\n' "$(systemd-detect-virt 2>/dev/null || echo unknown)"
  printf 'CPU=%s\n' "$(grep -m1 'model name' /proc/cpuinfo 2>/dev/null || echo unknown)"
  printf 'MEMORY=%s\n' "$(awk '/MemTotal/{print $0}' /proc/meminfo)"
  printf 'BOOT_MODE=%s\n' "$(if [ -d /sys/firmware/efi ]; then echo UEFI; else echo BIOS_OR_UNKNOWN; fi)"
  printf 'ROOT_MOUNT=%s\n' "$(findmnt -no SOURCE,FSTYPE,OPTIONS / 2>/dev/null || echo unknown)"
  printf 'BLOCK_DEVICES=%s\n' "$(lsblk -dn -o NAME,TYPE,SIZE 2>/dev/null | tr '\\n' ';' || echo unknown)"
} | tee "$OUT/environment.txt"
python3 -m py_compile "$ROOT"/vnext/tools/*.py "$ROOT"/vnext/tests/*.py | tee "$OUT/py_compile.log"
for test in "$ROOT"/vnext/tests/test_*.py; do
  python3 "$test" >> "$OUT/vnext_tests.log" 2>&1
done
printf 'OPERATIONAL=PASS\n' | tee "$OUT/status.txt"
printf 'INSTALL_ACTION=NONE\nDISK_WRITE_ACTION=NONE\n' | tee -a "$OUT/status.txt"
printf 'HARDWARE_PROOF_REQUIRES_REVIEW=TRUE\n' | tee -a "$OUT/status.txt"
find "$OUT" -type f ! -name CHAIN.sha256 -print0 | sort -z | xargs -0 sha256sum > "$OUT/CHAIN.sha256"
printf 'EVIDENCE_DIR=%s\n' "$OUT"
