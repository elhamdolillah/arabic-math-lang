#![forbid(unsafe_code)]

use std::fmt;

pub mod ast;
pub mod lexer;
pub mod parser;
pub mod symbols;
pub mod evaluator;
pub mod diagnostics;

/// معرّف عقدة مسطّح ثابت، يبدأ من الصفر داخل كل FixedArena.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub struct NodeID(pub u32);

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum FixedArenaError {
    CapacityExceeded,
    InvalidIndex,
    TypeMismatch,
}

/// Arena ثابتة السعة لمسار المرحلة صفر، دون Vec أو تخصيص وقت تشغيل داخلها.
pub struct FixedArena<T, const N: usize> {
    storage: [Option<T>; N],
    len: usize,
}

impl<T: Copy, const N: usize> FixedArena<T, N> {
    pub fn new() -> Self {
        Self {
            storage: [None; N],
            len: 0,
        }
    }

    pub fn allocate(&mut self, value: T) -> Result<NodeID, FixedArenaError> {
        if self.len >= N {
            return Err(FixedArenaError::CapacityExceeded);
        }
        let id = u32::try_from(self.len).map_err(|_| FixedArenaError::CapacityExceeded)?;
        self.storage[self.len] = Some(value);
        self.len += 1;
        Ok(NodeID(id))
    }

    pub fn next_node_id(&self) -> Result<NodeID, FixedArenaError> {
        let id = u32::try_from(self.len).map_err(|_| FixedArenaError::CapacityExceeded)?;
        if self.len >= N {
            return Err(FixedArenaError::CapacityExceeded);
        }
        Ok(NodeID(id))
    }

    pub fn get(&self, id: NodeID) -> Result<&T, FixedArenaError> {
        let idx = usize::try_from(id.0).map_err(|_| FixedArenaError::InvalidIndex)?;
        if idx >= self.len {
            return Err(FixedArenaError::InvalidIndex);
        }
        self.storage[idx].as_ref().ok_or(FixedArenaError::InvalidIndex)
    }
}

