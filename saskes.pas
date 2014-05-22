{ MK 2002 }
{ XI Olimpiados 200 uØdavinys SASKES}
program saskes;

type
  Tlenta = array [1 .. 60, 1 .. 60] of -1 .. 2;
  Tkiek = array [1 .. 60, 1 .. 60] of integer;

var
  pg, xx, yy, kr : integer;
  lenta : Tlenta;
  kiek : Tkiek;

procedure nuskaitymas (var kr, xx, yy : Integer; var lenta : Tlenta);
var
  F : text;
  ck, pg, x, y : integer;
  c : char;
begin
  assign (f, 'saskes.dat');
  reset (f);
  readln (f, kr);
  for x := 1 to kr do
  for y := 1 to kr do
  if odd (x + y) then lenta [x, y] := 0
                 else lenta [x, y] := -1;
  readln (f, pg);
  for ck := 1 to pg do
  begin
    readln (f, c, x, y);
    if lenta [x, y] <> -1 then
    case c of
      'J' : lenta [x, y] := 1;
      'B' : lenta [x, y] := 2;
      'P' : begin xx := x; yy := y end
    end
  end;
  close (f)
end;

procedure paruosk (var kiek : Tkiek);
var
  ckx, cky : Integer;
begin
  for ckx := 1 to kr do
  for cky := 1 to kr do
  kiek [ckx, cky] := -1
end;

function max (sk1, sk2 : integer) : integer;
begin
  if sk1 > sk2 then max := sk1
               else max := sk2
end;

function paieska (x, y : integer; var kiek : Tkiek) : integer;
var
  pg, pg1, pg2 : integer;
begin
  if kiek [x, y] <> -1 then
  begin
    paieska := kiek [x, y];
    exit
  end;

  if (x > 2) and (y + 1 < kr) and
     (lenta [x - 1, y + 1] = 1) and (lenta [x - 2, y + 2] = 0)
  then pg1 := paieska (x - 2, y + 2, kiek) + 1
  else pg1 := 0;

  if (x + 2 < kr) and (y + 1 < kr) and
     (lenta [x + 1, y + 1] = 1) and (lenta [x + 2, y + 2] = 0)
  then pg2 := paieska (x + 2, y + 2, kiek) + 1
  else pg2 := 0;

  pg := max (pg1, pg2);
  kiek [x, y] := pg;
  paieska := pg
end;

procedure rasyk (sk : integer);
var
  F : text;
begin
  assign (f, 'saskes.rez');
  rewrite (f);
  writeln (f, sk);
  close (F)
end;

begin
  nuskaitymas (kr, xx, yy, lenta);
  paruosk (kiek);
  pg := paieska (xx, yy, kiek);
  rasyk (pg)
end.
