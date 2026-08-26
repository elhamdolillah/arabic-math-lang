use crate::ast::{AstNode, AstOpcode};
use crate::symbols::{ArenaSymbolTable, SymbolError};
use crate::{FixedArena, FixedArenaError, NodeID};

pub const MAX_LOOP_FUEL: usize = 2000;
pub const MAX_STRING_BYTES: usize = 64;
pub const MAX_STAGE7_AGGREGATE_INPUT: u64 = 1999;
pub const MAX_STAGE7_BOUND: u64 = 64;

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum EvaluatorError { ArenaError(FixedArenaError), SymbolError(SymbolError), ArithmeticOverflow, DivisionByZero, InvalidNode, FuelExhausted, FunctionNotFound, RecursiveCall }
impl From<FixedArenaError> for EvaluatorError { fn from(e: FixedArenaError)->Self{Self::ArenaError(e)} }
impl From<SymbolError> for EvaluatorError { fn from(e: SymbolError)->Self{Self::SymbolError(e)} }

pub struct DeterministicEvaluator;
impl DeterministicEvaluator {
 pub fn evaluate<'a,const A:usize,const S:usize>(ast:&FixedArena<AstNode<'a>,A>,root:NodeID,symbols:&mut ArenaSymbolTable<'a,S>)->Result<u64,EvaluatorError>{let mut fuel=MAX_LOOP_FUEL;Self::visit(ast,root,symbols,&mut fuel,None)}
 fn visit<'a,const A:usize,const S:usize>(ast:&FixedArena<AstNode<'a>,A>,id:NodeID,s:&mut ArenaSymbolTable<'a,S>,fuel:&mut usize,active:Option<&'a str>)->Result<u64,EvaluatorError>{
  let n=*ast.get(id)?; match n.opcode{
   AstOpcode::LiteralNum=>Ok(n.numeric_value),
   AstOpcode::LiteralString=>Ok(n.numeric_value),
   AstOpcode::QuranCount|AstOpcode::QuranWeight|AstOpcode::QuranAmount=>Self::visit(ast,n.left.ok_or(EvaluatorError::InvalidNode)?,s,fuel,active),
   AstOpcode::QuranBound=>{let v=Self::visit(ast,n.left.ok_or(EvaluatorError::InvalidNode)?,s,fuel,active)?;if v<=MAX_STAGE7_BOUND{Ok(v)}else{Err(EvaluatorError::InvalidNode)}},
   AstOpcode::QuranAggregate=>{let limit=Self::visit(ast,n.left.ok_or(EvaluatorError::InvalidNode)?,s,fuel,active)?;if limit>MAX_STAGE7_AGGREGATE_INPUT{return Err(EvaluatorError::InvalidNode)}let mut i=0_u64;let mut total=0_u64;while i<=limit{if *fuel==0{return Err(EvaluatorError::FuelExhausted)}*fuel-=1;total=total.checked_add(i).ok_or(EvaluatorError::ArithmeticOverflow)?;i+=1;}Ok(total)},
   AstOpcode::QuranCapacity=>{let v=Self::visit(ast,n.left.ok_or(EvaluatorError::InvalidNode)?,s,fuel,active)?;if v as usize>MAX_STRING_BYTES{Err(EvaluatorError::InvalidNode)}else{Ok(v)}},
   AstOpcode::BindSymbol=>s.lookup(n.name.ok_or(EvaluatorError::InvalidNode)?).map(|e|e.value).map_err(Into::into),
   AstOpcode::DeclareNode=>{let v=Self::visit(ast,n.right.ok_or(EvaluatorError::InvalidNode)?,s,fuel,active)?;s.bind(n.name.ok_or(EvaluatorError::InvalidNode)?,v,id)?;Ok(v)},
   AstOpcode::Sequence=>{Self::visit(ast,n.left.ok_or(EvaluatorError::InvalidNode)?,s,fuel,active)?;Self::visit(ast,n.right.ok_or(EvaluatorError::InvalidNode)?,s,fuel,active)},
   AstOpcode::IfStatement=>{let c=Self::visit(ast,n.left.ok_or(EvaluatorError::InvalidNode)?,s,fuel,active)?;if c>0{Self::visit(ast,n.right.ok_or(EvaluatorError::InvalidNode)?,s,fuel,active)}else{Ok(0)}},
   AstOpcode::WhileLoop=>{let mut last=0;loop{let c=Self::visit(ast,n.left.ok_or(EvaluatorError::InvalidNode)?,s,fuel,active)?;if c==0{return Ok(last)}if *fuel==0{return Err(EvaluatorError::FuelExhausted)}*fuel-=1;last=Self::visit(ast,n.right.ok_or(EvaluatorError::InvalidNode)?,s,fuel,active)?;}},
   AstOpcode::FunctionDecl=>Ok(0),
   AstOpcode::FunctionCall=>{let name=n.name.ok_or(EvaluatorError::InvalidNode)?;if active==Some(name){return Err(EvaluatorError::RecursiveCall)}let (param,body)=Self::find_function(ast,NodeID(0),name)?.ok_or(EvaluatorError::FunctionNotFound)?;let arg=Self::visit(ast,n.left.ok_or(EvaluatorError::InvalidNode)?,s,fuel,active)?;s.enter_scope()?;let result=s.bind(param,arg,id).and_then(|_|Self::visit(ast,body,s,fuel,Some(name)).map_err(|_|SymbolError::CapacityExceeded));let exit=s.exit_scope();match(result,exit){(Ok(v),Ok(_))=>Ok(v),(Err(e),_)=>Err(EvaluatorError::from(e)),(_,Err(e))=>Err(EvaluatorError::from(e))}},
   AstOpcode::Equal=>Self::cmp(ast,n,s,fuel,active,|a,b|a==b),AstOpcode::NotEqual=>Self::cmp(ast,n,s,fuel,active,|a,b|a!=b),AstOpcode::GreaterThan=>Self::cmp(ast,n,s,fuel,active,|a,b|a>b),AstOpcode::LessThan=>Self::cmp(ast,n,s,fuel,active,|a,b|a<b),
   AstOpcode::Add=>Self::bin(ast,n,s,fuel,active,|a,b|a.checked_add(b)),AstOpcode::Subtract=>Self::bin(ast,n,s,fuel,active,|a,b|a.checked_sub(b)),AstOpcode::Multiply=>Self::bin(ast,n,s,fuel,active,|a,b|a.checked_mul(b)),AstOpcode::Divide=>{let a=Self::visit(ast,n.left.ok_or(EvaluatorError::InvalidNode)?,s,fuel,active)?;let b=Self::visit(ast,n.right.ok_or(EvaluatorError::InvalidNode)?,s,fuel,active)?;if b==0{Err(EvaluatorError::DivisionByZero)}else{Ok(a/b)}},AstOpcode::PassThrough=>Self::visit(ast,n.right.ok_or(EvaluatorError::InvalidNode)?,s,fuel,active)
  }
 }
 fn find_function<'a,const A:usize>(ast:&FixedArena<AstNode<'a>,A>,id:NodeID,name:&str)->Result<Option<(&'a str,NodeID)>,EvaluatorError>{let n=*ast.get(id)?;if n.opcode==AstOpcode::FunctionDecl&&n.name==Some(name){return Ok(Some((ast.get(n.left.ok_or(EvaluatorError::InvalidNode)?)?.name.ok_or(EvaluatorError::InvalidNode)?,n.right.ok_or(EvaluatorError::InvalidNode)?)))}for child in [n.left,n.right].into_iter().flatten(){if let Some(found)=Self::find_function(ast,child,name)?{return Ok(Some(found))}}Ok(None)}
 fn cmp<'a,const A:usize,const S:usize,F:FnOnce(u64,u64)->bool>(ast:&FixedArena<AstNode<'a>,A>,n:AstNode<'a>,s:&mut ArenaSymbolTable<'a,S>,f:&mut usize,a:Option<&'a str>,op:F)->Result<u64,EvaluatorError>{let l=Self::visit(ast,n.left.ok_or(EvaluatorError::InvalidNode)?,s,f,a)?;let r=Self::visit(ast,n.right.ok_or(EvaluatorError::InvalidNode)?,s,f,a)?;Ok(op(l,r) as u64)}
 fn bin<'a,const A:usize,const S:usize,F:FnOnce(u64,u64)->Option<u64>>(ast:&FixedArena<AstNode<'a>,A>,n:AstNode<'a>,s:&mut ArenaSymbolTable<'a,S>,f:&mut usize,a:Option<&'a str>,op:F)->Result<u64,EvaluatorError>{let l=Self::visit(ast,n.left.ok_or(EvaluatorError::InvalidNode)?,s,f,a)?;let r=Self::visit(ast,n.right.ok_or(EvaluatorError::InvalidNode)?,s,f,a)?;op(l,r).ok_or(EvaluatorError::ArithmeticOverflow)}
}
