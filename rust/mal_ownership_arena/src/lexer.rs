use crate::{FixedArena, FixedArenaError, NodeID};

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum TokenKind {
    KeywordNode,
    KeywordBind,
    KeywordIf,
    KeywordThen,
    KeywordEnd,
    KeywordWhile,
    KeywordRepeat,
    KeywordFunction,
    Equals,
    EqualEqual,
    NotEqual,
    GreaterThan,
    LessThan,
    Plus,
    Minus,
    Star,
    Slash,
    LParen,
    RParen,
    Symbol,
    Number(u64),
    RestrictedEvaluator,
    Unknown,
    StatementSep,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct LexicalToken<'a> {
    pub kind: TokenKind,
    pub slice: &'a str,
    pub node_id: NodeID,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum LexerError {
    Arena(FixedArenaError),
    NumericOverflow,
}

impl From<FixedArenaError> for LexerError {
    fn from(error: FixedArenaError) -> Self {
        Self::Arena(error)
    }
}

pub struct DeterministicLexer<'a> {
    source: &'a str,
    cursor: usize,
}

impl<'a> DeterministicLexer<'a> {
    pub fn new(source: &'a str) -> Self {
        Self { source, cursor: 0 }
    }

    pub fn tokenize_next<const N: usize>(
        &mut self,
        arena: &mut FixedArena<LexicalToken<'a>, N>,
    ) -> Result<Option<NodeID>, LexerError> {
        let remainder = self
            .source
            .get(self.cursor..)
            .ok_or(LexerError::NumericOverflow)?;
        if remainder.starts_with("\r\n") || remainder.starts_with('\n') {
            let consumed = if remainder.starts_with("\r\n") { 2 } else { 1 };
            let slice = &remainder[..consumed];
            let next_id = arena.next_node_id()?;
            let id = arena.allocate(LexicalToken {
                kind: TokenKind::StatementSep,
                slice,
                node_id: next_id,
            })?;
            self.cursor = self
                .cursor
                .checked_add(consumed)
                .ok_or(LexerError::NumericOverflow)?;
            return Ok(Some(id));
        }

        let trimmed = remainder.trim_start();
        let skipped = remainder.len() - trimmed.len();
        self.cursor = self
            .cursor
            .checked_add(skipped)
            .ok_or(LexerError::NumericOverflow)?;
        if trimmed.is_empty() {
            return Ok(None);
        }

        let current = self
            .source
            .get(self.cursor..)
            .ok_or(LexerError::NumericOverflow)?;
        let (slice, kind, consumed) = if current.starts_with("eval(") || current.starts_with("exec(") {
            let consumed = current
                .find(')')
                .map_or_else(|| current.len(), |index| index + 1);
            (&current[..consumed], TokenKind::RestrictedEvaluator, consumed)
        } else if current.starts_with("unsafe") {
            let consumed = current
                .char_indices()
                .find_map(|(index, character)| character.is_whitespace().then_some(index))
                .unwrap_or(current.len());
            (&current[..consumed], TokenKind::RestrictedEvaluator, consumed)
        } else if current.starts_with("==") {
            (&current[..2], TokenKind::EqualEqual, 2)
        } else if current.starts_with("!=") {
            (&current[..2], TokenKind::NotEqual, 2)
        } else {
            let first = current.chars().next().ok_or(LexerError::NumericOverflow)?;
            let single = match first {
                '=' => Some(TokenKind::Equals),
                '>' => Some(TokenKind::GreaterThan),
                '<' => Some(TokenKind::LessThan),
                '+' => Some(TokenKind::Plus),
                '-' => Some(TokenKind::Minus),
                '*' => Some(TokenKind::Star),
                '/' => Some(TokenKind::Slash),
                '(' => Some(TokenKind::LParen),
                ')' => Some(TokenKind::RParen),
                _ => None,
            };
            if let Some(kind) = single {
                (&current[..first.len_utf8()], kind, first.len_utf8())
            } else {
                let consumed = current
                    .char_indices()
                    .find_map(|(index, character)| {
                        (character.is_whitespace()
                            || matches!(character, '=' | '>' | '<' | '+' | '-' | '*' | '/' | '(' | ')'))
                            .then_some(index)
                    })
                    .unwrap_or(current.len())
                    .max(1);
                let slice = &current[..consumed];
                let kind = if slice.starts_with("بنية_") || slice == "NodeID" {
                    TokenKind::KeywordNode
                } else if slice.starts_with("ربط_") {
                    TokenKind::KeywordBind
                } else if slice == "إذا" {
                    TokenKind::KeywordIf
                } else if slice == "فإن" {
                    TokenKind::KeywordThen
                } else if slice == "نهاية" {
                    TokenKind::KeywordEnd
                } else if slice == "طالما" {
                    TokenKind::KeywordWhile
                } else if slice == "كرر" {
                    TokenKind::KeywordRepeat
                } else if slice == "دالة" {
                    TokenKind::KeywordFunction
                } else if slice.as_bytes().iter().all(u8::is_ascii_digit) {
                    let number = slice
                        .parse::<u64>()
                        .map_err(|_| LexerError::NumericOverflow)?;
                    TokenKind::Number(number)
                } else if slice
                    .chars()
                    .all(|character| character.is_alphanumeric() || character == '_' || character == 'ـ')
                {
                    TokenKind::Symbol
                } else {
                    TokenKind::Unknown
                };
                (slice, kind, consumed)
            }
        };

        let next_id = arena.next_node_id()?;
        let id = arena.allocate(LexicalToken {
            kind,
            slice,
            node_id: next_id,
        })?;
        self.cursor = self
            .cursor
            .checked_add(consumed)
            .ok_or(LexerError::NumericOverflow)?;
        Ok(Some(id))
    }
}
