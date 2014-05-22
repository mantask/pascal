program trikampis;

uses
  graph;

const
  sp = 9;
  l = 10;

var
  gd, gm : integer;

procedure trik (n : byte; x1, y1, x2, y2, x3, y3 : word);
var
  xx1, xx2, xx3, yy1, yy2, yy3 : word;
begin
  if n = l then exit
  else
  begin
    putpixel (x1, y1, sp);
    putpixel (x2, y2, sp);
    putpixel (x3, y3, sp);
    xx1 := (x2 + x1) div 2; yy1 := (y2 + y1) div 2;
    xx2 := (x2 + x3) div 2; yy2 := (y2 + y3) div 2;
    xx3 := (x3 + x1) div 2; yy3 := (y3 + y1) div 2;
    trik (n + 1, x1, y1, xx1, yy1, xx3, yy3);
    trik (n + 1, xx1, yy1, x2, y2, xx2, yy2);
    trik (n + 1, xx3, yy3, xx2, yy2, x3, y3);
  end;
end;

begin
  initgraph (gd, gm, '');

  trik (0, 0, 479, 639, 479, 319, 0);
  repeat until port [$60] = 1;

  closegraph
end.