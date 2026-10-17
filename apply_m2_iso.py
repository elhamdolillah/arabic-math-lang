#!/usr/bin/env python3
import re, sys

def rep(path, old, new, label):
    src = open(path).read()
    if old not in src:
        print(f"❌ FAIL [{label}]: pattern not found in {path}")
        sys.exit(1)
    if src.count(old) != 1:
        print(f"❌ FAIL [{label}]: pattern appears {src.count(old)} times in {path}")
        sys.exit(1)
    open(path, "w").write(src.replace(old, new))
    print(f"✅ [{label}]")

# ═══════════ 1. PARSER ═══════════
P = "/srv/mal/isolated-malc/src/parser/src/lib.rs"

rep(P, "pub fn parse(",
"""#[derive(Debug, Clone)]
pub struct FnInfo {
    pub name: String,
    pub params: Vec<String>,
    pub body: NodeID,
}

static FN_TABLE: std::sync::Mutex<Vec<FnInfo>> = std::sync::Mutex::new(Vec::new());

pub fn parse_with_fns(src: &str, arena: &mut Arena) -> Result<(NodeID, Vec<FnInfo>), ParserError> {
    if let Ok(mut t) = FN_TABLE.lock() { t.clear(); }
    let root = parse(src, arena)?;
    let fns = FN_TABLE.lock().map(|t| t.clone()).unwrap_or_default();
    let root = fns.iter().find(|f| f.name == "main").map(|f| f.body).unwrap_or(root);
    Ok((root, fns))
}

pub fn parse(""", "P1: FnInfo + parse_with_fns")

rep(P, """    fn parse_fn_def(&mut self, arena: &mut Arena) -> Result<NodeID, ParserError> {
        self.bump(); // fn
        self.bump(); // name
        while let Some(t)=self.peek(){ if t.kind==TokenKind::RParen{self.bump();break;} self.bump(); }
        while let Some(t)=self.peek(){ if t.kind==TokenKind::LBlock{break;} self.bump(); }
        self.parse_stmt(arena)
    }""",
"""    fn parse_fn_def(&mut self, arena: &mut Arena) -> Result<NodeID, ParserError> {
        self.bump(); // fn
        let name_tok = self.bump().ok_or(ParserError::UnexpectedEof)?;
        let name = self.slice_ident(name_tok.start);
        let mut params: Vec<String> = Vec::new();
        if let Some(t) = self.peek() {
            if t.kind == TokenKind::LParen {
                self.bump();
                loop {
                    match self.peek().map(|t| t.kind) {
                        Some(TokenKind::RParen) => { self.bump(); break; }
                        Some(TokenKind::Ident) => {
                            let p = self.bump().ok_or(ParserError::UnexpectedEof)?;
                            params.push(self.slice_ident(p.start));
                            if let Some(t) = self.peek() {
                                if t.kind == TokenKind::Colon {
                                    self.bump();
                                    while let Some(t) = self.peek() {
                                        if matches!(t.kind, TokenKind::Comma | TokenKind::RParen) { break; }
                                        self.bump();
                                    }
                                }
                            }
                            if let Some(t) = self.peek() {
                                if t.kind == TokenKind::Comma { self.bump(); }
                            }
                        }
                        _ => break,
                    }
                }
            }
        }
        while let Some(t) = self.peek() {
            if t.kind == TokenKind::LBlock { break; }
            self.bump();
        }
        let body = self.parse_stmt(arena)?;
        if let Ok(mut t) = FN_TABLE.lock() {
            t.push(FnInfo { name, params, body });
        }
        Ok(arena.allocate(ASTNode::Empty)?)
    }

    fn slice_ident(&self, start: u32) -> String {
        let s = start as usize;
        let b = self.src.as_bytes();
        let mut e = s;
        while e < b.len() {
            let c = b[e];
            if c.is_ascii_alphanumeric() || c == b'_' { e += 1; continue; }
            if c >= 0xD8 && c <= 0xDB && e + 1 < b.len() && b[e + 1] >= 0x80 && b[e + 1] <= 0xBF { e += 2; continue; }
            break;
        }
        self.src[s..e].to_string()
    }""", "P2: parse_fn_def rewrite")

# ═══════════ 2. NIR LOWERING ═══════════
L = "/srv/mal/isolated-malc/src/nir/src/lowering.rs"

