#!/usr/bin/env python3
import sys
Q = chr(92) + 'n'
BS = chr(92)
DQ = chr(34)

def rep(path, old, new, label):
    old = old.replace('{Q}', Q)
    new = new.replace('{Q}', Q)
    src = open(path).read()
    if new in src:
        print(f'SKIP [{label}] already applied'); return
    if src.count(old) != 1:
        print(f'FAIL [{label}] count={src.count(old)} in {path}'); sys.exit(1)
    open(path, 'w').write(src.replace(old, new))
    print(f'OK [{label}]')

A = 'src/arena/src/lib.rs'
rep(A, '    MatchArm {',
'    /// Conditional: if (cond) then else{Q}    If {{{Q}        cond: NodeID,{Q}        then_body: NodeID,{Q}        else_body: NodeID,{Q}    }},{Q}    MatchArm {', 'D1')
rep(A, '            ASTNode::Match { .. } => TypeTag::Match,',
'            ASTNode::If { .. } => TypeTag::Match,{Q}            ASTNode::Match { .. } => TypeTag::Match,', 'D2')

L = 'src/lexer/src/lib.rs'
rep(L, '    Else,', '    /// `IF`{Q}    If,{Q}    /// `ELSE`{Q}    Else,', 'D3')
rep(L, '                    "when" | "WHEN" => TokenKind::When,',
'                    "if" | "IF" | "إذا" => TokenKind::If,{Q}                    "وإلا" => TokenKind::Else,{Q}                    "when" | "WHEN" => TokenKind::When,', 'D4')

P = 'src/parser/src/lib.rs'
if_arm = ('            TokenKind::If => {{{Q}'
'                self.bump();{Q}'
'                self.expect(TokenKind::LParen)?;{Q}'
'                let cond = self.parse_expr(arena)?;{Q}'
'                self.expect(TokenKind::RParen)?;{Q}'
'                self.expect(TokenKind::LBlock)?;{Q}'
'                let mut then_stmts = Vec::new();{Q}'
'                while self.peek().map_or(false, |t| t.kind != TokenKind::RBlock) {{{Q}'
'                    then_stmts.push(self.parse_stmt(arena)?);{Q}'
'                }}{Q}'
'                self.expect(TokenKind::RBlock)?;{Q}'
'                let then_body = if then_stmts.len() == 1 {{ then_stmts[0] }} else {{ *then_stmts.last().unwrap() }};{Q}'
'                let else_body = if self.peek().map_or(false, |t| t.kind == TokenKind::Else) {{{Q}'
'                    self.bump();{Q}'
'                    self.expect(TokenKind::LBlock)?;{Q}'
'                    let mut else_stmts = Vec::new();{Q}'
'                    while self.peek().map_or(false, |t| t.kind != TokenKind::RBlock) {{{Q}'
'                        else_stmts.push(self.parse_stmt(arena)?);{Q}'
'                    }}{Q}'
'                    self.expect(TokenKind::RBlock)?;{Q}'
'                    if else_stmts.len() == 1 {{ else_stmts[0] }} else {{ *else_stmts.last().unwrap() }}{Q}'
'                }} else {{{Q}'
'                    arena.allocate(ASTNode::Empty)?{Q}'
'                }};{Q}'
'                let node = arena.allocate(ASTNode::If {{ cond, then_body, else_body }})?;{Q}'
'                if self.peek().map_or(false, |t| t.kind == TokenKind::Semicolon) {{ self.bump(); }}{Q}'
'                Ok(node){Q}'
'            }}{Q}'
'            TokenKind::Let => {{')
rep(P, '            TokenKind::Let => {{'.replace('{{','{').replace('}}','}'), if_arm.replace('{{','{').replace('}}','}'), 'D5')

N = 'src/nir/src/lowering.rs'
if_lower = ('            ASTNode::If {{ cond, then_body, else_body }} => {{{Q}'
'                let c = match self.lower_node(*cond) {{ Some(v) => v, None => return None }};{Q}'
'                let then_bb = self.func.fresh_block();{Q}'
'                let else_bb = self.func.fresh_block();{Q}'
'                let end_block = self.func.fresh_block();{Q}'
'                self.func.add_instruction(self.current_block,{Q}'
'                    NIRInstruction::CondBranch {{ cond: c, then_bb, else_bb }});{Q}'
'                let result = self.func.fresh_value(NIRValue::Undef);{Q}'
'                let saved = self.current_block;{Q}'
'                self.current_block = then_bb;{Q}'
'                if let Some(tv) = self.lower_node(*then_body) {{{Q}'
'                    self.func.add_instruction(then_bb,{Q}'
'                        NIRInstruction::Move {{ value: tv, result }});{Q}'
'                }}{Q}'
'                self.func.add_instruction(then_bb,{Q}'
'                    NIRInstruction::Branch {{ target: end_block }});{Q}'
'                self.current_block = else_bb;{Q}'
'                if let Some(ev) = self.lower_node(*else_body) {{{Q}'
'                    self.func.add_instruction(else_bb,{Q}'
'                        NIRInstruction::Move {{ value: ev, result }});{Q}'
'                }}{Q}'
'                self.func.add_instruction(else_bb,{Q}'
'                    NIRInstruction::Branch {{ target: end_block }});{Q}'
'                self.current_block = end_block;{Q}'
'                Some(result){Q}'
'            }}{Q}'
'            ASTNode::LinearLet {{ name, value, body }} => {{')
rep(N, '            ASTNode::LinearLet {{ name, value, body }} => {{'.replace('{{','{').replace('}}','}'), if_lower.replace('{{','{').replace('}}','}'), 'D6')

