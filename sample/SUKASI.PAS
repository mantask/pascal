{ MK 2002 }

Program sukasi;

uses
  crt, graph;

const
  R = 100;
  sp1 = 9;
  sp2 = 14;

var
  x, y, ck, ck1,
  gd, gm : Integer;
  mas : array [0 .. 359, 1 .. 4] of integer;

begin
  initgraph (gd, gm, '');

  setcolor (0);
  for ck := 0 to 359 do
  begin
    mas [ck, 1] := 319 + Round (cos (ck / 180 * pi) * R);
    mas [ck, 2] := 239 + round (sin (ck / 180 * pi) * R);
    mas [ck, 3] := 319 + round (cos (ck / 180 * pi) * R / 7);
    mas [ck, 4] := 239 + round (sin (ck / 180 * pi) * R * 2);
    line (mas [ck, 3], mas [ck, 4], mas [ck, 1], mas [ck, 2])
  end;

  repeat
    setcolor (0);
    line (mas [ck, 3], mas [ck, 4],
          mas [ck, 1], mas [ck, 2]);
    ck := (ck + 1) mod 360;
    setcolor (sp1);
    line (mas [ck, 3], mas [ck, 4],
          mas [ck, 1], mas [ck, 2]);
    line (mas [(ck + 90) mod 360, 3], mas [(ck + 90) mod 360, 4],
          mas [(ck + 90) mod 360, 1], mas [(ck + 90) mod 360, 2]);
    putpixel (mas [(ck + 90) mod 360, 3], mas [(ck + 90) mod 360, 4], sp2);
    putpixel (mas [(ck + 90) mod 360, 1], mas [(ck + 90) mod 360, 2], sp2);
    delay (500)
  until port [$60] = 1;

  closegraph
end.