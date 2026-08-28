//! تشخيص حتمي لمسار MAL دون تخصيص وقت تشغيل.
//! كل سجل تشخيصي قيمة Copy داخل مصفوفة ثابتة؛ ولا يُسمح برسائل نصية مملوكة.

use crate::evaluator::EvaluatorError;
use crate::{ArenaError, FixedArenaError};

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum DiagnosticCode {
    ArenaCapacity,
    ArenaIndex,
    ArenaType,
    FuelExhausted,
    ScopeOverflow,
    ScopeUnderflow,
    SymbolCapacity,
    UndefinedSymbol,
    ArithmeticOverflow,
    DivisionByZero,
    InvalidNode,
    FunctionNotFound,
    RecursiveCall,
    ConstitutionalViolation,
    Unknown,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct DiagnosticRecord {
    pub sequence: u32,
    pub code: DiagnosticCode,
    pub detail: u32,
}

pub struct DiagnosticBuffer<const N: usize> {
    records: [Option<DiagnosticRecord>; N],
    len: usize,
    next_sequence: u32,
}

impl<const N: usize> DiagnosticBuffer<N> {
    pub const fn new() -> Self {
        Self { records: [None; N], len: 0, next_sequence: 0 }
    }

    pub fn record(&mut self, code: DiagnosticCode, detail: u32) -> bool {
        if self.len >= N { return false; }
        let item = DiagnosticRecord { sequence: self.next_sequence, code, detail };
        self.records[self.len] = Some(item);
        self.len += 1;
        self.next_sequence = self.next_sequence.saturating_add(1);
        true
    }

    pub fn len(&self) -> usize { self.len }
    pub fn is_empty(&self) -> bool { self.len == 0 }
    pub fn get(&self, index: usize) -> Option<DiagnosticRecord> {
        if index >= self.len { None } else { self.records[index] }
    }
    pub fn clear(&mut self) {
        let mut index = 0;
        while index < self.len { self.records[index] = None; index += 1; }
        self.len = 0;
    }
}

impl<const N: usize> Default for DiagnosticBuffer<N> {
    fn default() -> Self { Self::new() }
}

pub const fn fixed_arena_code(error: FixedArenaError) -> DiagnosticCode {
    match error {
        FixedArenaError::CapacityExceeded => DiagnosticCode::ArenaCapacity,
        FixedArenaError::InvalidIndex => DiagnosticCode::ArenaIndex,
        FixedArenaError::TypeMismatch => DiagnosticCode::ArenaType,
    }
}

pub const fn arena_code(error: ArenaError) -> DiagnosticCode {
    match error {
        ArenaError::ArenaExhausted => DiagnosticCode::ArenaCapacity,
        ArenaError::ArenaLifetimeEscape => DiagnosticCode::ScopeOverflow,
        ArenaError::InvalidArenaOrScope => DiagnosticCode::ScopeUnderflow,
        ArenaError::HandleTypeMismatch => DiagnosticCode::ArenaType,
        _ => DiagnosticCode::Unknown,
    }
}

pub const fn evaluator_code(error: EvaluatorError) -> DiagnosticCode {
    match error {
        EvaluatorError::ArenaError(inner) => fixed_arena_code(inner),
        EvaluatorError::SymbolError(_) => DiagnosticCode::SymbolCapacity,
        EvaluatorError::ArithmeticOverflow => DiagnosticCode::ArithmeticOverflow,
        EvaluatorError::DivisionByZero => DiagnosticCode::DivisionByZero,
        EvaluatorError::InvalidNode => DiagnosticCode::InvalidNode,
        EvaluatorError::FuelExhausted => DiagnosticCode::FuelExhausted,
        EvaluatorError::FunctionNotFound => DiagnosticCode::FunctionNotFound,
        EvaluatorError::RecursiveCall => DiagnosticCode::RecursiveCall,
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn diagnostic_buffer_is_bounded_and_ordered() {
        let mut buffer: DiagnosticBuffer<2> = DiagnosticBuffer::new();
        assert!(buffer.is_empty());
        assert!(buffer.record(DiagnosticCode::FuelExhausted, 1000));
        assert!(buffer.record(DiagnosticCode::ScopeOverflow, 4));
        assert!(!buffer.record(DiagnosticCode::Unknown, 0));
        assert_eq!(buffer.len(), 2);
        assert_eq!(buffer.get(0).unwrap().sequence, 0);
        assert_eq!(buffer.get(1).unwrap().sequence, 1);
        assert_eq!(buffer.get(2), None);
        buffer.clear();
        assert!(buffer.is_empty());
    }

    #[test]
    fn error_mapping_is_closed_and_deterministic() {
        assert_eq!(evaluator_code(EvaluatorError::FuelExhausted), DiagnosticCode::FuelExhausted);
        assert_eq!(fixed_arena_code(FixedArenaError::CapacityExceeded), DiagnosticCode::ArenaCapacity);
        assert_eq!(arena_code(ArenaError::ArenaLifetimeEscape), DiagnosticCode::ScopeOverflow);
    }
}
