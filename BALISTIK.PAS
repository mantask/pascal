program balistika;

uses
  graph, crt;

Const
  g = 10;
  v0 = 50;
  alfa : real = 80;
  mx = 639;
  my = 479;

var
  gd, gm,
  t, ck : integer;

function sx (t : real) : integer;
begin
  sx := round (v0 * cos (alfa) * t);
end;

function sy (t : real) : integer;
begin
  sy := round (v0 * sin (alfa) * t - g * sqr (t) / 2);
end;

begin
  alfa := alfa * pi / 180;
  initgraph (gd, gm, '');

  t := round (2 * sin (alfa) * v0 / g);
  for ck := 0 to t * 20 do
  begin
    putpixel (sx (ck / 20), my - 100 - sy (ck / 20), 7);
    delay (1000);
  end;

  repeat until port [$60] = 1;
  closegraph;
end.