rep(L, "pub struct ASTLowerer<'a> {",
"""#[derive(Debug, Clone)]
pub struct FnSpec {
    pub name: String,
    pub params: Vec<String>,
    pub body: NodeID,
}

pub fn lower_program_with_source(arena: &Arena, source: &str, fns: &[FnSpec]) -> Vec<NIRFunction> {
    let mut user_fns: HashMap<String, u32> = HashMap::new();
    for (i, f) in fns.iter().enumerate() {
        user_fns.insert(f.name.clone(), i as u32);
    }
    let mut out = Vec::new();
    for f in fns {
        let mut lower = ASTLowerer::with_user_fns(arena, source, user_fns.clone());
        lower.func.name = f.name.clone();
        for p in &f.params {
            let v = lower.func.fresh_value(NIRValue::Undef);
            lower.vars.insert(p.clone(), v);
            lower.func.params.push(v);
        }
        out.push(lower.lower(f.body));
    }
    out
}

pub struct ASTLowerer<'a> {""", "N1: FnSpec + lower_program")

rep(L, """    last_value: Option<ValueID>,
    source: String,""",
"""    last_value: Option<ValueID>,
    user_fns: HashMap<String, u32>,
    source: String,""", "N2: struct field")

rep(L, """            last_value: None,
            source: source.to_string(),""",
"""            last_value: None,
            user_fns: HashMap::new(),
            source: source.to_string(),""", "N3: new() init")

rep(L, "    fn lower_node(&mut self, nid: NodeID) -> Option<ValueID> {",
"""    pub fn with_user_fns(arena: &'a Arena, source: &str, user_fns: HashMap<String, u32>) -> Self {
        let mut func = NIRFunction::new("main".to_string());
        let entry = func.fresh_block();
        func.entry_block = entry;
        Self {
            arena, func,
            map: HashMap::new(),
            vars: HashMap::new(),
            type_env: TypeEnv::new(),
            entry,
            current_block: entry,
            last_value: None,
            user_fns,
            source: source.to_string(),
        }
    }

    fn lower_node(&mut self, nid: NodeID) -> Option<ValueID> {""", "N4: with_user_fns ctor")

rep(L, """                if let Some(tag) = builtin_tag {
                    let callee = self.func.fresh_value(NIRValue::IntConst(tag));
                    let res = self.func.fresh_value(NIRValue::Undef);
                    self.func.add_instruction(self.current_block,
                        NIRInstruction::Call {
                            callee, args: arg_vals, result: res,
                        });
                    Some(res)
                } else {
                    None
                }""",
"""                if let Some(tag) = builtin_tag {
                    let callee = self.func.fresh_value(NIRValue::IntConst(tag));
                    let res = self.func.fresh_value(NIRValue::Undef);
                    self.func.add_instruction(self.current_block,
                        NIRInstruction::Call {
                            callee, args: arg_vals, result: res,
                        });
                    Some(res)
                } else {
                    let fname = self.arena.get(func_nid_copy).ok().and_then(|n| {
                        if let ASTNode::Ident(idx) = n {
                            let idx_copy = *idx;
                            self.extract_ident_name(idx_copy)
                        } else { None }
                    });
                    if let Some(fname) = fname {
                        if let Some(&fidx) = self.user_fns.get(&fname) {
                            let tag = 200 + fidx as i64;
                            let callee = self.func.fresh_value(NIRValue::IntConst(tag));
                            let res = self.func.fresh_value(NIRValue::Undef);
                            self.func.add_instruction(self.current_block,
                                NIRInstruction::Call {
                                    callee, args: arg_vals, result: res,
                                });
                            return Some(res);
                        }
                    }
                    None
                }""", "N5: user fn call")

# ═══════════ 3. NATIVE CODEGEN ═══════════
N = "/srv/mal/isolated-malc/src/native/src/lib.rs"

rep(N, "pub fn compile_to_native(func: &NIRFunction, output_path: &str) -> Result<()> {",
    "pub fn compile_to_native(funcs: &[NIRFunction], output_path: &str) -> Result<()> {",
    "C1: compile_to_native sig")

rep(N, "    let asm_code = generate_assembly(func)?;",
    "    let asm_code = generate_assembly_multi(funcs)?;",
    "C2: call multi")

rep(N, 'a.push_str(&format!("    mov {}, [vars + {}]\
", reg, slot * 8));',
    'a.push_str(&format!("    mov {}, [rbp - {}]\
", reg, (slot + 1) * 8));',
    "C3: load rbp-relative")

rep(N, 'a.push_str(&format!("    mov [vars + {}], rax\
", slot * 8));',
    'a.push_str(&format!("    mov [rbp - {}], rax\
", (slot + 1) * 8));',
    "C4: store rbp-relative")

