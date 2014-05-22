program sekantas;

uses
  graph;
var
  x, y : longint;
  ck : word;
  gm, gd : integer;

function sec (a : real) : real;
begin
  sec := 1 / (cos (a))
end;

function cosec (a : real) : real;
begin
  cosec := 1 / (sin (a))
end;

BEGIN
  initgraph (gm, gd, '');
  for x := 0 to 639 do
  begin
    y := round (sec (x / 100) * 20);
    putpixel (x, y, 15)
  end;
  repeat until port [$60] = 1;
  closegraph;
END.