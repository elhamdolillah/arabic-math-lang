from __future__ import annotations
import json
from collections import Counter
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
payload = json.loads((ROOT / 'evidence/MAL_DIR_CORPUS_RUN1.json').read_text(encoding='utf-8'))
total = 0
all_ok = True
print('MAL_DIR_NODE_ANALYSIS=START')
for item in payload['cases']:
    ir = item.get('ir')
    if not isinstance(ir, dict):
        continue
    nodes = ir['nodes']
    ids = [node.get('id') for node in nodes]
    sequence_ok = ids == list(range(1, len(nodes) + 1))
    root_ok = ir.get('root') == len(nodes)
    kinds = Counter(node.get('kind') for node in nodes)
    total += len(nodes)
    all_ok = all_ok and sequence_ok and root_ok
    print(f"CASE_ID={item['id']} NODES={len(nodes)} ROOT={ir.get('root')} IDS={'PASS' if sequence_ok else 'FAIL'} ROOT_CHECK={'PASS' if root_ok else 'FAIL'} KINDS={json.dumps(dict(sorted(kinds.items())), sort_keys=True)}")
print(f'TOTAL_NODES={total}')
print(f'EXPECTED_TOTAL=58')
print(f'TOTAL_MATCH={"PASS" if total == 58 else "FAIL"}')
print(f'ALL_SEQUENCE_AND_ROOT_CHECKS={"PASS" if all_ok else "FAIL"}')