rep(N, """            } else {
                // Regular function call via fat pointer
                let arg_regs = ["rdi", "rsi", "rdx", "rcx", "r8", "r9"];
                for (i, arg) in args.iter().enumerate() {
                    if i < 6 {
                        load(&mut a, *arg, values, ctx, arg_regs[i]);
                    } else {
                        load(&mut a, *arg, values, ctx, "rax");
                        a.push_str("    push rax\
");
                    }
                }
                load(&mut a, *callee, values, ctx, "r10");
                a.push_str("    push r15\
");
                a.push_str("    mov r15, r10\
");
                a.push_str("    mov r10, [r10]\
");
                a.push_str("    call r10\
");
                a.push_str("    pop r15\
");
                store_result(&mut a, *result, ctx);
            }""",
"""            } else if let Some(&NIRValue::IntConst(tag)) = values.get(callee) {
                if tag >= 200 {
                    let arg_regs = ["rdi", "rsi", "rdx", "rcx", "r8", "r9"];
                    for (i, arg) in args.iter().enumerate() {
                        if i < 6 {
                            load(&mut a, *arg, values, ctx, arg_regs[i]);
                        }
                    }
                    a.push_str(&format!("    call fn_{}\
", tag));
                    store_result(&mut a, *result, ctx);
                } else {
                    a.push_str("    xor rax, rax\
");
                    store_result(&mut a, *result, ctx);
                }
            } else {
                a.push_str("    xor rax, rax\
");
                store_result(&mut a, *result, ctx);
            }""", "C5: Call → fn_<tag>")

multi = '''
fn generate_assembly_multi(funcs: &[NIRFunction]) -> Result<String> {
    let mut asm = String::new();
    asm.push_str("global _start\
");
    asm.push_str("section .bss\
");
    asm.push_str("    vars resq 256\
");
    asm.push_str("    num_buf resb 32\
");
    asm.push_str("    negflag resb 1\
");
    asm.push_str("    read_buf resb 256\
");
    asm.push_str("    file_path_buf resb 256\
");
    asm.push_str("    file_buf resb 4096\
");
    asm.push_str("    arena_ptr resq 1\
");
    asm.push_str("    arena_mem resb 262144\
");
    asm.push_str("    fds_tmp resq 2\
");
    asm.push_str("    chan_tmp resq 1\
");
    asm.push_str("    t_stack resb 65536\
");
    asm.push_str("    t_task resq 4\
");
    asm.push_str("    t_status resq 1\
");
    asm.push_str("\
section .data\
");
    asm.push_str("    nl_ptr: db 10\
");
    asm.push_str("\
section .text\
");
    asm.push_str(&emit_all_helpers());

    for (i, func) in funcs.iter().enumerate() {
        let tag = 200 + i as i64;
        let mut ctx = CodeGenContext::new();
        for block in &func.blocks {
            for instr in &block.instructions {
                pre_scan(instr, &mut ctx);
            }
        }
        for p in &func.params {
            ctx.alloc_slot(*p);
        }
        let frame = ((ctx.next_slot + 1) * 8 + 15) & !15;
        asm.push_str(&format!("fn_{}:\
", tag));
        asm.push_str("    push rbp\
    mov rbp, rsp\
");
        if frame > 0 {
            asm.push_str(&format!("    sub rsp, {}\
", frame));
        }
        let arg_regs = ["rdi", "rsi", "rdx", "rcx", "r8", "r9"];
        for (pi, p) in func.params.iter().enumerate() {
            if pi < 6 {
                if let Some(&slot) = ctx.value_map.get(p) {
                    asm.push_str(&format!("    mov [rbp - {}], {}\
", (slot + 1) * 8, arg_regs[pi]));
                }
            }
        }
        for block in &func.blocks {
            if block.id != func.entry_block {
                asm.push_str(&format!(".bb_{}:\
", block.id.0));
            }
            for instr in &block.instructions {
                if let NIRInstruction::Return { value } = instr {
                    if let Some(v) = value {
                        load(&mut asm, *v, &func.values, &ctx, "rax");
                    } else {
                        asm.push_str("    xor rax, rax\
");
                    }
                    asm.push_str("    mov rsp, rbp\
    pop rbp\
    ret\
");
                } else {
                    asm.push_str(&emit_instr(instr, &func.values, &mut ctx)?);
                }
            }
        }
        asm.push_str("    xor rax, rax\
    mov rsp, rbp\
    pop rbp\
    ret\
\
");
    }

    let main_idx = funcs.iter().position(|f| f.name == "main").unwrap_or(0);
    asm.push_str(&format!("_start:\
"));
    asm.push_str("    lea rax, [arena_mem]\
    mov [arena_ptr], rax\
    xor rdi, rdi\
");
    asm.push_str(&format!("    call fn_{}\
", 200 + main_idx as i64));
    asm.push_str("    mov rdi, rax\
    mov rax, 60\
    syscall\
");
    Ok(asm)
}
'''
with open(N, "a") as f:
    f.write(multi)
print("✅ [C6] generate_assembly_multi appended")

print("\
🎉 ALL M2 PATCHES APPLIED")
