from vnext.tools.recursion_guard import GuardAbort, GuardLimits, enter, leave, start, tick


def main():
    state = start(GuardLimits(fuel=2, max_depth=2, memory_units=3, timeout_seconds=10))
    enter(state); tick(state, memory_delta=1); leave(state)
    tick(state, memory_delta=1)
    try:
        tick(state)
    except GuardAbort as exc:
        assert str(exc) == 'fuel_exhausted'
    else:
        raise AssertionError('fuel was not enforced')
    depth = start(GuardLimits(fuel=10, max_depth=1, memory_units=10, timeout_seconds=10))
    enter(depth)
    try:
        enter(depth)
    except GuardAbort as exc:
        assert str(exc) == 'stack_depth_exceeded'
    else:
        raise AssertionError('depth was not enforced')
    memory = start(GuardLimits(fuel=10, max_depth=2, memory_units=1, timeout_seconds=10))
    try:
        tick(memory, memory_delta=2)
    except GuardAbort as exc:
        assert str(exc) == 'memory_limit_exceeded'
    else:
        raise AssertionError('memory was not enforced')
    print('VNEXT_GUARD_FUEL=PASS')
    print('VNEXT_GUARD_STACK_DEPTH=PASS')
    print('VNEXT_GUARD_MEMORY=PASS')
    print('VNEXT_GUARD_BALANCED_PATH=PASS')


if __name__ == '__main__':
    main()
