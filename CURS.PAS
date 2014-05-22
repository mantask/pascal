procedure HideCursor; assembler;
asm
  mov ah, 1
  mov ch, 20h
  int 10h
end;

procedure ShowCursor; assembler;
asm
  mov ah, 1
  mov ch, 1eh
  mov cl, 1fh
  int 10h
end;
