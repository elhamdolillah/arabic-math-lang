use mal_ownership_arena::ast::{AstNode, AstOpcode};
use mal_ownership_arena::lexer::{DeterministicLexer, LexicalToken};
use mal_ownership_arena::parser::{DeterministicParser, ParseError};
use mal_ownership_arena::{FixedArena, NodeID};

fn parse(source: &str) -> (Result<NodeID, ParseError>, FixedArena<AstNode<'_>, 32>) {
    let mut tokens = FixedArena::<LexicalToken<'_>, 32>::new();
    let mut ast = FixedArena::<AstNode<'_>, 32>::new();
    let lexer = DeterministicLexer::new(source);
    let mut parser = DeterministicParser::new(lexer);
    let result = parser.parse_expression(&mut tokens, &mut ast);
    (result, ast)
}

#[test]
fn stage2_respects_multiplication_precedence() {
    let (result, ast) = parse("بنية_جمع = 10 + 20 * 3");
    assert_eq!(result, Ok(NodeID(5)));
    assert_eq!(ast.get(NodeID(3)).map(|node| node.opcode), Ok(AstOpcode::Multiply));
    assert_eq!(ast.get(NodeID(4)).map(|node| node.opcode), Ok(AstOpcode::Add));
    assert_eq!(ast.get(NodeID(4)).map(|node| node.numeric_value), Ok(70));
}

#[test]
fn stage2_parentheses_override_precedence() {
    let (result, ast) = parse("بنية_قوس = (5 + 5) * 2");
    assert_eq!(result, Ok(NodeID(5)));
    assert_eq!(ast.get(NodeID(2)).map(|node| node.opcode), Ok(AstOpcode::Add));
    assert_eq!(ast.get(NodeID(4)).map(|node| node.opcode), Ok(AstOpcode::Multiply));
    assert_eq!(ast.get(NodeID(4)).map(|node| node.numeric_value), Ok(20));
}

#[test]
fn stage2_rejects_division_by_zero() {
    let (result, _) = parse("بنية_قسمة = 9 / 0");
    assert_eq!(result, Err(ParseError::DivisionByZero));
}

#[test]
fn stage2_rejects_unclosed_parenthesis() {
    let (result, _) = parse("بنية_قوس = (5 + 2");
    assert_eq!(result, Err(ParseError::UnexpectedEof));
}

#[test]
fn stage2_rejects_expression_overflow() {
    let (result, _) = parse("بنية_فيض = 18446744073709551615 + 1");
    assert_eq!(result, Err(ParseError::ArithmeticOverflow));
}
