program palete1;

var
  y, ck : word;

begin
  asm
    mov  ax, 13h
    int  10h
  end;

  for ck := 0 to 255 do
  begin
    port [$3C8] := ck;
    port [$3C9] := ck div 2;
    port [$3C9] := ck div 2;
    port [$3C9] := ck div 2;
  end;

  for y := 0 to 199 do
  for ck := 0 to 255 do
  mem [$a000 : 320 * y + ck] := ck;

  repeat until port [$60] = 1;

  asm
    mov  ax, 3h
    int  10h
  end
end.