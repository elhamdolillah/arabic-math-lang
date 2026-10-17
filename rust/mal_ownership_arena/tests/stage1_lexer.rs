use mal_ownership_arena::lexer::{DeterministicLexer, LexicalToken, LexerError, TokenKind};
use mal_ownership_arena::{FixedArena, FixedArenaError, NodeID};

#[test]
fn stage1_lexer_allocates_deterministic_tokens() {
    let source = "بنية_عقدة1 = 100";
    let mut arena = FixedArena::<LexicalToken<'_>, 10>::new();
    let mut lexer = DeterministicLexer::new(source);

    let first = lexer.tokenize_next(&mut arena);
    let second = lexer.tokenize_next(&mut arena);
    let third = lexer.tokenize_next(&mut arena);
    let end = lexer.tokenize_next(&mut arena);

    assert_eq!(first, Ok(Some(NodeID(0))));
    assert_eq!(second, Ok(Some(NodeID(1))));
    assert_eq!(third, Ok(Some(NodeID(2))));
    assert_eq!(end, Ok(None));

    let token = arena.get(NodeID(0));
    assert_eq!(token.map(|value| value.kind), Ok(TokenKind::KeywordNode));
    assert_eq!(token.map(|value| value.slice), Ok("بنية_عقدة1"));
    assert_eq!(token.map(|value| value.node_id), Ok(NodeID(0)));
}

#[test]
fn stage1_lexer_marks_restricted_evaluator() {
    for source in ["eval(dangerous_code)", "exec(dangerous_code)", "unsafe pointer"] {
        let mut arena = FixedArena::<LexicalToken<'_>, 2>::new();
        let mut lexer = DeterministicLexer::new(source);
        let id = lexer.tokenize_next(&mut arena);
        assert!(matches!(id, Ok(Some(NodeID(0)))));
        let token = arena.get(NodeID(0));
        assert_eq!(token.map(|value| value.kind), Ok(TokenKind::RestrictedEvaluator));
    }
}

#[test]
fn stage1_lexer_rejects_numeric_overflow() {
    let source = "18446744073709551616";
    let mut arena = FixedArena::<LexicalToken<'_>, 1>::new();
    let mut lexer = DeterministicLexer::new(source);
    assert_eq!(lexer.tokenize_next(&mut arena), Err(LexerError::NumericOverflow));
    assert_eq!(arena.get(NodeID(0)), Err(FixedArenaError::InvalidIndex));
}

#[test]
fn stage1_lexer_is_utf8_boundary_safe() {
    let source = "ربط_س = ٧";
    let mut arena = FixedArena::<LexicalToken<'_>, 4>::new();
    let mut lexer = DeterministicLexer::new(source);
    let first = lexer.tokenize_next(&mut arena);
    let second = lexer.tokenize_next(&mut arena);
    let third = lexer.tokenize_next(&mut arena);
    assert_eq!(first, Ok(Some(NodeID(0))));
    assert_eq!(second, Ok(Some(NodeID(1))));
    assert_eq!(third, Ok(Some(NodeID(2))));
    assert_eq!(arena.get(NodeID(0)).map(|value| value.kind), Ok(TokenKind::KeywordBind));
    assert_eq!(arena.get(NodeID(2)).map(|value| value.kind), Ok(TokenKind::Symbol));
}

#[test]
fn stage1_lexer_fails_closed_on_capacity() {
    let source = "س = 1";
    let mut arena = FixedArena::<LexicalToken<'_>, 2>::new();
    let mut lexer = DeterministicLexer::new(source);
    assert_eq!(lexer.tokenize_next(&mut arena), Ok(Some(NodeID(0))));
    assert_eq!(lexer.tokenize_next(&mut arena), Ok(Some(NodeID(1))));
    assert_eq!(lexer.tokenize_next(&mut arena), Err(LexerError::Arena(FixedArenaError::CapacityExceeded)));
}
