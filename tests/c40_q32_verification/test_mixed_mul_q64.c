#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

extern int64_t mixed_mul_q64(int64_t r, int64_t acc_hi, uint64_t acc_lo);

static int64_t oracle(int64_t r, int64_t hi, uint64_t lo) {
    __int128 acc = ((__int128)hi << 64) | lo;
    __int128 p = (__int128)r * acc;
    return (int64_t)(p >> 64);
}

int main(void) {
    uint64_t state = UINT64_C(0xC40D6464128);
    unsigned long cases = 0;
    for (int edge = 0; edge < 16; ++edge) {
        int64_t r = (edge & 1) ? INT64_MIN + edge : INT64_MAX - edge;
        int64_t hi = (edge & 2) ? 1 : 0;
        uint64_t lo = (edge & 4) ? UINT64_MAX - (unsigned)edge : (uint64_t)edge;
        int64_t got = mixed_mul_q64(r, hi, lo);
        int64_t want = oracle(r, hi, lo);
        ++cases;
        if (got != want) { printf("FAIL edge %d got=%lld want=%lld\n", edge, (long long)got, (long long)want); return 1; }
    }
    for (int i = 0; i < 10000; ++i) {
        state = state * UINT64_C(6364136223846793005) + UINT64_C(1442695040888963407);
        int64_t r = (int64_t)state;
        state = state * UINT64_C(6364136223846793005) + UINT64_C(1442695040888963407);
        int64_t hi = (int64_t)(state & UINT64_C(0x3));
        if (state & UINT64_C(0x8000)) hi = -hi;
        state = state * UINT64_C(6364136223846793005) + UINT64_C(1442695040888963407);
        uint64_t lo = state;
        int64_t got = mixed_mul_q64(r, hi, lo);
        int64_t want = oracle(r, hi, lo);
        ++cases;
        if (got != want) { printf("FAIL i=%d got=%lld want=%lld\n", i, (long long)got, (long long)want); return 1; }
    }
    printf("MIXED_ASM_CASES=%lu\nMIXED_ASM=PASS\n", cases);
    return 0;
}
