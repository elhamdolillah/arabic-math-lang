use mal_ownership_arena::ast::{AstNode, AstOpcode};
use mal_ownership_arena::lexer::{LexicalToken, DeterministicLexer};
use mal_ownership_arena::parser::{DeterministicParser, ParseError};
use mal_ownership_arena::{FixedArena, NodeID};

#[test]
fn stage1_parser_builds_bounded_ast() {
    let source = "بنية_عقدة_اختبار = 42";
    let mut token_arena = FixedArena::<LexicalToken<'_>, 16>::new();
    let mut ast_arena = FixedArena::<AstNode<'_>, 16>::new();
    let lexer = DeterministicLexer::new(source);
    let mut parser = DeterministicParser::new(lexer);

    let root = parser.parse_expression(&mut token_arena, &mut ast_arena);
    assert_eq!(root, Ok(NodeID(1)));

    let root_node = ast_arena.get(NodeID(1));
    assert_eq!(root_node.map(|node| node.opcode), Ok(AstOpcode::DeclareNode));
    assert_eq!(root_node.map(|node| node.name), Ok(Some("بنية_عقدة_اختبار")));
    assert_eq!(root_node.map(|node| node.right), Ok(Some(NodeID(0))));

    let literal = ast_arena.get(NodeID(0));
    assert_eq!(literal.map(|node| node.opcode), Ok(AstOpcode::LiteralNum));
    assert_eq!(literal.map(|node| node.numeric_value), Ok(42));
}

#[test]
fn stage1_parser_rejects_restricted_evaluator() {
    let source = "eval(malicious_code)";
    let mut token_arena = FixedArena::<LexicalToken<'_>, 16>::new();
    let mut ast_arena = FixedArena::<AstNode<'_>, 16>::new();
    let lexer = DeterministicLexer::new(source);
    let mut parser = DeterministicParser::new(lexer);

    let result = parser.parse_expression(&mut token_arena, &mut ast_arena);
    assert_eq!(result, Err(ParseError::ConstitutionalViolation));
}

#[test]
fn stage1_parser_rejects_incomplete_expression() {
    let source = "بنية_عقدة =";
    let mut token_arena = FixedArena::<LexicalToken<'_>, 16>::new();
    let mut ast_arena = FixedArena::<AstNode<'_>, 16>::new();
    let lexer = DeterministicLexer::new(source);
    let mut parser = DeterministicParser::new(lexer);

    let result = parser.parse_expression(&mut token_arena, &mut ast_arena);
    assert_eq!(result, Err(ParseError::UnexpectedEof));
}

#[test]
fn stage1_parser_rejects_extra_tokens() {
    let source = "بنية_عقدة = 42 زائد";
    let mut token_arena = FixedArena::<LexicalToken<'_>, 16>::new();
    let mut ast_arena = FixedArena::<AstNode<'_>, 16>::new();
    let lexer = DeterministicLexer::new(source);
    let mut parser = DeterministicParser::new(lexer);

    let result = parser.parse_expression(&mut token_arena, &mut ast_arena);
    assert_eq!(result, Err(ParseError::SyntaxError));
}
