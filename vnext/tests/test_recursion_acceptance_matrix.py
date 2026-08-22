from vnext.tools.recursion_graph import analyze, cyclic_components
from vnext.tools.termination_certificate import verify_certificate
from vnext.tools.recursion_guard import GuardAbort, GuardLimits, start, tick


def main():
    linear = analyze('def f(n):\n    if n > 0: return f(n-1)\n    return 0\n')
    assert cyclic_components(linear) == (("f",),)
    assert verify_certificate({"kind": "natural", "transitions": [{"old": 3, "new": 2}, {"old": 2, "new": 1}]}).accepted

    nonlinear = analyze('def f(n):\n    if n <= 1: return 1\n    return f(n//2) + f(n//3)\n')
    assert cyclic_components(nonlinear) == (("f",),)
    assert verify_certificate({"kind": "natural", "transitions": [{"old": 10, "new": 5}, {"old": 10, "new": 3}]}).accepted

    mutual = analyze('def a(n):\n    if n: return b(n-1)\n    return 0\ndef b(n):\n    if n: return a(n-1)\n    return 0\n')
    assert cyclic_components(mutual) == (("a", "b"),)
    assert verify_certificate({"kind": "natural", "transitions": [{"old": 4, "new": 3}, {"old": 3, "new": 2}]}).accepted

    bad = verify_certificate({"kind": "natural", "transitions": [{"old": 2, "new": 2}, {"old": 2, "new": 3}]})
    assert not bad.accepted
    guard = start(GuardLimits(fuel=1, max_depth=2, memory_units=2, timeout_seconds=10))
    tick(guard)
    try:
        tick(guard)
    except GuardAbort as exc:
        assert str(exc) == 'fuel_exhausted'
    else:
        raise AssertionError('unguarded recursion path')
    print('VNEXT_RECURSION_LINEAR=PASS')
    print('VNEXT_RECURSION_NONLINEAR=PASS')
    print('VNEXT_RECURSION_MUTUAL=PASS')
    print('VNEXT_RECURSION_NONDECREASING_REJECT=PASS')
    print('VNEXT_RECURSION_RUNTIME_GUARD=PASS')


if __name__ == '__main__':
    main()
