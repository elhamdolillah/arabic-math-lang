use mal_ownership_arena::ast::{AstNode, AstOpcode};
use mal_ownership_arena::evaluator::{DeterministicEvaluator, EvaluatorError};
use mal_ownership_arena::symbols::{ArenaSymbolTable, SymbolError};
use mal_ownership_arena::{FixedArena, NodeID};

#[test]
fn stage3_symbol_table_is_bounded_and_updates_deterministically() {
    let mut table = ArenaSymbolTable::<2>::new();
    table.bind("س", 10, NodeID(1)).unwrap();
    table.bind("ص", 20, NodeID(2)).unwrap();
    assert_eq!(table.lookup("س").unwrap().value, 10);
    table.bind("س", 15, NodeID(3)).unwrap();
    assert_eq!(table.lookup("س").unwrap().value, 15);
    assert_eq!(table.bind("ع", 30, NodeID(4)), Err(SymbolError::CapacityExceeded));
}

#[test]
fn stage3_evaluator_evaluates_arithmetic_tree() {
    let mut ast = FixedArena::<AstNode<'_>, 8>::new();
    ast.allocate(AstNode { id: NodeID(0), opcode: AstOpcode::LiteralNum, name: None, left: None, right: None, numeric_value: 10 }).unwrap();
    ast.allocate(AstNode { id: NodeID(1), opcode: AstOpcode::LiteralNum, name: None, left: None, right: None, numeric_value: 5 }).unwrap();
    ast.allocate(AstNode { id: NodeID(2), opcode: AstOpcode::Add, name: None, left: Some(NodeID(0)), right: Some(NodeID(1)), numeric_value: 15 }).unwrap();
    let mut symbols = ArenaSymbolTable::<2>::new();
    assert_eq!(DeterministicEvaluator::evaluate(&ast, NodeID(2), &mut symbols), Ok(15));
}

#[test]
fn stage3_evaluator_rejects_undefined_symbol() {
    let mut ast = FixedArena::<AstNode<'_>, 4>::new();
    ast.allocate(AstNode { id: NodeID(0), opcode: AstOpcode::BindSymbol, name: Some("غير_معرف"), left: None, right: None, numeric_value: 0 }).unwrap();
    let mut symbols = ArenaSymbolTable::<2>::new();
    assert_eq!(DeterministicEvaluator::evaluate(&ast, NodeID(0), &mut symbols), Err(EvaluatorError::SymbolError(SymbolError::UndefinedSymbol)));
}
