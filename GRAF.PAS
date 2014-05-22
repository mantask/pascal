program grafics;

var
  CK,
  x, y : word;

procedure delay (ms : Word); Assembler;
asm
  mov ax, 1000;
  mul ms;
  mov cx, dx;
  mov dx, ax;
  mov ah, $86;
  Int $15;
end;

procedure putpixel (x, y : word; sp : byte);
begin
  mem [$A000 : 320 * y + x] := sp
end;

procedure setpal (nr, R, G, B : byte);
begin
  port [$3C8] := nr;
  port [$3C9] := R;
  port [$3C9] := G;
  port [$3C9] := B
end;

begin
  asm
    mov  ax, 13h
    int 10h
  end;

  for ck := 1 to 63 do
  setpal (ck, ck div 5, ck div 3, ck);

  repeat until port [$60] = 57;

  while port [$60] = 57 do
  begin
    inc (x);
    if x > 63 then break;
    for ck := 0 to 10 do putpixel (x, 199 - ck, x);
    delay (10)
   end;

  asm
    mov  ax, 3h
    int 10h
  end
end.
