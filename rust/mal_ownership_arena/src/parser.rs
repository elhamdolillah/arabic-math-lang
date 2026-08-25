use crate::ast::{AstNode, AstOpcode};
use crate::lexer::{DeterministicLexer, LexicalToken, LexerError, TokenKind};
use crate::{FixedArena, FixedArenaError, NodeID};

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum ParseError {
    ArenaError(FixedArenaError), LexerError(LexerError), ConstitutionalViolation,
    UnexpectedEof, SyntaxError, ArithmeticOverflow, DivisionByZero,
}
impl From<FixedArenaError> for ParseError { fn from(e: FixedArenaError) -> Self { Self::ArenaError(e) } }
impl From<LexerError> for ParseError { fn from(e: LexerError) -> Self { Self::LexerError(e) } }

pub struct DeterministicParser<'a> { lexer: DeterministicLexer<'a>, lookahead: Option<LexicalToken<'a>> }
impl<'a> DeterministicParser<'a> {
    pub fn new(lexer: DeterministicLexer<'a>) -> Self { Self { lexer, lookahead: None } }
    pub fn parse_expression<const L: usize, const A: usize>(&mut self, t: &mut FixedArena<LexicalToken<'a>, L>, a: &mut FixedArena<AstNode<'a>, A>) -> Result<NodeID, ParseError> {
        let root = self.parse_program(t, a)?; if self.peek(t)?.is_some() { return Err(ParseError::SyntaxError); } Ok(root)
    }
    pub fn parse_program<const L: usize, const A: usize>(&mut self, t: &mut FixedArena<LexicalToken<'a>, L>, a: &mut FixedArena<AstNode<'a>, A>) -> Result<NodeID, ParseError> {
        self.skip(t)?; let mut root = self.parse_statement(t,a)?;
        loop { self.skip(t)?; if self.peek(t)?.is_none() { return Ok(root); } let next=self.parse_statement(t,a)?; let id=a.next_node_id()?; let v=a.get(next)?.numeric_value; a.allocate(AstNode{id,opcode:AstOpcode::Sequence,name:None,left:Some(root),right:Some(next),numeric_value:v})?; root=id; }
    }
    fn parse_statement<const L: usize,const A: usize>(&mut self,t:&mut FixedArena<LexicalToken<'a>,L>,a:&mut FixedArena<AstNode<'a>,A>)->Result<NodeID,ParseError>{
        match self.peek(t)?.map(|x|x.kind) { Some(TokenKind::KeywordIf)=>self.parse_if(t,a), Some(TokenKind::KeywordWhile)=>self.parse_while(t,a), Some(TokenKind::KeywordFunction)=>self.parse_function(t,a), _=>self.parse_declaration(t,a) }
    }
    fn parse_if<const L:usize,const A:usize>(&mut self,t:&mut FixedArena<LexicalToken<'a>,L>,a:&mut FixedArena<AstNode<'a>,A>)->Result<NodeID,ParseError>{
        self.expect(t,TokenKind::KeywordIf)?; let c=self.parse_comparison(t,a)?; self.expect(t,TokenKind::KeywordThen)?; self.skip(t)?; let b=self.parse_statement(t,a)?; self.skip(t)?; self.expect(t,TokenKind::KeywordEnd)?; self.alloc(a,AstOpcode::IfStatement,None,Some(c),Some(b),0)
    }
    fn parse_while<const L:usize,const A:usize>(&mut self,t:&mut FixedArena<LexicalToken<'a>,L>,a:&mut FixedArena<AstNode<'a>,A>)->Result<NodeID,ParseError>{
        self.expect(t,TokenKind::KeywordWhile)?; let c=self.parse_comparison(t,a)?; self.expect(t,TokenKind::KeywordRepeat)?; self.skip(t)?; let b=self.parse_statement(t,a)?; self.skip(t)?; self.expect(t,TokenKind::KeywordEnd)?; self.alloc(a,AstOpcode::WhileLoop,None,Some(c),Some(b),0)
    }
    fn parse_function<const L:usize,const A:usize>(&mut self,t:&mut FixedArena<LexicalToken<'a>,L>,a:&mut FixedArena<AstNode<'a>,A>)->Result<NodeID,ParseError>{
        self.expect(t,TokenKind::KeywordFunction)?; let name=self.take(t)?.ok_or(ParseError::UnexpectedEof)?; if !matches!(name.kind,TokenKind::Symbol|TokenKind::KeywordNode){return Err(ParseError::SyntaxError)}
        self.expect(t,TokenKind::LParen)?; let param=self.take(t)?.ok_or(ParseError::UnexpectedEof)?; if !matches!(param.kind,TokenKind::Symbol|TokenKind::KeywordNode){return Err(ParseError::SyntaxError)} self.expect(t,TokenKind::RParen)?; self.expect(t,TokenKind::KeywordThen)?; self.skip(t)?;
        let p=self.alloc(a,AstOpcode::BindSymbol,Some(param.slice),None,None,0)?; let body=self.parse_statement(t,a)?; self.skip(t)?; self.expect(t,TokenKind::KeywordEnd)?; self.alloc(a,AstOpcode::FunctionDecl,Some(name.slice),Some(p),Some(body),0)
    }
    fn parse_declaration<const L:usize,const A:usize>(&mut self,t:&mut FixedArena<LexicalToken<'a>,L>,a:&mut FixedArena<AstNode<'a>,A>)->Result<NodeID,ParseError>{
        let d=self.take(t)?.ok_or(ParseError::UnexpectedEof)?; if d.kind==TokenKind::RestrictedEvaluator{return Err(ParseError::ConstitutionalViolation)} if d.kind!=TokenKind::KeywordNode{return Err(ParseError::SyntaxError)} self.expect(t,TokenKind::Equals)?; let e=self.parse_comparison(t,a)?; let v=if Self::is_static(a,e)?{a.get(e)?.numeric_value}else{0}; self.alloc(a,AstOpcode::DeclareNode,Some(d.slice),None,Some(e),v)
    }
    fn parse_comparison<const L:usize,const A:usize>(&mut self,t:&mut FixedArena<LexicalToken<'a>,L>,a:&mut FixedArena<AstNode<'a>,A>)->Result<NodeID,ParseError>{let mut x=self.parse_additive(t,a)?; loop{let op=match self.peek(t)?.map(|x|x.kind){Some(TokenKind::EqualEqual)=>AstOpcode::Equal,Some(TokenKind::NotEqual)=>AstOpcode::NotEqual,Some(TokenKind::GreaterThan)=>AstOpcode::GreaterThan,Some(TokenKind::LessThan)=>AstOpcode::LessThan,_=>break};self.take(t)?;let y=self.parse_additive(t,a)?;x=self.alloc(a,op,None,Some(x),Some(y),0)?;}Ok(x)}
    fn parse_additive<const L:usize,const A:usize>(&mut self,t:&mut FixedArena<LexicalToken<'a>,L>,a:&mut FixedArena<AstNode<'a>,A>)->Result<NodeID,ParseError>{let mut x=self.parse_multiplicative(t,a)?;loop{let op=match self.peek(t)?.map(|x|x.kind){Some(TokenKind::Plus)=>AstOpcode::Add,Some(TokenKind::Minus)=>AstOpcode::Subtract,_=>break};self.take(t)?;let y=self.parse_multiplicative(t,a)?;x=self.binary(a,op,x,y)?;}Ok(x)}
    fn parse_multiplicative<const L:usize,const A:usize>(&mut self,t:&mut FixedArena<LexicalToken<'a>,L>,a:&mut FixedArena<AstNode<'a>,A>)->Result<NodeID,ParseError>{let mut x=self.parse_factor(t,a)?;loop{let op=match self.peek(t)?.map(|x|x.kind){Some(TokenKind::Star)=>AstOpcode::Multiply,Some(TokenKind::Slash)=>AstOpcode::Divide,_=>break};self.take(t)?;let y=self.parse_factor(t,a)?;x=self.binary(a,op,x,y)?;}Ok(x)}
    fn parse_factor<const L:usize,const A:usize>(&mut self,t:&mut FixedArena<LexicalToken<'a>,L>,a:&mut FixedArena<AstNode<'a>,A>)->Result<NodeID,ParseError>{let x=self.take(t)?.ok_or(ParseError::UnexpectedEof)?;match x.kind{TokenKind::Number(v)=>self.alloc(a,AstOpcode::LiteralNum,None,None,None,v),TokenKind::LParen=>{let y=self.parse_comparison(t,a)?;self.expect(t,TokenKind::RParen)?;Ok(y)},TokenKind::RestrictedEvaluator=>Err(ParseError::ConstitutionalViolation),TokenKind::Symbol|TokenKind::KeywordNode=>{if self.peek(t)?.is_some_and(|z|z.kind==TokenKind::LParen){self.take(t)?;let arg=self.parse_comparison(t,a)?;self.expect(t,TokenKind::RParen)?;self.alloc(a,AstOpcode::FunctionCall,Some(x.slice),Some(arg),None,0)}else{self.alloc(a,AstOpcode::BindSymbol,Some(x.slice),None,None,0)}},_=>Err(ParseError::SyntaxError)}}
    fn binary<const A:usize>(&self,a:&mut FixedArena<AstNode<'a>,A>,op:AstOpcode,l:NodeID,r:NodeID)->Result<NodeID,ParseError>{let v=if Self::is_static(a,l)?&&Self::is_static(a,r)?{let x=a.get(l)?.numeric_value;let y=a.get(r)?.numeric_value;match op{AstOpcode::Add=>x.checked_add(y),AstOpcode::Subtract=>x.checked_sub(y),AstOpcode::Multiply=>x.checked_mul(y),AstOpcode::Divide=>if y==0{return Err(ParseError::DivisionByZero)}else{Some(x/y)},_=>None}.ok_or(ParseError::ArithmeticOverflow)?}else{0};self.alloc(a,op,None,Some(l),Some(r),v)}
    fn alloc<const A:usize>(&self,a:&mut FixedArena<AstNode<'a>,A>,op:AstOpcode,n:Option<&'a str>,l:Option<NodeID>,r:Option<NodeID>,v:u64)->Result<NodeID,ParseError>{let id=a.next_node_id()?;a.allocate(AstNode{id,opcode:op,name:n,left:l,right:r,numeric_value:v})?;Ok(id)}
    fn is_static<const A:usize>(a:&FixedArena<AstNode<'a>,A>,id:NodeID)->Result<bool,ParseError>{let n=a.get(id)?;match n.opcode{AstOpcode::LiteralNum=>Ok(true),AstOpcode::BindSymbol=>Ok(false),AstOpcode::Add|AstOpcode::Subtract|AstOpcode::Multiply|AstOpcode::Divide|AstOpcode::Equal|AstOpcode::NotEqual|AstOpcode::GreaterThan|AstOpcode::LessThan=>Ok(Self::is_static(a,n.left.ok_or(ParseError::SyntaxError)?)?&&Self::is_static(a,n.right.ok_or(ParseError::SyntaxError)?)?),_=>Ok(false)}}
    fn skip<const L:usize>(&mut self,t:&mut FixedArena<LexicalToken<'a>,L>)->Result<(),ParseError>{while self.peek(t)?.is_some_and(|x|x.kind==TokenKind::StatementSep){self.take(t)?;}Ok(())}
    fn expect<const L:usize>(&mut self,t:&mut FixedArena<LexicalToken<'a>,L>,k:TokenKind)->Result<(),ParseError>{match self.take(t)?{Some(x) if x.kind==k=>Ok(()),Some(_)=>Err(ParseError::SyntaxError),None=>Err(ParseError::UnexpectedEof)}}
    fn peek<const L:usize>(&mut self,t:&mut FixedArena<LexicalToken<'a>,L>)->Result<Option<LexicalToken<'a>>,ParseError>{if self.lookahead.is_none(){self.lookahead=self.next(t)?;}Ok(self.lookahead)}
    fn take<const L:usize>(&mut self,t:&mut FixedArena<LexicalToken<'a>,L>)->Result<Option<LexicalToken<'a>>,ParseError>{if self.lookahead.is_some(){Ok(self.lookahead.take())}else{self.next(t)}}
    fn next<const L:usize>(&mut self,t:&mut FixedArena<LexicalToken<'a>,L>)->Result<Option<LexicalToken<'a>>,ParseError>{let id=self.lexer.tokenize_next(t)?;id.map(|x|t.get(x).copied().map_err(ParseError::from)).transpose()}
}
