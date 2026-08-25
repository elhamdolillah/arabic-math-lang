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
    ArithmeticOverflow,
    DivisionByZero,
}

impl From<FixedArenaError> for ParseError {
    fn from(error: FixedArenaError) -> Self { Self::ArenaError(error) }
}

impl From<LexerError> for ParseError {
    fn from(error: LexerError) -> Self { Self::LexerError(error) }
}

pub struct DeterministicParser<'a> {
    lexer: DeterministicLexer<'a>,
    lookahead: Option<LexicalToken<'a>>,
}

impl<'a> DeterministicParser<'a> {
    pub fn new(lexer: DeterministicLexer<'a>) -> Self {
        Self { lexer, lookahead: None }
    }

    pub fn parse_expression<const N_LEX: usize, const N_AST: usize>(
        &mut self,
        token_arena: &mut FixedArena<LexicalToken<'a>, N_LEX>,
        ast_arena: &mut FixedArena<AstNode<'a>, N_AST>,
    ) -> Result<NodeID, ParseError> {
        let declaration = self.take(token_arena)?.ok_or(ParseError::UnexpectedEof)?;
        if declaration.kind == TokenKind::RestrictedEvaluator {
            return Err(ParseError::ConstitutionalViolation);
        }
        if declaration.kind != TokenKind::KeywordNode {
            return Err(ParseError::SyntaxError);
        }
        let equals = self.take(token_arena)?.ok_or(ParseError::UnexpectedEof)?;
        if equals.kind != TokenKind::Equals {
            return Err(ParseError::SyntaxError);
        }

        let expression = self.parse_additive(token_arena, ast_arena)?;
        if self.peek(token_arena)?.is_some() {
            return Err(ParseError::SyntaxError);
        }

        let declaration_id = ast_arena.next_node_id()?;
        ast_arena.allocate(AstNode {
            id: declaration_id,
            opcode: AstOpcode::DeclareNode,
            name: Some(declaration.slice),
            left: None,
            right: Some(expression),
            numeric_value: 0,
        }).map_err(ParseError::from)
    }

    fn parse_additive<const N_LEX: usize, const N_AST: usize>(
        &mut self,
        tokens: &mut FixedArena<LexicalToken<'a>, N_LEX>,
        ast: &mut FixedArena<AstNode<'a>, N_AST>,
    ) -> Result<NodeID, ParseError> {
        let mut left = self.parse_multiplicative(tokens, ast)?;
        loop {
            let kind = self.peek(tokens)?.map_or(None, |token| Some(token.kind));
            let opcode = match kind {
                Some(TokenKind::Plus) => AstOpcode::Add,
                Some(TokenKind::Minus) => AstOpcode::Subtract,
                _ => break,
            };
            self.take(tokens)?;
            let right = self.parse_multiplicative(tokens, ast)?;
            left = self.make_binary(ast, opcode, left, right)?;
        }
        Ok(left)
    }

    fn parse_multiplicative<const N_LEX: usize, const N_AST: usize>(
        &mut self,
        tokens: &mut FixedArena<LexicalToken<'a>, N_LEX>,
        ast: &mut FixedArena<AstNode<'a>, N_AST>,
    ) -> Result<NodeID, ParseError> {
        let mut left = self.parse_factor(tokens, ast)?;
        loop {
            let kind = self.peek(tokens)?.map_or(None, |token| Some(token.kind));
            let opcode = match kind {
                Some(TokenKind::Star) => AstOpcode::Multiply,
                Some(TokenKind::Slash) => AstOpcode::Divide,
                _ => break,
            };
            self.take(tokens)?;
            let right = self.parse_factor(tokens, ast)?;
            left = self.make_binary(ast, opcode, left, right)?;
        }
        Ok(left)
    }

    fn parse_factor<const N_LEX: usize, const N_AST: usize>(
        &mut self,
        tokens: &mut FixedArena<LexicalToken<'a>, N_LEX>,
        ast: &mut FixedArena<AstNode<'a>, N_AST>,
    ) -> Result<NodeID, ParseError> {
        let token = self.take(tokens)?.ok_or(ParseError::UnexpectedEof)?;
        match token.kind {
            TokenKind::Number(value) => {
                let id = ast.next_node_id()?;
                ast.allocate(AstNode { id, opcode: AstOpcode::LiteralNum, name: None, left: None, right: None, numeric_value: value }).map_err(ParseError::from)
            }
            TokenKind::LParen => {
                let value = self.parse_additive(tokens, ast)?;
                let closing = self.take(tokens)?.ok_or(ParseError::UnexpectedEof)?;
                if closing.kind != TokenKind::RParen { return Err(ParseError::SyntaxError); }
                Ok(value)
            }
            TokenKind::Symbol => {
                let id = ast.next_node_id()?;
                ast.allocate(AstNode { id, opcode: AstOpcode::BindSymbol, name: Some(token.slice), left: None, right: None, numeric_value: 0 }).map_err(ParseError::from)
            }
            TokenKind::RestrictedEvaluator => Err(ParseError::ConstitutionalViolation),
            _ => Err(ParseError::SyntaxError),
        }
    }

    fn make_binary<const N: usize>(
        &self,
        ast: &mut FixedArena<AstNode<'a>, N>,
        opcode: AstOpcode,
        left: NodeID,
        right: NodeID,
    ) -> Result<NodeID, ParseError> {
        let left_value = ast.get(left)?.numeric_value;
        let right_value = ast.get(right)?.numeric_value;
        let numeric_value = match opcode {
            AstOpcode::Add => left_value.checked_add(right_value),
            AstOpcode::Subtract => left_value.checked_sub(right_value),
            AstOpcode::Multiply => left_value.checked_mul(right_value),
            AstOpcode::Divide => {
                if right_value == 0 { return Err(ParseError::DivisionByZero); }
                Some(left_value / right_value)
            }
            _ => return Err(ParseError::SyntaxError),
        }.ok_or(ParseError::ArithmeticOverflow)?;
        let id = ast.next_node_id()?;
        ast.allocate(AstNode { id, opcode, name: None, left: Some(left), right: Some(right), numeric_value }).map_err(ParseError::from)
    }

    fn peek<const N: usize>(
        &mut self,
        tokens: &mut FixedArena<LexicalToken<'a>, N>,
    ) -> Result<Option<LexicalToken<'a>>, ParseError> {
        if self.lookahead.is_none() {
            self.lookahead = self.next_token(tokens)?;
        }
        Ok(self.lookahead)
    }

    fn take<const N: usize>(
        &mut self,
        tokens: &mut FixedArena<LexicalToken<'a>, N>,
    ) -> Result<Option<LexicalToken<'a>>, ParseError> {
        if let Some(token) = self.lookahead.take() { return Ok(Some(token)); }
        self.next_token(tokens)
    }

    fn next_token<const N: usize>(
        &mut self,
        tokens: &mut FixedArena<LexicalToken<'a>, N>,
    ) -> Result<Option<LexicalToken<'a>>, ParseError> {
        let id = self.lexer.tokenize_next(tokens)?;
        id.map(|token_id| tokens.get(token_id).copied().map_err(ParseError::from)).transpose()
    }
}
