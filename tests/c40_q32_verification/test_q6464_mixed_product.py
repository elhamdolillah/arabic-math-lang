import math
MASK = (1 << 64) - 1

def mixed_mul_shift64(r: int, acc: int) -> int:
    # acc = hi*2^64 + lo, with lo unsigned and hi arithmetic.
    hi = acc >> 64
    lo = acc & MASK
    return r * hi + ((r * lo) >> 64)

def exact(r: int, acc: int) -> int:
    return (r * acc) >> 64

cases = [
    (0, 0),
    (1 << 63, 1 << 64),
    (-(1 << 63), 1 << 64),
    (1 << 63, (1 << 64) + 1),
    (-(1 << 63), (1 << 64) + 1),
    (1 << 62, (1 << 64) + (1 << 63)),
    (-(1 << 62), (1 << 64) + (1 << 63)),
    (-(1 << 63) + 1, (1 << 65) - 1),
    ((1 << 63) - 1, (1 << 65) - 1),
]
# Deterministic pseudo-random edge sweep; no external data.
state = 0xC40D_6464_128
for _ in range(256):
    state = (state * 6364136223846793005 + 1442695040888963407) & ((1 << 128) - 1)
    r = (state & ((1 << 64) - 1))
    if r & (1 << 63): r -= 1 << 64
    state = (state * 6364136223846793005 + 1442695040888963407) & ((1 << 128) - 1)
    acc = state & ((1 << 66) - 1)
    if acc & (1 << 65): acc -= 1 << 66
    cases.append((r, acc))

failures = []
for i, (r, acc) in enumerate(cases):
    got = mixed_mul_shift64(r, acc)
    want = exact(r, acc)
    if got != want:
        failures.append((i, r, acc, got, want))

print(f"CASES={len(cases)}")
print(f"FAILURES={len(failures)}")
if failures:
    for row in failures[:8]: print(row)
    raise SystemExit(1)
print("MIXED_PRODUCT=PASS")
print("NOTE=Pure deterministic integer model; no VPS files modified.")
