program kanap072;
uses
  crt, graph;
var
  gm, gd : integer;

procedure spirale (cx, cy : integer; sp : word);
const
  z = 175;
var
  r, x, y : integer;
  i : 1 .. 360;
  j : 1 .. 5;
begin
  r := 1;
  repeat
    for i := 1 to 360 do
    begin
      for j := 1 to 5 do
      begin
        x := round (cx + cos ((i + 0.2 * j) * pi / 180) * r);
        y := round (cy + sin ((i + 0.2 * j) * pi / 180) * r);
        putpixel (x, y, sp);
      end;
      if i mod z = 0 then inc (r)
    end;
  until keypressed
end;

begin
  initgraph (gm, gd, '');
  spirale (319, 239, 10);
  closegraph;
end.