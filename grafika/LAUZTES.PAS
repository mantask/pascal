program lauztes;

uses
  graph, crt;

type
  Tmas = array [1 .. 4] of record
    x, y, k, d : integer
  end;
  Tkamp = array [0 .. 359] of real;

const
  ms = 1000; { delay }
  kiek = 10;
  xx = 629;
  yy = 469;

var
  m : array [1 .. kiek] of Tmas;
  kamp : Tkamp;
  pg, ck, gd, gm : Integer;

begin
  randomize;
  fillchar (m, sizeof (m), 0);
  for ck := 1 to 4 do
  with m [1][ck] do
  begin
    d := random (2) + 4;
    x := random (xx - 19) + 10;
    y := random (yy - 19) + 10;
    repeat
      k := random (360)
    until k mod 180 <> 90
  end;

  for ck := 0 to 359 do
  kamp [ck] := ck * pi / 180;

  initgraph (gd, gm, '');
  setcolor (7);
  rectangle (4, 4, 636, 476);
  repeat
    setcolor (0);
    for ck := 1 to 3 do
    line (m [kiek][ck].x, m [kiek][ck].y, m [kiek][ck + 1].x, m [kiek][ck + 1].y);
    line (m [kiek][1].x, m [kiek][1].y, m [kiek][4].x, m [kiek][4].y);

    for ck := kiek - 1 downto 1 do
    m [ck + 1] := m [ck];

    for ck := 1 to 4 do
    with m [1][ck] do
    begin
      if (x <= 10) or (x >= xx) or
         (y <= 10) or (y >= yy) then
      begin
        pg := k div 90;
        if k mod 90 > 0 then inc (pg);
        repeat
          k := (pg * 90 + random (k + 180 - pg * 90) + 1) mod 360
        until k mod 180 <> 90;
        d := random (2) + 4;
        if x <= 10 then x := 11;
        if x >= xx then x := xx - 1;
        if y <= 10 then y := 11;
        if y >= yy then y := yy - 1
      end;
      x := x + round (d * cos (kamp [k]));
      y := y + round (d * sin (kamp [k]))
    end;

    setcolor (12);
    for ck := 1 to 3 do
    line (m [1][ck].x, m [1][ck].y, m [1][ck + 1].x, m [1][ck + 1].y);
    line (m [1][1].x, m [1][1].y, m [1][4].x, m [1][4].y);
    delay (ms)
  until port [$60] = 1;
  closegraph
end.