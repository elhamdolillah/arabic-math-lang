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
        let root = self.parse_program(token_arena, ast_arena)?;
        if self.peek(token_arena)?.is_some() { return Err(ParseError::SyntaxError); }
        Ok(root)
    }

    pub fn parse_program<const N_LEX: usize, const N_AST: usize>(
        &mut self,
        token_arena: &mut FixedArena<LexicalToken<'a>, N_LEX>,
        ast_arena: &mut FixedArena<AstNode<'a>, N_AST>,
    ) -> Result<NodeID, ParseError> {
        self.skip_separators(token_arena)?;
        let mut root = self.parse_statement(token_arena, ast_arena)?;
        loop {
            self.skip_separators(token_arena)?;
            if self.peek(token_arena)?.is_none() { break; }
            let next = self.parse_statement(token_arena, ast_arena)?;
            let sequence_id = ast_arena.next_node_id()?;
            ast_arena.allocate(AstNode {
                id: sequence_id,
                opcode: AstOpcode::Sequence,
                name: None,
                left: Some(root),
                right: Some(next),
                numeric_value: ast_arena.get(next)?.numeric_value,
            })?;
            root = sequence_id;
        }
        Ok(root)
    }

    fn parse_statement<const N_LEX: usize, const N_AST: usize>(
        &mut self,
        tokens: &mut FixedArena<LexicalToken<'a>, N_LEX>,
        ast: &mut FixedArena<AstNode<'a>, N_AST>,
    ) -> Result<NodeID, ParseError> {
        if self.peek(tokens)?.is_some_and(|token| token.kind == TokenKind::KeywordIf) {
            self.parse_if(tokens, ast)
        } else {
            self.parse_declaration(tokens, ast)
        }
    }

    fn parse_if<const N_LEX: usize, const N_AST: usize>(
        &mut self,
        tokens: &mut FixedArena<LexicalToken<'a>, N_LEX>,
        ast: &mut FixedArena<AstNode<'a>, N_AST>,
    ) -> Result<NodeID, ParseError> {
        let opening = self.take(tokens)?.ok_or(ParseError::UnexpectedEof)?;
        if opening.kind != TokenKind::KeywordIf { return Err(ParseError::SyntaxError); }
        let condition = self.parse_comparison(tokens, ast)?;
        let then_token = self.take(tokens)?.ok_or(ParseError::UnexpectedEof)?;
        if then_token.kind != TokenKind::KeywordThen { return Err(ParseError::SyntaxError); }
        self.skip_separators(tokens)?;
        let body = self.parse_statement(tokens, ast)?;
        self.skip_separators(tokens)?;
        let ending = self.take(tokens)?.ok_or(ParseError::UnexpectedEof)?;
        if ending.kind != TokenKind::KeywordEnd { return Err(ParseError::SyntaxError); }
        let id = ast.next_node_id()?;
        ast.allocate(AstNode { id, opcode: AstOpcode::IfStatement, name: None, left: Some(condition), right: Some(body), numeric_value: 0 }).map_err(ParseError::from)
    }

    fn parse_declaration<const N_LEX: usize, const N_AST: usize>(
        &mut self,
        tokens: &mut FixedArena<LexicalToken<'a>, N_LEX>,
        ast: &mut FixedArena<AstNode<'a>, N_AST>,
    ) -> Result<NodeID, ParseError> {
        let declaration = self.take(tokens)?.ok_or(ParseError::UnexpectedEof)?;
        if declaration.kind == TokenKind::RestrictedEvaluator {
            return Err(ParseError::ConstitutionalViolation);
        }
        if declaration.kind != TokenKind::KeywordNode { return Err(ParseError::SyntaxError); }
        let equals = self.take(tokens)?.ok_or(ParseError::UnexpectedEof)?;
        if equals.kind != TokenKind::Equals { return Err(ParseError::SyntaxError); }
        let expression = self.parse_comparison(tokens, ast)?;
        let declaration_id = ast.next_node_id()?;
        ast.allocate(AstNode {
            id: declaration_id,
            opcode: AstOpcode::DeclareNode,
            name: Some(declaration.slice),
            left: None,
            right: Some(expression),
            numeric_value: if Self::is_static(ast, expression)? { ast.get(expression)?.numeric_value } else { 0 },
        }).map_err(ParseError::from)
    }

    fn skip_separators<const N: usize>(&mut self, tokens: &mut FixedArena<LexicalToken<'a>, N>) -> Result<(), ParseError> {
        while self.peek(tokens)?.is_some_and(|token| token.kind == TokenKind::StatementSep) {
            self.take(tokens)?;
        }
        Ok(())
    }

    fn parse_comparison<const N_LEX: usize, const N_AST: usize>(
        &mut self, tokens: &mut FixedArena<LexicalToken<'a>, N_LEX>, ast: &mut FixedArena<AstNode<'a>, N_AST>,
    ) -> Result<NodeID, ParseError> {
        let mut left = self.parse_additive(tokens, ast)?;
        loop {
            let opcode = match self.peek(tokens)?.map(|token| token.kind) {
                Some(TokenKind::EqualEqual) => AstOpcode::Equal,
                Some(TokenKind::NotEqual) => AstOpcode::NotEqual,
                Some(TokenKind::GreaterThan) => AstOpcode::GreaterThan,
                Some(TokenKind::LessThan) => AstOpcode::LessThan,
                _ => break,
            };
            self.take(tokens)?;
            let right = self.parse_additive(tokens, ast)?;
            left = self.make_comparison(ast, opcode, left, right)?;
        }
        Ok(left)
    }

    fn parse_additive<const N_LEX: usize, const N_AST: usize>(
        &mut self, tokens: &mut FixedArena<LexicalToken<'a>, N_LEX>, ast: &mut FixedArena<AstNode<'a>, N_AST>,
    ) -> Result<NodeID, ParseError> {
        let mut left = self.parse_multiplicative(tokens, ast)?;
        loop {
            let opcode = match self.peek(tokens)?.map(|token| token.kind) {
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
        &mut self, tokens: &mut FixedArena<LexicalToken<'a>, N_LEX>, ast: &mut FixedArena<AstNode<'a>, N_AST>,
    ) -> Result<NodeID, ParseError> {
        let mut left = self.parse_factor(tokens, ast)?;
        loop {
            let opcode = match self.peek(tokens)?.map(|token| token.kind) {
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
        &mut self, tokens: &mut FixedArena<LexicalToken<'a>, N_LEX>, ast: &mut FixedArena<AstNode<'a>, N_AST>,
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
            TokenKind::Symbol | TokenKind::KeywordNode => {
                let id = ast.next_node_id()?;
                ast.allocate(AstNode { id, opcode: AstOpcode::BindSymbol, name: Some(token.slice), left: None, right: None, numeric_value: 0 }).map_err(ParseError::from)
            }
            TokenKind::RestrictedEvaluator => Err(ParseError::ConstitutionalViolation),
            _ => Err(ParseError::SyntaxError),
        }
    }

    fn make_comparison<const N: usize>(&self, ast: &mut FixedArena<AstNode<'a>, N>, opcode: AstOpcode, left: NodeID, right: NodeID) -> Result<NodeID, ParseError> {
        let id = ast.next_node_id()?;
        ast.allocate(AstNode { id, opcode, name: None, left: Some(left), right: Some(right), numeric_value: 0 }).map_err(ParseError::from)
    }

    fn make_binary<const N: usize>(&self, ast: &mut FixedArena<AstNode<'a>, N>, opcode: AstOpcode, left: NodeID, right: NodeID) -> Result<NodeID, ParseError> {
        let left_static = Self::is_static(ast, left)?;
        let right_static = Self::is_static(ast, right)?;
        if !left_static || !right_static {
            let id = ast.next_node_id()?;
            return ast.allocate(AstNode { id, opcode, name: None, left: Some(left), right: Some(right), numeric_value: 0 }).map_err(ParseError::from);
        }
        let left_value = ast.get(left)?.numeric_value;
        let right_value = ast.get(right)?.numeric_value;
        let numeric_value = match opcode {
            AstOpcode::Add => left_value.checked_add(right_value),
            AstOpcode::Subtract => left_value.checked_sub(right_value),
            AstOpcode::Multiply => left_value.checked_mul(right_value),
            AstOpcode::Divide => { if right_value == 0 { return Err(ParseError::DivisionByZero); } Some(left_value / right_value) }
            _ => return Err(ParseError::SyntaxError),
        }.ok_or(ParseError::ArithmeticOverflow)?;
        let id = ast.next_node_id()?;
        ast.allocate(AstNode { id, opcode, name: None, left: Some(left), right: Some(right), numeric_value }).map_err(ParseError::from)
    }

    fn is_static<const N: usize>(ast: &FixedArena<AstNode<'a>, N>, id: NodeID) -> Result<bool, ParseError> {
        let node = ast.get(id)?;
        match node.opcode {
            AstOpcode::LiteralNum => Ok(true),
            AstOpcode::BindSymbol => Ok(false),
            AstOpcode::Add | AstOpcode::Subtract | AstOpcode::Multiply | AstOpcode::Divide | AstOpcode::Equal | AstOpcode::NotEqual | AstOpcode::GreaterThan | AstOpcode::LessThan => {
                Ok(Self::is_static(ast, node.left.ok_or(ParseError::SyntaxError)?)?
                    && Self::is_static(ast, node.right.ok_or(ParseError::SyntaxError)?)?)
            }
            _ => Ok(false),
        }
    }

    fn peek<const N: usize>(&mut self, tokens: &mut FixedArena<LexicalToken<'a>, N>) -> Result<Option<LexicalToken<'a>>, ParseError> {
        if self.lookahead.is_none() { self.lookahead = self.next_token(tokens)?; }
        Ok(self.lookahead)
    }

    fn take<const N: usize>(&mut self, tokens: &mut FixedArena<LexicalToken<'a>, N>) -> Result<Option<LexicalToken<'a>>, ParseError> {
        if let Some(token) = self.lookahead.take() { return Ok(Some(token)); }
        self.next_token(tokens)
    }

    fn next_token<const N: usize>(&mut self, tokens: &mut FixedArena<LexicalToken<'a>, N>) -> Result<Option<LexicalToken<'a>>, ParseError> {
        let id = self.lexer.tokenize_next(tokens)?;
        id.map(|token_id| tokens.get(token_id).copied().map_err(ParseError::from)).transpose()
    }
}
