var
  x, y: word;
begin
  asm
    mov ax, 13h
    int 10h
  end;
  for y:=0 to 199 do
    for x:=0 to 319 do
      mem[$a000:320*y+x]:=x;
 readln;
 
end.