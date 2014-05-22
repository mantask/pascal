program zmogus;

uses
  graph;

const
  cx = 319;
  cy = 219;
  lin : array [1 .. 16, 1 .. 2] of byte =
  ((1,2),(1,3),(2,3),(3,4),(3,5),(4,6),(6,8),(5,7),(7,9),
   (4,10),(5,11),(10,11),(10,12),(12,14),(11,13),(13,15));
  virs : array [1 .. 15, 1 .. 3] of integer =
  ((15,100,0),(25,100,0),(20,86,0),(5,80,0),(35,80,0),(0,53,0),(40,53,0),
  (0,33,0),(40,33,0),(15,43,0),(25,43,0),(15,22,0),(25,22,0),(15,0,0),(25,0,0));

var
  gd, gm : integer;
  alfa : word;

procedure delay (ms : Word); Assembler;
asm
  mov ax, 1000;
  mul ms;
  mov cx, dx;
  mov dx, ax;
  mov ah, $86;
  Int $15;
end;

Procedure waitRetrace; Assembler;
asm
   mov dx,3DAh
@@1:
   in al,dx
   and al,08h
   jnz @@1
@@2:
   in al,dx
   and al,08h
   jz  @@2
end;

procedure Piesk (sp : byte);
var
  ck : byte;
begin
  setcolor (sp);
  for ck := 1 to 16 do
  line (cx + virs [lin [ck,1],1], cy - virs [lin [ck,1],2], cx + virs [lin [ck, 2],1], cy - virs [lin [ck, 2],2])
end;

procedure ranka_suk (var x, y : integer; alfa : word);
var
  pg : real;
begin
  pg := abs (180 - alfa) * pi / 180;
  x := virs [6, 1] + round (cos (pg) * 20);
  y := virs [7, 2] + round (sin (pg) * 20)
end;

begin
  initgraph (gd, gm, '');

  repeat
    alfa := (alfa + 30) mod 360;
    piesk (0);
    RANKA_suk (virs [8, 1], virs [8, 2], alfa);
    piesk (8);
    waitretrace;
    delay (100)
  until port [$60] = 1;

  closegraph
end.