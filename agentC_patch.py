#!/usr/bin/env python3
import sys
P = "src/nir/src/lowering.rs"
src = open(P).read()

def rep(old, new, label):
    global src
    if src.count(old) != 1:
        print(f"FAIL [{label}] count={src.count(old)}"); sys.exit(1)
    src = src.replace(old, new)
    print(f"OK [{label}]")

rep("use mal_arena::{ASTNode, NodeID, BinaryOp, UnaryOp, Arena};",
    "use mal_arena::{ASTNode, NodeID, BinaryOp, UnaryOp, Arena, Pattern};",
    "C1: import Pattern")

match_arm = '''            ASTNode::Match { scrutinee, arms } => {
                let scr = match self.lower_node(*scrutinee) {
                    Some(v) => v,
                    None => return None,
                };
                let end_block = self.func.fresh_block();
                let result = self.func.fresh_value(NIRValue::Undef);
                let mut created: Vec<(Option<i64>, NodeID)> = Vec::new();
                let mut cur = *arms;
                loop {
                    if cur.0 == u32::MAX { break; }
                    match self.arena.get(cur) {
                        Ok(ASTNode::List { head, tail }) => {
                            if let Ok(ASTNode::MatchArm { pattern, body }) = self.arena.get(*head) {
                                let lit = match pattern {
                                    Pattern::Literal(v) => Some(*v),
                                    _ => None,
                                };
                                created.push((lit, *body));
                            }
                            cur = *tail;
                        }
                        Ok(ASTNode::MatchArm { pattern, body }) => {
                            let lit = match pattern {
                                Pattern::Literal(v) => Some(*v),
                                _ => None,
                            };
                            created.push((lit, *body));
                            break;
                        }
                        _ => break,
                    }
                }
                let n = created.len();
                let mut check = self.current_block;
                for (i, (lit, body)) in created.iter().enumerate() {
                    let ab = self.func.fresh_block();
                    match lit {
                        Some(v) => {
                            let litv = self.func.fresh_value(NIRValue::IntConst(*v));
                            let c = self.func.fresh_value(NIRValue::Undef);
                            self.func.add_instruction(check,
                                NIRInstruction::BinOp { op: NIROp::Eq, lhs: scr, rhs: litv, result: c });
                            if i == n - 1 {
                                self.func.add_instruction(check,
                                    NIRInstruction::CondBranch { cond: c, then_bb: ab, else_bb: end_block });
                            } else {
                                let next_check = self.func.fresh_block();
                                self.func.add_instruction(check,
                                    NIRInstruction::CondBranch { cond: c, then_bb: ab, else_bb: next_check });
                                check = next_check;
                            }
                        }
                        None => {
                            self.func.add_instruction(check,
                                NIRInstruction::Branch { target: ab });
                        }
                    }
                    let saved = self.current_block;
                    self.current_block = ab;
                    if let Some(bv) = self.lower_node(*body) {
                        self.func.add_instruction(ab,
                            NIRInstruction::Move { value: bv, result });
                    }
                    self.func.add_instruction(ab,
                        NIRInstruction::Branch { target: end_block });
                    self.current_block = saved;
                }
                self.current_block = end_block;
                Some(result)
            }
            ASTNode::LinearLet { name, value, body } => {'''

rep("            ASTNode::LinearLet { name, value, body } => {",
    match_arm, "C2: Match lowering")

open(P, "w").write(src)
print("🎉 MATCH PATCH APPLIED")
