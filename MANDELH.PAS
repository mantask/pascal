program Mandelbroto_aibe;

uses
  sp_graph;

const
  maxsp : byte = 255;
  minx ={ -2   }  -0.2100050;
  maxx ={ 1.25 }  -0.2100055;
  miny ={ -1.25}  -0.8200050;
  maxy ={ 1.25 }  -0.8200055;

var
  ckx, cky : integer;
  sp : byte;
  pgx, pgy : real;

function mand (x, y : real) : byte;
var
  ck : byte;
  sa, a, b,
  z : real;
begin
  ck := 0; a := 0; b := 0;
  repeat
    sa := a;
    a := sqr (a) - sqr (b) + x;
    b := 2 * sa * b + y;
    z := sqr (a) + sqr (b);
    inc (ck)
  until (z > 4) or (ck >= maxsp);
  mand := ck
end;

begin
  initgraph (v1280x1024x256);

  for ckx := 0 to 255 do
  setpal (ckx, (64 - ckx div 4), 64 - ckx div 4, ckx div 8);

  pgx := (maxx - minx) / 1280;
  pgy := (maxy - miny) / 1024;
  for ckY := 0 to 1023 do
  for ckx := 0 to 1279 do
  putpixel (ckx, cky, mand (minx + pgx * ckx, miny + pgy * cky));

  repeat until port [$60] = 1;
  closegraph
end.