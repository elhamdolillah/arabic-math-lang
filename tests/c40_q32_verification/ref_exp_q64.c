#include <math.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

#define Q32 ((long double)4294967296.0L)
#define Q64 ((long double)18446744073709551616.0L)

static const __int128 LN2_Q64 = (__int128)12786308645202655660ULL;
static const __int128 COEFF_Q64[] = {
    (__int128)38510819324LL,           /* 1/12! */
    (__int128)462129831893LL,          /* 1/11! */
    (__int128)5083428150824LL,         /* 1/10! */
    (__int128)50834281508238LL,        /* 1/9! */
    (__int128)457508533574146LL,       /* 1/8! */
    (__int128)3660068268593165LL,      /* 1/7! */
    (__int128)25620477880152155LL,     /* 1/6! */
    (__int128)153722867280912930LL,    /* 1/5! */
    (__int128)768614336404564651LL,    /* 1/4! */
    (__int128)3074457345618258603LL,   /* 1/3! */
    (__int128)9223372036854775808ULL,  /* 1/2! */
    ((__int128)1 << 64),             /* 1/1! */
    ((__int128)1 << 64)              /* 1/0! */
};

static long long exp_q32_reference(long long x_q32) {
    long double x = (long double)x_q32 / Q32;
    long double y = expl(x) * Q32;
    return (long long)llroundl(y);
}

static long long exp_q64_model(long long x_q32) {
    long double x = (long double)x_q32 / Q32;
    long double y = x / logl(2.0L);
    long long k = (long long)floorl(y + 0.5L);
    __int128 x_q64 = (__int128)x_q32 << 32;
    __int128 r_q64 = x_q64 - (__int128)k * LN2_Q64;
    __int128 h = COEFF_Q64[0];
    for (int i = 1; i < 13; ++i) {
        __int128 p = r_q64 * h;
        h = (p >= 0 ? (p + ((__int128)1 << 63)) >> 64
                     : -(((-p) + ((__int128)1 << 63)) >> 64));
        h += COEFF_Q64[i];
    }
    __int128 scaled = k >= 0 ? (h << k) : (h >> (-k));
    __int128 q32 = scaled >= 0 ? (scaled + ((__int128)1 << 31)) >> 32
                               : -(((-scaled) + ((__int128)1 << 31)) >> 32);
    return (long long)q32;
}

int main(int argc, char **argv) {
    if (argc > 1) {
        for (int i = 1; i < argc; ++i) {
            long long x = strtoll(argv[i], NULL, 10);
            printf("%lld\n", exp_q32_reference(x));
        }
        return 0;
    }
    const long long inputs[] = {0, 1, -1, 1LL<<32, -(1LL<<32), 2LL<<32,
        -(2LL<<32), 4LL<<32, 8LL<<32, 16LL<<32,
        91912300134LL, -91912300134LL};
    int failures = 0;
    for (size_t i = 0; i < sizeof(inputs)/sizeof(inputs[0]); ++i) {
        long long got = exp_q64_model(inputs[i]);
        long long ref = exp_q32_reference(inputs[i]);
        long long diff = got - ref;
        if (diff < -16 || diff > 16) failures++;
        printf("x_q32=%lld got=%lld ref=%lld diff=%lld %s\n",
               inputs[i], got, ref, diff,
               (diff >= -16 && diff <= 16) ? "PASS" : "FAIL");
    }
    printf("Q64_C_REFERENCE_FAILURES=%d\n", failures);
    return failures ? 1 : 0;
}
