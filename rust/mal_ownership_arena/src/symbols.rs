use crate::NodeID;

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct SymbolEntry<'a> {
    pub name: &'a str,
    pub value: u64,
    pub node_id: NodeID,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum SymbolError {
    CapacityExceeded,
    UndefinedSymbol,
}

pub struct ArenaSymbolTable<'a, const N: usize> {
    entries: [Option<SymbolEntry<'a>>; N],
    len: usize,
}

impl<'a, const N: usize> ArenaSymbolTable<'a, N> {
    pub fn new() -> Self {
        Self { entries: [None; N], len: 0 }
    }

    pub fn bind(&mut self, name: &'a str, value: u64, node_id: NodeID) -> Result<(), SymbolError> {
        for entry in &mut self.entries[..self.len] {
            if entry.as_ref().is_some_and(|item| item.name == name) {
                *entry = Some(SymbolEntry { name, value, node_id });
                return Ok(());
            }
        }
        if self.len >= N {
            return Err(SymbolError::CapacityExceeded);
        }
        self.entries[self.len] = Some(SymbolEntry { name, value, node_id });
        self.len += 1;
        Ok(())
    }

    pub fn lookup(&self, name: &str) -> Result<SymbolEntry<'a>, SymbolError> {
        self.entries[..self.len]
            .iter()
            .flatten()
            .find(|entry| entry.name == name)
            .copied()
            .ok_or(SymbolError::UndefinedSymbol)
    }

    pub fn len(&self) -> usize { self.len }
}

impl<'a, const N: usize> Default for ArenaSymbolTable<'a, N> {
    fn default() -> Self { Self::new() }
}
