use crate::ast::{AstNode, AstOpcode};
use crate::symbols::{ArenaSymbolTable, SymbolError};
use crate::{FixedArena, FixedArenaError, NodeID};

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum EvaluatorError {
    ArenaError(FixedArenaError),
    SymbolError(SymbolError),
    ArithmeticOverflow,
    DivisionByZero,
    InvalidNode,
}

impl From<FixedArenaError> for EvaluatorError {
    fn from(error: FixedArenaError) -> Self { Self::ArenaError(error) }
}

impl From<SymbolError> for EvaluatorError {
    fn from(error: SymbolError) -> Self { Self::SymbolError(error) }
}

pub struct DeterministicEvaluator;

impl DeterministicEvaluator {
    pub fn evaluate<'a, const N_AST: usize, const N_SYMBOLS: usize>(
        ast: &FixedArena<AstNode<'a>, N_AST>,
        root: NodeID,
        symbols: &mut ArenaSymbolTable<'a, N_SYMBOLS>,
    ) -> Result<u64, EvaluatorError> {
        Self::visit(ast, root, symbols)
    }

    fn visit<'a, const N_AST: usize, const N_SYMBOLS: usize>(
        ast: &FixedArena<AstNode<'a>, N_AST>,
        id: NodeID,
        symbols: &mut ArenaSymbolTable<'a, N_SYMBOLS>,
    ) -> Result<u64, EvaluatorError> {
        let node = *ast.get(id)?;
        match node.opcode {
            AstOpcode::LiteralNum => Ok(node.numeric_value),
            AstOpcode::BindSymbol => symbols.lookup(node.name.ok_or(EvaluatorError::InvalidNode)?).map(|entry| entry.value).map_err(EvaluatorError::from),
            AstOpcode::DeclareNode => {
                let value = Self::visit(ast, node.right.ok_or(EvaluatorError::InvalidNode)?, symbols)?;
                symbols.bind(node.name.ok_or(EvaluatorError::InvalidNode)?, value, id)?;
                Ok(value)
            }
            AstOpcode::Add => Self::binary(ast, node, symbols, |left, right| left.checked_add(right)),
            AstOpcode::Subtract => Self::binary(ast, node, symbols, |left, right| left.checked_sub(right)),
            AstOpcode::Multiply => Self::binary(ast, node, symbols, |left, right| left.checked_mul(right)),
            AstOpcode::Divide => {
                let left = Self::visit(ast, node.left.ok_or(EvaluatorError::InvalidNode)?, symbols)?;
                let right = Self::visit(ast, node.right.ok_or(EvaluatorError::InvalidNode)?, symbols)?;
                if right == 0 { return Err(EvaluatorError::DivisionByZero); }
                Ok(left / right)
            }
            AstOpcode::PassThrough => Self::visit(ast, node.right.ok_or(EvaluatorError::InvalidNode)?, symbols),
            AstOpcode::Sequence => {
                Self::visit(ast, node.left.ok_or(EvaluatorError::InvalidNode)?, symbols)?;
                Self::visit(ast, node.right.ok_or(EvaluatorError::InvalidNode)?, symbols)
            }
        }
    }

    fn binary<'a, const N_AST: usize, const N_SYMBOLS: usize, F>(
        ast: &FixedArena<AstNode<'a>, N_AST>,
        node: AstNode<'a>,
        symbols: &mut ArenaSymbolTable<'a, N_SYMBOLS>,
        operation: F,
    ) -> Result<u64, EvaluatorError>
    where
        F: FnOnce(u64, u64) -> Option<u64>,
    {
        let left = Self::visit(ast, node.left.ok_or(EvaluatorError::InvalidNode)?, symbols)?;
        let right = Self::visit(ast, node.right.ok_or(EvaluatorError::InvalidNode)?, symbols)?;
        operation(left, right).ok_or(EvaluatorError::ArithmeticOverflow)
    }
}
