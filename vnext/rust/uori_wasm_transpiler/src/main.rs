use uori_wasm_transpiler::{AstNode, BinaryOp, CellTypeScope, UoriWasmTranspiler};

fn main() {
    let mut transpiler = UoriWasmTranspiler::new();
    transpiler.register_concept("photo", "uori://kernel/bio/photosynthesis_rate", CellTypeScope::Plant, 1.05)
        .expect("static concept registration");
    let expression = AstNode::BinaryOperation {
        op: BinaryOp::Multiply,
        left: Box::new(AstNode::BinaryOperation {
            op: BinaryOp::Add,
            left: Box::new(AstNode::Number(10.0)),
            right: Box::new(AstNode::ConceptLookup { concept_id: "photo".into(), arg: Box::new(AstNode::Number(50.0)) }),
        }),
        right: Box::new(AstNode::Number(2.0)),
    };
    let wat = transpiler.compile_ast_to_wat(&expression, "uori_math_eval")
        .expect("validated AST must emit WAT");
    println!("{wat}");
}
