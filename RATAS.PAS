program cha;

uses
  graph;

var
  ck : byte;
  R, x, Y, alfa,
  gd, gm : integer;
  pg : real;

procedure delay (ms : Word); Assembler;
asm
  mov ax, 1000;
  mul ms;
  mov cx, dx;
  mov dx, ax;
  mov ah, $86;
  Int $15;
end;

begin
  initgraph (gd, gm, '');

  r := 100;
  for alfa := 0 to 15 do
  begin
    pg := alfa * pi * 0.125;
    x := round (cos (pg) * R);
    y := round (sin (pg) * R);
    setcolor (alfa);
    line (319, 239, x + 319, y + 239);
  end;

  for ck := 0 to 63 do
  setRGBpalette (ck, 0, 0, 0);

  r := 0;
  repeat
    setRGBpalette (r, 0, 0, 0);
    r := r mod 15 + 1;
    setRGBpalette (r, 0, 63, 0);
    delay (100);
  until port [$60] = 1;
  closegraph
end.