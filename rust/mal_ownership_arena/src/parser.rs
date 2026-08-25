use crate::ast::{AstNode, AstOpcode};
use crate::lexer::{DeterministicLexer, LexicalToken, LexerError, TokenKind};
use crate::{FixedArena, FixedArenaError, NodeID};

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum ParseError {
    ArenaError(FixedArenaError),
    LexerError(LexerError),
    ConstitutionalViolation,
    UnexpectedEof,
    SyntaxError,
}

impl From<FixedArenaError> for ParseError {
    fn from(error: FixedArenaError) -> Self {
        Self::ArenaError(error)
    }
}

impl From<LexerError> for ParseError {
    fn from(error: LexerError) -> Self {
        Self::LexerError(error)
    }
}

pub struct DeterministicParser<'a> {
    lexer: DeterministicLexer<'a>,
}

impl<'a> DeterministicParser<'a> {
    pub fn new(lexer: DeterministicLexer<'a>) -> Self {
        Self { lexer }
    }

    pub fn parse_expression<const N_LEX: usize, const N_AST: usize>(
        &mut self,
        token_arena: &mut FixedArena<LexicalToken<'a>, N_LEX>,
        ast_arena: &mut FixedArena<AstNode<'a>, N_AST>,
    ) -> Result<NodeID, ParseError> {
        let declaration = self.next_token(token_arena)?.ok_or(ParseError::UnexpectedEof)?;
        if declaration.kind == TokenKind::RestrictedEvaluator {
            return Err(ParseError::ConstitutionalViolation);
        }
        if declaration.kind != TokenKind::KeywordNode {
            return Err(ParseError::SyntaxError);
        }

        let equals = self.next_token(token_arena)?.ok_or(ParseError::UnexpectedEof)?;
        if equals.kind != TokenKind::Equals {
            return Err(ParseError::SyntaxError);
        }

        let literal = self.next_token(token_arena)?.ok_or(ParseError::UnexpectedEof)?;
        let number = match literal.kind {
            TokenKind::Number(value) => value,
            TokenKind::RestrictedEvaluator => return Err(ParseError::ConstitutionalViolation),
            _ => return Err(ParseError::SyntaxError),
        };

        if self.next_token(token_arena)?.is_some() {
            return Err(ParseError::SyntaxError);
        }

        let literal_id = ast_arena.next_node_id()?;
        let literal_id = ast_arena.allocate(AstNode {
            id: literal_id,
            opcode: AstOpcode::LiteralNum,
            name: None,
            left: None,
            right: None,
            numeric_value: number,
        })?;

        let declaration_id = ast_arena.next_node_id()?;
        let declaration_id = ast_arena.allocate(AstNode {
            id: declaration_id,
            opcode: AstOpcode::DeclareNode,
            name: Some(declaration.slice),
            left: None,
            right: Some(literal_id),
            numeric_value: 0,
        })?;

        Ok(declaration_id)
    }

    fn next_token<const N_LEX: usize>(
        &mut self,
        token_arena: &mut FixedArena<LexicalToken<'a>, N_LEX>,
    ) -> Result<Option<LexicalToken<'a>>, ParseError> {
        let id = self.lexer.tokenize_next(token_arena)?;
        id.map(|token_id| token_arena.get(token_id).copied().map_err(ParseError::from))
            .transpose()
    }
}