R = 'src/nir/src/lib.rs'
rep(R, '    pub next_block_id: u32,', '    pub next_block_id: u32,{Q}    /// جدول النصوص.{Q}    pub strings: Vec<String>,', 'C2a')
rep(R, 'next_value_id: 0, next_block_id: 0 }', 'next_value_id: 0, next_block_id: 0, strings: Vec::new() }', 'C2b')
rep(N, 'use crate::TypeEnv;', 'use crate::TypeEnv;{Q}{Q}static STRINGS: std::sync::Mutex<Vec<String>> = std::sync::Mutex::new(Vec::new());', 'C2c')

str_arm = ('            ASTNode::Str(idx) => {{{Q}'
'                let start = *idx as usize;{Q}'
'                let bytes = self.source.as_bytes();{Q}'
'                if start < bytes.len() && bytes[start] == ' + DQ + ' {' + Q +
'                    let rest = &self.source[start + 1..];{Q}'
'                    if let Some(endpos) = rest.find(' + DQ + ') {{{Q}'
'                        let s = rest[..endpos].to_string();{Q}'
'                        let id = STRINGS.lock().map(|mut t| {{ t.push(s); t.len() - 1 }}).unwrap_or(0);{Q}'
'                        return Some(self.func.fresh_value(NIRValue::StrConst(id as u32)));{Q}'
'                    }}{Q}'
'                }}{Q}'
'                None{Q}'
'            }}{Q}'
'            ASTNode::LinearLet {{ name, value, body }} => {{')
rep(N, '            ASTNode::LinearLet {{ name, value, body }} => {{'.replace('{{','{').replace('}}','}'), str_arm.replace('{{','{').replace('}}','}'), 'C2d')

print('SKIP C2e (applied directly)')

V = 'src/native/src/lib.rs'
old_ps = ('        "print_str" => {{' + Q +
'            if args.len() != 1 {{ return Err(CompileError::Unsupported("print_str needs 1 arg".into())); }}' + Q +
'            load(a, args[0], values, ctx, "rax");' + Q +
'            a.push_str("    call print_str{Q}");' + Q +
'            store_result(a, result, ctx);' + Q +
'        }}')
new_ps = ('        "print_str" => {{' + Q +
'            if args.len() != 1 {{ return Err(CompileError::Unsupported("print_str needs 1 arg".into())); }}' + Q +
'            if let Some(NIRValue::StrConst(id)) = values.get(&args[0]) {{{Q}'
'                a.push_str(&format!("    lea rax, [str_{}]{Q}", id));{Q}'
'            }} else {{{Q}'
'                load(a, args[0], values, ctx, "rax");{Q}'
'            }}{Q}'
'            a.push_str("    call print_str{Q}");' + Q +
'            store_result(a, result, ctx);{Q}'
'        }}')
rep(V, old_ps.replace('{{','{').replace('}}','}'), new_ps.replace('{{','{').replace('}}','}'), 'C2f')

rep(V, '    asm.push_str(&emit_all_helpers());',
'    asm.push_str(&emit_all_helpers());{Q}    if !funcs.is_empty() {{{Q}        for (i, s) in funcs[0].strings.iter().enumerate() {{{Q}            asm.push_str(&format!("str_{{}}: db ' + BS + DQ + '{{}}{{}}' + BS + DQ + ', 0{Q}", i, s));{Q}        }}{Q}    }}', 'C2g')

open('/tmp/team/state.md', 'a').write(chr(10).join(['- Agent-D: applied', '- Agent-C2: applied']) + chr(10))
print('BOTH PATCHES APPLIED')print('SKIP C2d (applied directly)')in/env python3
import sys
Q = chr(92) + 'n'
BS = chr(92)
DQ = chr(34)

