use std::collections::BTreeMap;

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum CellTypeScope { Plant, Animal, Universal }

#[derive(Debug, Clone, PartialEq)]
pub struct ConceptEntry {
    pub concept_id: String,
    pub source_ref: String,
    pub scope: CellTypeScope,
    pub numeric_factor: f64,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum BinaryOp { Add, Subtract, Multiply, Divide }

#[derive(Debug, Clone, PartialEq)]
pub enum AstNode {
    Number(f64),
    Variable(String),
    ConceptLookup { concept_id: String, arg: Box<AstNode> },
    BinaryOperation { op: BinaryOp, left: Box<AstNode>, right: Box<AstNode> },
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub enum EmitError {
    InvalidFunctionName,
    NonFiniteNumber,
    UnboundVariable,
    UnknownConcept,
    InvalidConceptFactor,
    DivisionByZero,
}

pub struct UoriWasmTranspiler { registry: BTreeMap<String, ConceptEntry> }

impl UoriWasmTranspiler {
    pub fn new() -> Self { Self { registry: BTreeMap::new() } }

    pub fn register_concept(&mut self, concept_id: &str, source_ref: &str, scope: CellTypeScope, numeric_factor: f64) -> Result<(), EmitError> {
        if concept_id.is_empty() || !concept_id.chars().all(|c| c.is_alphanumeric() || c == '_' || c == '-') || !numeric_factor.is_finite() {
            return Err(EmitError::InvalidConceptFactor);
        }
        self.registry.insert(concept_id.to_owned(), ConceptEntry {
            concept_id: concept_id.to_owned(), source_ref: source_ref.to_owned(), scope, numeric_factor,
        });
        Ok(())
    }

    pub fn compile_ast_to_wat(&self, root: &AstNode, function_name: &str) -> Result<String, EmitError> {
        if function_name.is_empty() || !function_name.chars().all(|c| c.is_ascii_alphanumeric() || c == '_') {
            return Err(EmitError::InvalidFunctionName);
        }
        let mut wat = format!("(module\n  (func ${function_name} (result f64)\n");
        self.emit_node(root, &mut wat)?;
        wat.push_str("    return\n  )\n  (export \"execute\" (func $");
        wat.push_str(function_name);
        wat.push_str("))\n)");
        Ok(wat)
    }

    fn emit_node(&self, node: &AstNode, wat: &mut String) -> Result<(), EmitError> {
        match node {
            AstNode::Number(value) => {
                if !value.is_finite() { return Err(EmitError::NonFiniteNumber); }
                wat.push_str(&format!("    f64.const {value:.17}\n"));
            }
            AstNode::Variable(_) => return Err(EmitError::UnboundVariable),
            AstNode::ConceptLookup { concept_id, arg } => {
                let entry = self.registry.get(concept_id).ok_or(EmitError::UnknownConcept)?;
                self.emit_node(arg, wat)?;
                if !entry.numeric_factor.is_finite() { return Err(EmitError::InvalidConceptFactor); }
                // source_ref remains metadata in the registry and is never emitted or executed.
                wat.push_str(&format!("    f64.const {:.17}\n    f64.mul\n", entry.numeric_factor));
            }
            AstNode::BinaryOperation { op, left, right } => {
                self.emit_node(left, wat)?;
                self.emit_node(right, wat)?;
                if matches!(op, BinaryOp::Divide) && matches!(right.as_ref(), AstNode::Number(v) if *v == 0.0) {
                    return Err(EmitError::DivisionByZero);
                }
                wat.push_str(match op {
                    BinaryOp::Add => "    f64.add\n",
                    BinaryOp::Subtract => "    f64.sub\n",
                    BinaryOp::Multiply => "    f64.mul\n",
                    BinaryOp::Divide => "    f64.div\n",
                });
            }
        }
        Ok(())
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    fn n(v: f64) -> AstNode { AstNode::Number(v) }

    #[test]
    fn emits_arithmetic_without_external_imports() {
        let mut t = UoriWasmTranspiler::new();
        t.register_concept("photo", "uori://secret/ref", CellTypeScope::Plant, 1.05).unwrap();
        let ast = AstNode::BinaryOperation { op: BinaryOp::Multiply,
            left: Box::new(AstNode::BinaryOperation { op: BinaryOp::Add, left: Box::new(n(10.0)), right: Box::new(AstNode::ConceptLookup { concept_id: "photo".into(), arg: Box::new(n(50.0)) }) }),
            right: Box::new(n(2.0)) };
        let wat = t.compile_ast_to_wat(&ast, "uori_math_eval").unwrap();
        assert!(wat.contains("f64.add") && wat.contains("f64.mul"));
        assert!(!wat.contains("uori://") && !wat.contains("secret"));
        assert!(!wat.contains("import"));
    }

    #[test]
    fn rejects_unsafe_or_ambiguous_inputs() {
        let t = UoriWasmTranspiler::new();
        assert_eq!(t.compile_ast_to_wat(&n(f64::NAN), "ok"), Err(EmitError::NonFiniteNumber));
        assert_eq!(t.compile_ast_to_wat(&n(1.0), "bad name"), Err(EmitError::InvalidFunctionName));
        assert_eq!(t.compile_ast_to_wat(&AstNode::Variable("x".into()), "ok"), Err(EmitError::UnboundVariable));
    }
}
