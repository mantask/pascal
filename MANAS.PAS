program manas;
uses
  graph, man;

procedure delay (ms : Word); Assembler;
asm
  mov ax, 1000;
  mul ms;
  mov cx, dx;
  mov dx, ax;
  mov ah, $86;
  Int $15;
end;

var
  ck : byte;
  gd, gm : integer;
  z : Tman;

begin
  initgraph (gd, gm, '');

  z.create;
  while port [$60] <> 1 do
  begin
    z.piesk (300, 400, 0);
    z.pasukasis (30);
    z.piesk (300, 400, 9);
    delay (500)
  end;

  closegraph;
end.