impl<T: Copy, const N: usize> Default for FixedArena<T, N> {
    fn default() -> Self {
        Self::new()
    }
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum ArenaError {
    InvalidArenaOrScope,
    RawPointerTypeForbidden,
    ArenaMismatch,
    SlotNotFound,
    StaleHandleGeneration,
    HandleTypeMismatch,
    ArenaLifetimeEscape,
    UseAfterMoveOrRelease,
    SharedBorrowDuringExclusiveBorrow,
    MultipleActiveBorrows,
    SharedBorrowNotActive,
    ExclusiveBorrowNotActive,
    MoveWhileBorrowed,
    ReleaseWhileBorrowed,
    ArenaExhausted,
}

impl fmt::Display for ArenaError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "{:?}", self)
    }
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct Handle {
    pub arena_id: u32,
    pub slot_id: u32,
    pub generation: u32,
    pub type_tag: u32,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
enum State {
    Owned,
    Released,
}

#[derive(Debug)]
struct Slot<T> {
    value: Option<T>,
    type_tag: u32,
    generation: u32,
    owner_scope: u32,
    state: State,
    shared_borrows: u32,
    exclusive_borrow: bool,
}

#[derive(Debug)]
pub struct Arena<T> {
    arena_id: u32,
    owner_scope: u32,
    slots: Vec<Option<Slot<T>>>,
}

impl<T> Arena<T> {
    pub fn new(arena_id: u32, owner_scope: u32, capacity: usize) -> Result<Self, ArenaError> {
        if arena_id == 0 || owner_scope == 0 {
            return Err(ArenaError::InvalidArenaOrScope);
        }
        Ok(Self {
            arena_id,
            owner_scope,
            slots: (0..capacity).map(|_| None).collect(),
        })
    }

    pub fn allocate(&mut self, value: T, type_tag: u32) -> Result<Handle, ArenaError> {
        if type_tag == 0 {
            return Err(ArenaError::RawPointerTypeForbidden);
        }
        let (index, slot) = self
            .slots
            .iter_mut()
            .enumerate()
            .find(|(_, slot)| slot.as_ref().map_or(true, |entry| entry.state == State::Released))
            .ok_or(ArenaError::ArenaExhausted)?;
        let slot_id = u32::try_from(index + 1).map_err(|_| ArenaError::ArenaExhausted)?;
        let generation = slot.as_ref().map_or(0, |entry| entry.generation);
        *slot = Some(Slot {
            value: Some(value),
            type_tag,
            generation,
            owner_scope: self.owner_scope,
            state: State::Owned,
            shared_borrows: 0,
            exclusive_borrow: false,
        });
        Ok(Handle { arena_id: self.arena_id, slot_id, generation, type_tag })
    }

    fn get_slot(&self, handle: Handle, scope: u32) -> Result<&Slot<T>, ArenaError> {
        if handle.arena_id != self.arena_id { return Err(ArenaError::ArenaMismatch); }
        let slot = self.slots.get(handle.slot_id.checked_sub(1).ok_or(ArenaError::SlotNotFound)? as usize)
            .and_then(Option::as_ref).ok_or(ArenaError::SlotNotFound)?;
        if slot.generation != handle.generation { return Err(ArenaError::StaleHandleGeneration); }
        if slot.type_tag != handle.type_tag { return Err(ArenaError::HandleTypeMismatch); }
        if slot.owner_scope != scope { return Err(ArenaError::ArenaLifetimeEscape); }
        if slot.state == State::Released || slot.value.is_none() { return Err(ArenaError::UseAfterMoveOrRelease); }
        Ok(slot)
    }

    fn get_slot_mut(&mut self, handle: Handle, scope: u32) -> Result<&mut Slot<T>, ArenaError> {
        if handle.arena_id != self.arena_id { return Err(ArenaError::ArenaMismatch); }
        let slot = self.slots.get_mut(handle.slot_id.checked_sub(1).ok_or(ArenaError::SlotNotFound)? as usize)
            .and_then(Option::as_mut).ok_or(ArenaError::SlotNotFound)?;
        if slot.generation != handle.generation { return Err(ArenaError::StaleHandleGeneration); }
        if slot.type_tag != handle.type_tag { return Err(ArenaError::HandleTypeMismatch); }
        if slot.owner_scope != scope { return Err(ArenaError::ArenaLifetimeEscape); }
        if slot.state == State::Released || slot.value.is_none() { return Err(ArenaError::UseAfterMoveOrRelease); }
        Ok(slot)
    }

    pub fn read(&self, handle: Handle, scope: u32) -> Result<&T, ArenaError> {
        self.get_slot(handle, scope)?.value.as_ref().ok_or(ArenaError::UseAfterMoveOrRelease)
    }

    pub fn borrow_shared(&mut self, handle: Handle, scope: u32) -> Result<Handle, ArenaError> {
        let slot = self.get_slot_mut(handle, scope)?;
        if slot.exclusive_borrow { return Err(ArenaError::SharedBorrowDuringExclusiveBorrow); }
        slot.shared_borrows += 1;
        Ok(handle)
    }

    pub fn borrow_exclusive(&mut self, handle: Handle, scope: u32) -> Result<Handle, ArenaError> {
        let slot = self.get_slot_mut(handle, scope)?;
        if slot.shared_borrows != 0 || slot.exclusive_borrow { return Err(ArenaError::MultipleActiveBorrows); }
        slot.exclusive_borrow = true;
        Ok(handle)
    }

    pub fn end_shared_borrow(&mut self, handle: Handle, scope: u32) -> Result<(), ArenaError> {
        let slot = self.get_slot_mut(handle, scope)?;
        if slot.shared_borrows == 0 { return Err(ArenaError::SharedBorrowNotActive); }
        slot.shared_borrows -= 1;
        Ok(())
    }

    pub fn end_exclusive_borrow(&mut self, handle: Handle, scope: u32) -> Result<(), ArenaError> {
        let slot = self.get_slot_mut(handle, scope)?;
        if !slot.exclusive_borrow { return Err(ArenaError::ExclusiveBorrowNotActive); }
        slot.exclusive_borrow = false;
        Ok(())
    }

    pub fn move_to(&mut self, handle: Handle, scope: u32, target_scope: u32) -> Result<Handle, ArenaError> {
        let slot = self.get_slot_mut(handle, scope)?;
        if slot.shared_borrows != 0 || slot.exclusive_borrow { return Err(ArenaError::MoveWhileBorrowed); }
        slot.owner_scope = target_scope;
        slot.generation = slot.generation.checked_add(1).ok_or(ArenaError::StaleHandleGeneration)?;
        Ok(Handle { arena_id: handle.arena_id, slot_id: handle.slot_id, generation: slot.generation, type_tag: handle.type_tag })
    }

    pub fn release(&mut self, handle: Handle, scope: u32) -> Result<(), ArenaError> {
        let slot = self.get_slot_mut(handle, scope)?;
        if slot.shared_borrows != 0 || slot.exclusive_borrow { return Err(ArenaError::ReleaseWhileBorrowed); }
        slot.value = None;
        slot.state = State::Released;
        slot.generation = slot.generation.checked_add(1).ok_or(ArenaError::StaleHandleGeneration)?;
        Ok(())
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn deterministic_first_free_slot_and_reuse_generation() {
        let mut arena = Arena::new(1, 10, 2).unwrap();
        let first = arena.allocate(7_u32, 1).unwrap();
        let second = arena.allocate(8_u32, 1).unwrap();
        assert_eq!((first.slot_id, second.slot_id), (1, 2));
        arena.release(first, 10).unwrap();
        let reused = arena.allocate(9_u32, 1).unwrap();
        assert_eq!(reused.slot_id, 1);
        assert_eq!(reused.generation, 1);
        assert_eq!(*arena.read(reused, 10).unwrap(), 9);
    }

    #[test]
    fn stale_handle_is_rejected_after_release() {
        let mut arena = Arena::new(1, 10, 1).unwrap();
        let handle = arena.allocate(7_u32, 1).unwrap();
        arena.release(handle, 10).unwrap();
        assert_eq!(arena.read(handle, 10), Err(ArenaError::StaleHandleGeneration));
    }

    #[test]
    fn borrow_rules_are_fail_closed() {
        let mut arena = Arena::new(1, 10, 1).unwrap();
        let handle = arena.allocate(7_u32, 1).unwrap();
        let shared = arena.borrow_shared(handle, 10).unwrap();
        assert_eq!(arena.borrow_exclusive(handle, 10), Err(ArenaError::MultipleActiveBorrows));
        assert_eq!(arena.release(handle, 10), Err(ArenaError::ReleaseWhileBorrowed));
        arena.end_shared_borrow(shared, 10).unwrap();
        let exclusive = arena.borrow_exclusive(handle, 10).unwrap();
        assert_eq!(arena.borrow_shared(handle, 10), Err(ArenaError::SharedBorrowDuringExclusiveBorrow));
        arena.end_exclusive_borrow(exclusive, 10).unwrap();
    }

    #[test]
    fn scope_and_type_and_arena_mismatch_are_rejected() {
        let mut arena = Arena::new(1, 10, 1).unwrap();
        let handle = arena.allocate(7_u32, 1).unwrap();
        assert_eq!(arena.read(handle, 11), Err(ArenaError::ArenaLifetimeEscape));
        assert_eq!(arena.read(Handle { type_tag: 2, ..handle }, 10), Err(ArenaError::HandleTypeMismatch));
        assert_eq!(arena.read(Handle { arena_id: 2, ..handle }, 10), Err(ArenaError::ArenaMismatch));
    }

    #[test]
    fn capacity_and_type_contracts_are_rejected() {
        let mut arena = Arena::new(1, 10, 1).unwrap();
        assert_eq!(arena.allocate(7_u32, 0), Err(ArenaError::RawPointerTypeForbidden));
        arena.allocate(7_u32, 1).unwrap();
        assert_eq!(arena.allocate(8_u32, 1), Err(ArenaError::ArenaExhausted));
    }
}
