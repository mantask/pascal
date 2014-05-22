{ MK 2002 }

program sraige;

uses
  graph;

const
  lygis = 10;
  D = 200;

var
  sp, cx, cy, x, y, laips, R,
  ck1, ck, gd, gm : Integer;
  rad : Array [0 .. 359] of real;
  pg : boolean;

begin
  for ck := 0 to 359 do
  rad [ck] := ck * pi / 180;

  cx := 319;
  cy := 239;
  laips := 0;
  sp := 0;
  r := d;
  pg := true;
  initgraph (gd, gm, '');
  for ck := 1 to lygis do
  begin
    sp := (sp + 1) mod 16;
    setcolor (sp);
    for ck1 := 1 to 180 do
    begin
      laips := (laips + 1) mod 360;
      x := round (R * sin (RAD [laips]));
      y := round (R * cos (RAD [laips]));
{      putpixel (x + cx, y + cy, sp)}
      line (cx, cy, cx + x, cy + y)
    end;
    R := r div 2;
    if pg then cy := cy + R
          else cy := cy - R;
    pg := not pg
  end;

  repeat until port [$60] = 1;
  closegraph
end.