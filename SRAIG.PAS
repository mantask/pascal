program sraige;

uses
  graph;

const
  l = 10;
  sp = 8;

var
  gd, gm : integer;
  pgS : real;

procedure sraig (n : byte; ilg, x1, y1, x2, y2, x3, y3 : word);
var
  pg : word;
begin
  if n = l then exit
  else
  begin
    putpixel (x1, y1, sp);
    putpixel (x2, y2, sp);
    putpixel (x3, y3, sp);
    pg := ilg div 6;

    sraig (n + 1, pg, )
  end
end;

begin
  initgraph (gd, gm, '');

  pgS := sqrt (3);
  sraig (0, 208, 215, 359, 423, 359, 319, 0);
  repeat until port [$60] <> 1;

  closegraph
end.