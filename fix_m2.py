import sys
NL = chr(92) + 'n'
def rep(path, old, new, label):
    src = open(path).read()
    if src.count(old) != 1:
        print("FAIL", label, "count =", src.count(old)); sys.exit(1)
    open(path, "w").write(src.replace(old, new))
    print("OK", label)

N = "MAL/src/native/src/lib.rs"

rep(N, 'a.push_str(&format!("    mov {}, [vars + {}]' + NL + '", reg, slot * 8));',
       'a.push_str(&format!("    mov {}, [rbp - {}]' + NL + '", reg, (slot + 1) * 8));', "C3")

rep(N, 'a.push_str(&format!("    mov [vars + {}], rax' + NL + '", slot * 8));',
       'a.push_str(&format!("    mov [rbp - {}], rax' + NL + '", (slot + 1) * 8));', "C4")

old5 = '''            } else {
                // Regular function call via fat pointer
                let arg_regs = ["rdi", "rsi", "rdx", "rcx", "r8", "r9"];
                for (i, arg) in args.iter().enumerate() {
                    if i < 6 {
                        load(&mut a, *arg, values, ctx, arg_regs[i]);
                    } else {
                        load(&mut a, *arg, values, ctx, "rax");
                        a.push_str("    push rax''' + NL + '''");
                    }
                }
                load(&mut a, *callee, values, ctx, "r10");
                a.push_str("    push r15''' + NL + '''");
                a.push_str("    mov r15, r10''' + NL + '''");
                a.push_str("    mov r10, [r10]''' + NL + '''");
                a.push_str("    call r10''' + NL + '''");
                a.push_str("    pop r15''' + NL + '''");
                store_result(&mut a, *result, ctx);
            }'''

new5 = '''            } else if let Some(&NIRValue::IntConst(tag)) = values.get(callee) {
                if tag >= 200 {
                    let arg_regs = ["rdi", "rsi", "rdx", "rcx", "r8", "r9"];
                    for (i, arg) in args.iter().enumerate() {
                        if i < 6 {
                            load(&mut a, *arg, values, ctx, arg_regs[i]);
                        }
                    }
                    a.push_str(&format!("    call fn_{}''' + NL + '''", tag));
                    store_result(&mut a, *result, ctx);
                } else {
                    a.push_str("    xor rax, rax''' + NL + '''");
                    store_result(&mut a, *result, ctx);
                }
            } else {
                a.push_str("    xor rax, rax''' + NL + '''");
                store_result(&mut a, *result, ctx);
            }'''
rep(N, old5, new5, "C5")

multi = '''
fn generate_assembly_multi(funcs: &[NIRFunction]) -> Result<String> {
    let mut asm = String::new();
    asm.push_str("global _start@NL@");
    asm.push_str("section .bss@NL@");
    asm.push_str("    vars resq 256@NL@");
    asm.push_str("    num_buf resb 32@NL@");
    asm.push_str("    negflag resb 1@NL@");
    asm.push_str("    read_buf resb 256@NL@");
    asm.push_str("    file_path_buf resb 256@NL@");
    asm.push_str("    file_buf resb 4096@NL@");
    asm.push_str("    arena_ptr resq 1@NL@");
    asm.push_str("    arena_mem resb 262144@NL@");
    asm.push_str("    fds_tmp resq 2@NL@");
    asm.push_str("    chan_tmp resq 1@NL@");
    asm.push_str("    t_stack resb 65536@NL@");
    asm.push_str("    t_task resq 4@NL@");
    asm.push_str("    t_status resq 1@NL@");
    asm.push_str("@NL@section .data@NL@");
    asm.push_str("    nl_ptr: db 10@NL@");
    asm.push_str("@NL@section .text@NL@");
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
        asm.push_str(&format!("fn_{}:@NL@", tag));
        asm.push_str("    push rbp@NL@    mov rbp, rsp@NL@");
        if frame > 0 {
            asm.push_str(&format!("    sub rsp, {}@NL@", frame));
        }
        let arg_regs = ["rdi", "rsi", "rdx", "rcx", "r8", "r9"];
        for (pi, p) in func.params.iter().enumerate() {
            if pi < 6 {
                if let Some(&slot) = ctx.value_map.get(p) {
                    asm.push_str(&format!("    mov [rbp - {}], {}@NL@", (slot + 1) * 8, arg_regs[pi]));
                }
            }
        }
        for block in &func.blocks {
            if block.id != func.entry_block {
                asm.push_str(&format!(".bb_{}:@NL@", block.id.0));
            }
            for instr in &block.instructions {
                if let NIRInstruction::Return { value } = instr {
                    if let Some(v) = value {
                        load(&mut asm, *v, &func.values, &ctx, "rax");
                    } else {
                        asm.push_str("    xor rax, rax@NL@");
                    }
                    asm.push_str("    mov rsp, rbp@NL@    pop rbp@NL@    ret@NL@");
                } else {
                    asm.push_str(&emit_instr(instr, &func.values, &mut ctx)?);
                }
            }
        }
        asm.push_str("    xor rax, rax@NL@    mov rsp, rbp@NL@    pop rbp@NL@    ret@NL@@NL@");
    }

    let main_idx = funcs.iter().position(|f| f.name == "main").unwrap_or(0);
    asm.push_str("_start:@NL@");
    asm.push_str("    lea rax, [arena_mem]@NL@    mov [arena_ptr], rax@NL@    xor rdi, rdi@NL@");
    asm.push_str(&format!("    call fn_{}@NL@", 200 + main_idx as i64));
    asm.push_str("    mov rdi, rax@NL@    mov rax, 60@NL@    syscall@NL@");
    Ok(asm)
}
'''.replace('@NL@', NL)

with open(N, "a") as f:
    f.write(multi)
print("OK C6: generate_assembly_multi appended")
print("ALL FIXED")