def rep(path, old, new, label):
    old = old.replace('{Q}', Q)
    new = new.replace('{Q}', Q)
    src = open(path).read()
    if new in src:
        print(f'SKIP [{label}] already applied'); return
    if src.count(old) != 1:
        print(f'FAIL [{label}] count={src.count(old)} in {path}'); sys.exit(1)
    open(path, 'w').write(src.replace(old, new))
    print(f'OK [{label}]')

A = 'src/arena/src/lib.rs'
rep(A, '    MatchArm {',
'    /// Conditional: if (cond) then else{Q}    If {{{Q}        cond: NodeID,{Q}        then_body: NodeID,{Q}        else_body: NodeID,{Q}    }},{Q}    MatchArm {', 'D1')
rep(A, '            ASTNode::Match { .. } => TypeTag::Match,',
'            ASTNode::If { .. } => TypeTag::Match,{Q}            ASTNode::Match { .. } => TypeTag::Match,', 'D2')

L = 'src/lexer/src/lib.rs'
rep(L, '    Else,', '    /// `IF`{Q}    If,{Q}    /// `ELSE`{Q}    Else,', 'D3')
rep(L, '                    "when" | "WHEN" => TokenKind::When,',
'                    "if" | "IF" | "إذا" => TokenKind::If,{Q}                    "وإلا" => TokenKind::Else,{Q}                    "when" | "WHEN" => TokenKind::When,', 'D4')

P = 'src/parser/src/lib.rs'
if_arm = ('            TokenKind::If => {{{Q}'
'                self.bump();{Q}'
'                self.expect(TokenKind::LParen)?;{Q}'
'                let cond = self.parse_expr(arena)?;{Q}'
'                self.expect(TokenKind::RParen)?;{Q}'
'                self.expect(TokenKind::LBlock)?;{Q}'
'                let mut then_stmts = Vec::new();{Q}'
'                while self.peek().map_or(false, |t| t.kind != TokenKind::RBlock) {{{Q}'
'                    then_stmts.push(self.parse_stmt(arena)?);{Q}'
'                }}{Q}'
'                self.expect(TokenKind::RBlock)?;{Q}'
'                let then_body = if then_stmts.len() == 1 {{ then_stmts[0] }} else {{ *then_stmts.last().unwrap() }};{Q}'
'                let else_body = if self.peek().map_or(false, |t| t.kind == TokenKind::Else) {{{Q}'
'                    self.bump();{Q}'
'                    self.expect(TokenKind::LBlock)?;{Q}'
'                    let mut else_stmts = Vec::new();{Q}'
'                    while self.peek().map_or(false, |t| t.kind != TokenKind::RBlock) {{{Q}'
'                        else_stmts.push(self.parse_stmt(arena)?);{Q}'
'                    }}{Q}'
'                    self.expect(TokenKind::RBlock)?;{Q}'
'                    if else_stmts.len() == 1 {{ else_stmts[0] }} else {{ *else_stmts.last().unwrap() }}{Q}'
'                }} else {{{Q}'
'                    arena.allocate(ASTNode::Empty)?{Q}'
'                }};{Q}'
'                let node = arena.allocate(ASTNode::If {{ cond, then_body, else_body }})?;{Q}'
'                if self.peek().map_or(false, |t| t.kind == TokenKind::Semicolon) {{ self.bump(); }}{Q}'
'                Ok(node){Q}'
'            }}{Q}'
'            TokenKind::Let => {{')
rep(P, '            TokenKind::Let => {{'.replace('{{','{').replace('}}','}'), if_arm.replace('{{','{').replace('}}','}'), 'D5')

N = 'src/nir/src/lowering.rs'
if_lower = ('            ASTNode::If {{ cond, then_body, else_body }} => {{{Q}'
'                let c = match self.lower_node(*cond) {{ Some(v) => v, None => return None }};{Q}'
'                let then_bb = self.func.fresh_block();{Q}'
'                let else_bb = self.func.fresh_block();{Q}'
'                let end_block = self.func.fresh_block();{Q}'
'                self.func.add_instruction(self.current_block,{Q}'
'                    NIRInstruction::CondBranch {{ cond: c, then_bb, else_bb }});{Q}'
'                let result = self.func.fresh_value(NIRValue::Undef);{Q}'
'                let saved = self.current_block;{Q}'
'                self.current_block = then_bb;{Q}'
'                if let Some(tv) = self.lower_node(*then_body) {{{Q}'
'                    self.func.add_instruction(then_bb,{Q}'
'                        NIRInstruction::Move {{ value: tv, result }});{Q}'
'                }}{Q}'
'                self.func.add_instruction(then_bb,{Q}'
'                    NIRInstruction::Branch {{ target: end_block }});{Q}'
'                self.current_block = else_bb;{Q}'
'                if let Some(ev) = self.lower_node(*else_body) {{{Q}'
'                    self.func.add_instruction(else_bb,{Q}'
'                        NIRInstruction::Move {{ value: ev, result }});{Q}'
'                }}{Q}'
'                self.func.add_instruction(else_bb,{Q}'
'                    NIRInstruction::Branch {{ target: end_block }});{Q}'
'                self.current_block = end_block;{Q}'
'                Some(result){Q}'
'            }}{Q}'
'            ASTNode::LinearLet {{ name, value, body }} => {{')
rep(N, '            ASTNode::LinearLet {{ name, value, body }} => {{'.replace('{{','{').replace('}}','}'), if_lower.replace('{{','{').replace('}}','}'), 'D6')

