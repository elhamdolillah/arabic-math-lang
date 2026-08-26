use crate::NodeID;

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum AstOpcode {
    BindSymbol,
    DeclareNode,
    LiteralNum,
    Add,
    Subtract,
    Multiply,
    Divide,
    PassThrough,
    Sequence,
    IfStatement,
    Equal,
    NotEqual,
    GreaterThan,
    LessThan,
    WhileLoop,
    FunctionDecl,
    FunctionCall,
    LiteralString,
    QuranCount,
    QuranCapacity,
    QuranWeight,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct AstNode<'a> {
    pub id: NodeID,
    pub opcode: AstOpcode,
    pub name: Option<&'a str>,
    pub left: Option<NodeID>,
    pub right: Option<NodeID>,
    pub numeric_value: u64,
}
