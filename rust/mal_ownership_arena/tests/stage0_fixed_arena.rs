use mal_ownership_arena::{FixedArena, FixedArenaError, NodeID};

#[test]
fn stage0_10k_nodes_and_capacity_boundary() {
    let mut arena = FixedArena::<u64, 10_000>::new();

    for i in 0..10_000_u32 {
        let result = arena.allocate(u64::from(i));
        assert_eq!(result, Ok(NodeID(i)));
    }

    let overflow = arena.allocate(99_999);
    assert_eq!(overflow, Err(FixedArenaError::CapacityExceeded));
}

#[test]
fn stage0_invalid_index_is_rejected_without_panic() {
    let mut arena = FixedArena::<u64, 1>::new();
    let allocated = arena.allocate(7);
    assert_eq!(allocated, Ok(NodeID(0)));

    let invalid = arena.get(NodeID(1));
    assert_eq!(invalid, Err(FixedArenaError::InvalidIndex));
}

#[test]
fn stage0_values_are_retrievable_by_node_id() {
    let mut arena = FixedArena::<u64, 2>::new();
    let first = arena.allocate(41);
    let second = arena.allocate(42);

    assert_eq!(first, Ok(NodeID(0)));
    assert_eq!(second, Ok(NodeID(1)));

    let first_value = arena.get(NodeID(0));
    let second_value = arena.get(NodeID(1));
    assert_eq!(first_value, Ok(&41));
    assert_eq!(second_value, Ok(&42));
}
