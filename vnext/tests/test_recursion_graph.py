from vnext.tools.recursion_graph import analyze, cyclic_components


def main():
    direct = analyze('def f(n):\n    if n: return f(n-1)\n    return 0\n')
    assert cyclic_components(direct) == (("f",),)
    mutual = analyze('def a(n):\n    if n: return b(n-1)\n    return 0\ndef b(n):\n    if n: return a(n-1)\n    return 0\n')
    assert cyclic_components(mutual) == (("a", "b"),)
    acyclic = analyze('def a(n):\n    return b(n)\ndef b(n):\n    return n\n')
    assert cyclic_components(acyclic) == ()
    print('VNEXT_RECURSION_DIRECT_SCC=PASS')
    print('VNEXT_RECURSION_MUTUAL_SCC=PASS')
    print('VNEXT_RECURSION_ACYCLIC=PASS')


if __name__ == '__main__':
    main()
