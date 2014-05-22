{ Mantas Kanaporis           }
{ Vilniaus Zemynos gimnazija }
{ IVe klase                  }
{ ========================== }
{ III metu III skyriaus uzd. }
{ barjerai                   }

Program MIESTAI;

const
  viso = 50;

type
  Tvirs = array [1 .. viso, 1 .. 4] of real;
  Tg = array [0 .. viso * 2 + 1, 0 .. viso * 2 + 1] of real;

var
  virs : Tvirs;
  g : TG;
  ats : real;

procedure nuskaitymas (var virs : Tvirs);
var
  f : Text;
  ck : Integer;
begin
  assign (f, 'duom.txt');
  reset (f);
  for ck := 1 to viso do
  readln (f, virs [ck, 1], virs [ck, 2], virs [ck, 3], virs [ck, 4]);
  close (f)
end;

function kerta (xx1, yy1, xx2, yy2 : real; n : integer) : boolean;
var
  z1, z2, x1, y1, x2, y2, x3, y3 : real;
begin
  x1 := virs [n, 1] - xx1;
  y1 := virs [n, 2] - yy1;
  x2 := xx2 - xx1;
  y2 := yy2 - yy1;
  x3 := virs [n, 3] - xx1;
  y3 := virs [n, 4] - yy1;
  z1 := x1 * y2 - x2 * y1;
  z2 := x3 * y2 - x2 * y3;
  if z1 * z2 >= 0 then
  begin
    kerta := false;
    exit
  end;
  x1 := xx1 - virs [n, 3];
  y1 := yy1 - virs [n, 4];
  x2 := virs [n, 1] - virs [n, 3];
  y2 := virs [n, 2] - virs [n, 4];
  x3 := xx2 - virs [n, 3];
  y3 := yy2 - virs [n, 4];
  z1 := x1 * y2 - x2 * y1;
  z2 := x3 * y2 - x2 * y3;
  if z1 * z2 >= 0 then
  begin
    kerta := false;
    exit
  end;
  kerta := true
end;

function galima (x1, y1, x2, y2 : real) : boolean;
var
  ck : Integer;
begin
  for ck := 1 to viso do
  if kerta (x1, y1, x2, y2, ck) then
  begin
    galima := false;
    exit
  end;
  galima := true
end;

procedure formuok (var g : Tg);
var
  ck1, ck2 : integer;
  pg : real;
begin
  fillchar (g, sizeof (g), 0);
  if galima (0, 0, 100, 100) then
  begin
    g [0, viso * 2 + 1] := 100 * sqrt (2);
    g [viso * 2 + 1, 0] := 100 * sqrt (2);
    exit
  end;

  for ck2 := 1 to viso do
  begin
    if galima (0, 0, virs [ck2, 1], virs [ck2, 2])
    then g [0, ck2 * 2 - 1] := sqrt (sqr (virs [ck2, 1]) + sqr (virs [ck2, 2]));
    if galima (0, 0, virs [ck2, 3], virs [ck2, 4])
    then g [0, ck2 * 2] := sqrt (sqr (virs [ck2, 3]) + sqr (virs [ck2, 4]));
  end;
  for ck1 := 1 to viso do
  begin
    for ck2 := ck1 + 1 to viso do
    begin
      if galima (virs [ck1, 1], virs [ck1, 2], virs [ck2, 1], virs [ck2, 2]) then
      begin
        pg := sqrt (sqr (virs [ck1, 1] - virs [ck2, 1]) + sqr (virs [ck1, 2] - virs [ck2, 2]));
        g [ck1 * 2 - 1, ck2 * 2 - 1] := pg;
        g [ck2 * 2 - 1, ck1 * 2 - 1] := pg
      end;
      if galima (virs [ck1, 1], virs [ck1, 2], virs [ck2, 3], virs [ck2, 4]) then
      begin
        pg := sqrt (sqr (virs [ck1, 1] - virs [ck2, 3]) + sqr (virs [ck1, 2] - virs [ck2, 4]));
        g [ck1 * 2 - 1, ck2 * 2] := pg;
        g [ck2 * 2, ck1 * 2 - 1] := pg
      end;
      if galima (virs [ck1, 3], virs [ck1, 4], virs [ck2, 1], virs [ck2, 2]) then
      begin
        pg := sqrt (sqr (virs [ck1, 3] - virs [ck2, 1]) + sqr (virs [ck1, 4] - virs [ck2, 2]));
        g [ck1 * 2, ck2 * 2 - 1] := pg;
        g [ck2 * 2 - 1, ck1 * 2] := pg
      end;
      if galima (virs [ck1, 3], virs [ck1, 4], virs [ck2, 3], virs [ck2, 4]) then
      begin
        pg := sqrt (sqr (virs [ck1, 3] - virs [ck2, 3]) + sqr (virs [ck1, 4] - virs [ck2, 4]));
        g [ck1 * 2, ck2 * 2] := pg;
        g [ck2 * 2, ck1 * 2] := pg
      end
    end;
    if galima (virs [ck1, 1], virs [ck1, 2], 100, 100)
    then g [ck1 * 2 - 1, viso * 2 + 1] := sqrt (sqr (100 - virs [ck1, 1]) + sqr (100 - virs [ck1, 2]));
    if galima (virs [ck1, 3], virs [ck1, 4], 100, 100)
    then g [ck1 * 2 , viso * 2 + 1] := sqrt (sqr (100 - virs [ck1, 3]) + sqr (100 - virs [ck1, 4]))
  end
end;

function rask : real;
var
  jau : array [0 .. viso * 2 + 1] of boolean;
  ats : array [0 .. viso * 2 + 1] of real;
  n, ck : Integer;
begin
  fillchar (jau, sizeof (jau), 0);
  for ck := 0 to viso * 2 + 1 do
  ats [ck] := -1;
  ats [0] := 0;
  while not jau [viso * 2 + 1] do
  begin
    n := -1;
    for ck := 0 to viso * 2 + 1 do
    if not jau [ck] and (ats [ck] <> -1) and ((n = -1) or (ats [ck] < ats [n]))
    then n := ck;

    if n = -1 then break;

    jau [n] := true;
    for ck := 1 to viso * 2 + 1 do
    if not jau [ck] and (g [n, ck] <> 0) and
       ((ats [ck] = -1) or (ats [ck] > ats [n] + g [n, ck]))
    then ats [ck] := ats [n] + g [n, ck]
  end;
  rask := ats [ck]
end;

procedure rasymas (ats : Real);
var
  f : text;
begin
  assign (f, 'rez.txt');
  rewrite (f);
  writeln (f, ats :1 :2);
  close (f)
end;

begin
  nuskaitymas (virs);
  formuok (g);
  ats := rask;
  rasymas (ats)
end.