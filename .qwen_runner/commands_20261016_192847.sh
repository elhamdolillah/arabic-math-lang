cat > /root/ilm-al-kitab/duck.ai <<'SCRIPT'
#!/bin/bash
cd /root/ilm-al-kitab
BIN=/srv/mal/cache/cargo-target/release/malc-native
fix_all() {
python3 - <<'PY'
p='MAL/src/lexer/src/lib.rs'
s=open(p,encoding='utf-8').read()
NL=chr(10)
# 1) كلمات مفتاحية في الـ enum
anchor="    /// semicolon"+NL+"    Semicolon,"+NL
add=anchor+"    /// fn keyword"+NL+"    Fn,"+NL+"    /// let keyword"+NL+"    Let,"+NL+"    /// return keyword"+NL+"    Return,"+NL
if "    Fn," not in s: s=s.replace(anchor,add,1)
# 2) كلمات مفتاحية في مطابقة الكلمات
w='"false" => TokenKind::FalseLit,'+NL
if '"fn" => TokenKind::Fn' not in s:
    s=s.replace(w,w+'                    "fn" => TokenKind::Fn,'+NL+'                    "let" => TokenKind::Let,'+NL+'                    "return" => TokenKind::Return,'+NL,1)
open(p,'w',encoding='utf-8').write(s)
p='MAL/src/parser/src/lib.rs'
s=open(p,encoding='utf-8').read()
# 3) أذرع Fn/Let/Return في parse_stmt
anchor="            TokenKind::Print => {"
arms=("            TokenKind::Fn => {"+NL
+"                self.parse_fn_def(arena)"+NL
+"            }"+NL
+"            TokenKind::Let => {"+NL
+"                self.bump();"+NL
+"                let name=self.bump().ok_or(ParserError::UnexpectedEof)?;"+NL
+"                if self.peek().map_or(false,|t| t.kind==TokenKind::Colon){self.bump(); while self.peek().map_or(false,|t| t.kind==TokenKind::Ident){self.bump();}}"+NL
+"                self.expect(TokenKind::Assign)?;"+NL
+"                let value=self.parse_expr(arena)?;"+NL
+"                if self.peek().map_or(false,|t| t.kind==TokenKind::Semicolon){self.bump();}"+NL
+"                let left=arena.allocate(ASTNode::Ident(name.start))?;"+NL
+"                Ok(arena.allocate(ASTNode::BinOp{op:BinaryOp::Assign,left,right:value})?)"+NL
+"            }"+NL
+"            TokenKind::Return => {"+NL
+"                self.bump();"+NL
+"                let v=self.parse_expr(arena)?;"+NL
+"                if self.peek().map_or(false,|t| t.kind==TokenKind::Semicolon){self.bump();}"+NL
+"                Ok(v)"+NL
+"            }"+NL)
if "TokenKind::Fn =>" not in s: s=s.replace(anchor,arms+anchor,1)
# 4) فاصل ; داخل الكتل
old="stmts.push(self.parse_stmt(arena)?);"+NL+"                    if self.peek().map_or(false, |t| t.kind == TokenKind::Diamond) {"
new="stmts.push(self.parse_stmt(arena)?);"+NL+"                    if self.peek().map_or(false, |t| t.kind == TokenKind::Diamond || t.kind == TokenKind::Semicolon) {"
if new not in s: s=s.replace(old,new,1)
# 5) محلل تعريف الدالة (غلاف شفاف)
fn_def=("    fn parse_fn_def(&mut self, arena: &mut Arena) -> Result<NodeID, ParserError> {"+NL
+"        self.bump(); // fn"+NL
+"        self.bump(); // name"+NL
+"        while let Some(t)=self.peek(){ if t.kind==TokenKind::RParen{self.bump();break;} self.bump(); }"+NL
+"        while let Some(t)=self.peek(){ if t.kind==TokenKind::LBlock{break;} self.bump(); }"+NL
+"        self.parse_stmt(arena)"+NL
+"    }"+NL)
if "fn parse_fn_def" not in s:
    s=s.replace("    fn parse_primary",fn_def+"    fn parse_primary",1)
open(p,'w',encoding='utf-8').write(s)
print("[OK] fn/let/return patches")
PY
}
for r in 1 2 3; do
  echo "═══════ جولة $r ═══════"
  fix_all
  B=$(cd MAL/tools/malc-native && cargo build --release 2>&1)
  echo "$B" | grep -E "^error|Finished" | head -8
  echo "$B" | grep -q "^error" && { echo "$B" | grep -B2 -A8 "^error" | head -30; exit 1; }
  if $BIN MAL/examples/hello.mal -o /tmp/h 2>/tmp/e.txt; then
    echo "[PASS] hello"; /tmp/h; echo "🎉 Milestone 1 مكتمل!"; exit 0
  else
    echo "[FAIL] hello"; cat /tmp/e.txt
  fi
done
echo "[STOP] أرسل /tmp/duck.log"
SCRIPT
bash /root/ilm-al-kitab/duck.ai 2>&1 | tee /tmp/duck.log
