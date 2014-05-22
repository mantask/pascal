uses Crt, Dos;
var
  KbdIntVec : Procedure;
{$F+}
procedure Keyclick; interrupt;
label
  m2, m3, m4, m5;
begin
  if Port [$60] = 178 then
  asm
    mov ah, 5
    mov cl, 'a'
    int 16h
    mov cx, 2000h
M2: loop m2
    mov ah, 5
    mov cl, 'n'
    int 16h
    mov cx, 2000h
M3: loop m3
    mov ah, 5
    mov cl, 't'
    int 16h
    mov cx, 2000h
M4: loop m4
    mov ah, 5
    mov cl, 'a'
    int 16h
    mov cx, 2000h
M5: loop m5
    mov ah, 5
    mov cl, 's'
    int 16h
  end;
  inline ($9C);
  KbdIntVec;
end;
{$F-}
begin
  { Insert ISR into keyboard chain }
  GetIntVec($9,@KbdIntVec);
  SetIntVec($9,Addr(Keyclick));
  Keep(0); { Terminate, stay resident }
end.

