#!/usr/bin/env python3
import sys
Q = chr(92) + 'n'   # نستخدمه بدل backslash-n الحرفي لتفادي تلف heredoc
DQ = chr(34)

def rep(path, old, new, label):
    src = open(path).read()
    if src.count(old) != 1:
        print(f"FAIL [{label}] count={src.count(old)} in {path}"); sys.exit(1)
    open(path, "w").write(src.replace(old, new))
    print(f"OK [{label}]")

# ═════════ AGENT-D: إذا/وإلا ═════════
A = "src/arena/src/lib.rs"
rep(A, """    /// Match arm: pattern ⇒ body (Phase 43).
    MatchArm {""",
"""    /// Conditional: if (cond) { then } else { else }
    If {
        /// الشرط.
        cond: NodeID,
        /// جسم الشرط.
        then_body: NodeID,
        /// جسم الإلا.
        else_body: NodeID,
    },
    /// Match arm: pattern ⇒ body (Phase 43).
    MatchArm {""", "D1: ASTNode::If")

rep(A, "            ASTNode::Match { .. } => TypeTag::Match,",
    "            ASTNode::If { .. } => TypeTag::Match,
            ASTNode::Match { .. } => TypeTag::Match,",
    "D2: TypeTag arm")

L = "src/lexer/src/lib.rs"
rep(L, "    /// `ELSE`
    Else,",
    "    /// `IF`
    If,
    /// `ELSE`
    Else,", "D3: TokenKind::If")

rep(L, '                    "when" | "WHEN" => TokenKind::When,',
    '                    "if" | "IF" | "إذا" => TokenKind::If,
                    "وإلا" => TokenKind::Else,
                    "when" | "WHEN" => TokenKind::When,',
    "D4: keywords إذا/وإلا")

P = "src/parser/src/lib.rs"
if_arm = '''            TokenKind::If => {
                self.bump();
                self.expect(TokenKind::LParen)?;
                let cond = self.parse_expr(arena)?;
                self.expect(TokenKind::RParen)?;
                self.expect(TokenKind::LBlock)?;
                let mut then_stmts = Vec::new();
                while self.peek().map_or(false, |t| t.kind != TokenKind::RBlock) {
                    then_stmts.push(self.parse_stmt(arena)?);
                }
                self.expect(TokenKind::RBlock)?;
                let then_body = if then_stmts.len() == 1 { then_stmts[0] } else { *then_stmts.last().unwrap() };
                let else_body = if self.peek().map_or(false, |t| t.kind == TokenKind::Else) {
                    self.bump();
                    self.expect(TokenKind::LBlock)?;
                    let mut else_stmts = Vec::new();
                    while self.peek().map_or(false, |t| t.kind != TokenKind::RBlock) {
                        else_stmts.push(self.parse_stmt(arena)?);
                    }
                    self.expect(TokenKind::RBlock)?;
                    if else_stmts.len() == 1 { else_stmts[0] } else { *else_stmts.last().unwrap() }
                } else {
                    arena.allocate(ASTNode::Empty)?
                };
                let node = arena.allocate(ASTNode::If { cond, then_body, else_body })?;
                if self.peek().map_or(false, |t| t.kind == TokenKind::Semicolon) { self.bump(); }
                Ok(node)
            }
            TokenKind::Let => {'''
rep(P, "            TokenKind::Let => {", if_arm, "D5: parse if/else")

N = "src/nir/src/lowering.rs"
if_lower = '''            ASTNode::If { cond, then_body, else_body } => {
                let c = match self.lower_node(*cond) {
                    Some(v) => v,
                    None => return None,
                };
                let then_bb = self.func.fresh_block();
                let else_bb = self.func.fresh_block();
                let end_block = self.func.fresh_block();
                self.func.add_instruction(self.current_block,
                    NIRInstruction::CondBranch { cond: c, then_bb, else_bb });
                let result = self.func.fresh_value(NIRValue::Undef);
                let saved = self.current_block;
                self.current_block = then_bb;
                if let Some(tv) = self.lower_node(*then_body) {
                    self.func.add_instruction(then_bb,
                        NIRInstruction::Move { value: tv, result });
                }
                self.func.add_instruction(then_bb,
                    NIRInstruction::Branch { target: end_block });
                self.current_block = else_bb;
                if let Some(ev) = self.lower_node(*else_body) {
                    self.func.add_instruction(else_bb,
                        NIRInstruction::Move { value: ev, result });
                }
                self.func.add_instruction(else_bb,
                    NIRInstruction::Branch { target: end_block });
                self.current_block = end_block;
                Some(result)
            }
            ASTNode::LinearLet { name, value, body } => {'''
rep(N, "            ASTNode::LinearLet { name, value, body } => {",
    if_lower, "D6: lower if/else")

# ═════════ AGENT-C2: printf عربي ═════════
R = "src/nir/src/lib.rs"
rep(R, "    pub next_block_id: u32,",
    "    pub next_block_id: u32,
    /// جدول النصوص العامة.
    pub strings: Vec<String>,",
    "C2a: strings field")

rep(R, "next_value_id: 0, next_block_id: 0 }",
    "next_value_id: 0, next_block_id: 0, strings: Vec::new() }",
    "C2b: init strings")

rep(N, "use crate::TypeEnv;",
    "use crate::TypeEnv;

static STRINGS: std::sync::Mutex<Vec<String>> = std::sync::Mutex::new(Vec::new());",
    "C2c: STRINGS static")

str_arm = '''            ASTNode::Str(idx) => {
                let start = *idx as usize;
                let bytes = self.source.as_bytes();
                if start < bytes.len() && bytes[start] == DQ {
                    let rest = &self.source[start + 1..];
                    if let Some(endpos) = rest.find(DQ) {
                        let s = rest[..endpos].to_string();
                        let id = STRINGS.lock().map(|mut t| {
                            t.push(s);
                            t.len() - 1
                        }).unwrap_or(0);
                        return Some(self.func.fresh_value(NIRValue::StrConst(id as u32)));
                    }
                }
                None
            }
            ASTNode::LinearLet { name, value, body } => {'''
str_arm = str_arm.replace("DQ", DQ)
rep(N, "            ASTNode::LinearLet { name, value, body } => {",
    str_arm, "C2d: Str lowering")

rep(N, """        out.push(lower.lower(f.body));
    }
    out
}""",
"""        out.push(lower.lower(f.body));
    }
    let table = STRINGS.lock().map(|t| t.clone()).unwrap_or_default();
    for f in out.iter_mut() {
        f.strings = table.clone();
    }
    out
}""", "C2e: fill strings table")

V = "src/native/src/lib.rs"
rep(V, '''        "print_str" => {
            if args.len() != 1 { return Err(CompileError::Unsupported("print_str needs 1 arg".into())); }
            load(a, args[0], values, ctx, "rax");
            a.push_str("    call print_str''' + Q + '''");
            store_result(a, result, ctx);
        }''',
'''        "print_str" => {
            if args.len() != 1 { return Err(CompileError::Unsupported("print_str needs 1 arg".into())); }
            if let Some(NIRValue::StrConst(id)) = values.get(&args[0]) {
                a.push_str(&format!("    lea rax, [str_{}]' + Q + '", id));
            } else {
                load(a, args[0], values, ctx, "rax");
            }
            a.push_str("    call print_str''' + Q + '''");
            store_result(a, result, ctx);
        }'''.replace("'" + Q + "'", Q), "C2f: print_str StrConst")

rep(V, "    asm.push_str(&emit_all_helpers());",
    '''    asm.push_str(&emit_all_helpers());
    if !funcs.is_empty() {
        for (i, s) in funcs[0].strings.iter().enumerate() {
            let escaped = s.replace(DQ, chr(92).to_string().as_str() + DQ);
            asm.push_str(&format!("str_{}: db DQ{}DQ, 0' + Q + '", i, escaped));
        }
    }'''.replace("DQ", DQ).replace("' + Q + '", Q), "C2g: emit string table")

open("/tmp/team/state.md", "a").write("
- Agent-D: رقعة إذا/وإلا طُبقت
- Agent-C2: رقعة printf/Str طُبقت
")
print("🎉 BOTH AGENT PATCHES APPLIED")