R = 'src/nir/src/lib.rs'
rep(R, '    pub next_block_id: u32,', '    pub next_block_id: u32,{Q}    /// جدول النصوص.{Q}    pub strings: Vec<String>,', 'C2a')
rep(R, 'next_value_id: 0, next_block_id: 0 }', 'next_value_id: 0, next_block_id: 0, strings: Vec::new() }', 'C2b')
rep(N, 'use crate::TypeEnv;', 'use crate::TypeEnv;{Q}{Q}static STRINGS: std::sync::Mutex<Vec<String>> = std::sync::Mutex::new(Vec::new());', 'C2c')

str_arm = ('            ASTNode::Str(idx) => {{{Q}'
'                let start = *idx as usize;{Q}'
'                let bytes = self.source.as_bytes();{Q}'
'                if start < bytes.len() && bytes[start] == ' + DQ + ' {' + Q +
'                    let rest = &self.source[start + 1..];{Q}'
'                    if let Some(endpos) = rest.find(' + DQ + ') {{{Q}'
'                        let s = rest[..endpos].to_string();{Q}'
'                        let id = STRINGS.lock().map(|mut t| {{ t.push(s); t.len() - 1 }}).unwrap_or(0);{Q}'
'                        return Some(self.func.fresh_value(NIRValue::StrConst(id as u32)));{Q}'
'                    }}{Q}'
'                }}{Q}'
'                None{Q}'
'            }}{Q}'
'            ASTNode::LinearLet {{ name, value, body }} => {{')
rep(N, '            ASTNode::LinearLet {{ name, value, body }} => {{'.replace('{{','{').replace('}}','}'), str_arm.replace('{{','{').replace('}}','}'), 'C2d')

rep(N, '        out.push(lower.lower(f.body));{Q}    }{Q}    let table = STRINGS.lock().map(|t| t.clone()).unwrap_or_default();{Q}    for f in out.iter_mut() {{ f.strings = table.clone(); }}{Q}    out{Q}}}',
'        out.push(lower.lower(f.body));{Q}    }{Q}    let table = STRINGS.lock().map(|t| t.clone()).unwrap_or_default();{Q}    for f in out.iter_mut() {{ f.strings = table.clone(); }}{Q}    out{Q}}}', 'C2e')

V = 'src/native/src/lib.rs'
old_ps = ('        "print_str" => {{' + Q +
'            if args.len() != 1 {{ return Err(CompileError::Unsupported("print_str needs 1 arg".into())); }}' + Q +
'            load(a, args[0], values, ctx, "rax");' + Q +
'            a.push_str("    call print_str{Q}");' + Q +
'            store_result(a, result, ctx);' + Q +
'        }}')
new_ps = ('        "print_str" => {{' + Q +
'            if args.len() != 1 {{ return Err(CompileError::Unsupported("print_str needs 1 arg".into())); }}' + Q +
'            if let Some(NIRValue::StrConst(id)) = values.get(&args[0]) {{{Q}'
'                a.push_str(&format!("    lea rax, [str_{}]{Q}", id));{Q}'
'            }} else {{{Q}'
'                load(a, args[0], values, ctx, "rax");{Q}'
'            }}{Q}'
'            a.push_str("    call print_str{Q}");' + Q +
'            store_result(a, result, ctx);{Q}'
'        }}')
rep(V, old_ps.replace('{{','{').replace('}}','}'), new_ps.replace('{{','{').replace('}}','}'), 'C2f')

rep(V, '    asm.push_str(&emit_all_helpers());',
'    asm.push_str(&emit_all_helpers());{Q}    if !funcs.is_empty() {{{Q}        for (i, s) in funcs[0].strings.iter().enumerate() {{{Q}            asm.push_str(&format!("str_{{}}: db ' + BS + DQ + '{{}}{{}}' + BS + DQ + ', 0{Q}", i, s));{Q}        }}{Q}    }}', 'C2g')

open('/tmp/team/state.md', 'a').write(chr(10).join(['- Agent-D: applied', '- Agent-C2: applied']) + chr(10))
print('BOTH PATCHES APPLIED')
