use std::env;
use std::fs;
use std::process::ExitCode;

use mal_ownership_arena::ast::{AstNode, AstOpcode};
use mal_ownership_arena::lexer::LexicalToken;
use mal_ownership_arena::parser::DeterministicParser;
use mal_ownership_arena::{FixedArena, NodeID};

const TOKEN_CAPACITY: usize = 256;
const AST_CAPACITY: usize = 256;

fn main() -> ExitCode {
    let mut arguments = env::args();
    let _program = arguments.next();
    let path = match arguments.next() {
        Some(value) if arguments.next().is_none() => value,
        _ => {
            println!("STATUS=ABSTAIN");
            println!("ERROR=ARGUMENT_ARITY");
            return ExitCode::from(2);
        }
    };

    if !path.ends_with(".ar") {
        println!("STATUS=ABSTAIN");
        println!("ERROR=SOURCE_EXTENSION");
        return ExitCode::from(2);
    }

    let source = match fs::read_to_string(&path) {
        Ok(value) => value,
        Err(_) => {
            println!("STATUS=ABSTAIN");
            println!("ERROR=SOURCE_READ");
            return ExitCode::from(2);
        }
    };

    let mut token_arena = FixedArena::<LexicalToken<'_>, TOKEN_CAPACITY>::new();
    let mut ast_arena = FixedArena::<AstNode<'_>, AST_CAPACITY>::new();
    let lexer = mal_ownership_arena::lexer::DeterministicLexer::new(&source);
    let mut parser = DeterministicParser::new(lexer);

    let root = match parser.parse_expression(&mut token_arena, &mut ast_arena) {
        Ok(value) => value,
        Err(_) => {
            println!("STATUS=ABSTAIN");
            println!("ERROR=UNSUPPORTED_OR_INVALID_SYNTAX");
            return ExitCode::from(1);
        }
    };

    let node = match ast_arena.get(root) {
        Ok(value) => value,
        Err(_) => {
            println!("STATUS=ABSTAIN");
            println!("ERROR=AST_ROOT_UNAVAILABLE");
            return ExitCode::from(1);
        }
    };

    let opcode = match node.opcode {
        AstOpcode::DeclareNode => "DECLARE_NODE",
        AstOpcode::BindSymbol => "BIND_SYMBOL",
        AstOpcode::LiteralNum => "LITERAL_NUM",
        AstOpcode::Add => "ADD",
        AstOpcode::Subtract => "SUBTRACT",
        AstOpcode::Multiply => "MULTIPLY",
        AstOpcode::Divide => "DIVIDE",
        AstOpcode::PassThrough => "PASS_THROUGH",
    };
    let literal = match node.right {
        Some(NodeID(id)) => id.to_string(),
        None => "NONE".to_owned(),
    };

    println!("STATUS=PARSED");
    println!("ROOT_NODE_ID={}", root.0);
    println!("ROOT_OPCODE={opcode}");
    println!("ROOT_RIGHT_NODE_ID={literal}");
    println!("TOKEN_COUNT={}", token_arena.next_node_id().map_or(0, |id| id.0));
    println!("AST_COUNT={}", ast_arena.next_node_id().map_or(0, |id| id.0));
    ExitCode::SUCCESS
}
