{ MK 2002 }
{ XII Olimp 224 uzdav LENTA }
program lenta2;

type
  Tlenta = array [1 .. 50, 1 .. 50] of integer;

var
  lenta : Tlenta;
  xx, yy : byte;

procedure nuskaitymas (var xx, yy : byte; var Lenta : Tlenta);
var
  pgx, pgy, pg, ck : Integer;
  f : text;
begin
  assign (f, 'lenta.dat');
  reset (f);
  readln (f, xx, yy);
  readln (f, pg);
  for pgx := 1 to xx do
  for pgy := 1 to yy do
  lenta [pgx, pgy] := 0;
  for ck := 1 to pg do
  begin
    readln (f, pgx, pgY);
    lenta [pgx, pgy] := -1
  end;
  close (f)
end;

function banga (var x, y : byte; var lenta : Tlenta) : integer;
var
  jau : array [1 .. 50, 1 .. 50] of boolean;
  eil : array [1 .. 2500] of record
    x, y : 1 .. 50
  end;
  max, gal, uod : integer;
  ckx, cky : byte;
begin
  for ckx := 1 to xx do
  for cky := 1 to yy do
  jau [ckx, cky] := false;
  max := 0;
  gal := 1;
  uod := 2;
  eil [1].x := x;
  eil [1].y := y;
  jau [x, y] := true;
  ckx := x;
  cky := y;
  while gal < uod do
  begin
    x := eil [gal].x;
    y := eil [gal].y;
    if (x + 1 <= xx) and (lenta [x + 1, y] < lenta [x, y] + 1) then
    begin
      if lenta [x, y] + 1 > max then
      begin
        max := lenta [x, y] + 1;
        ckx := x + 1;
        cky := y
      end;
      lenta [x + 1, y] := lenta [x, y] + 1;
      if not jau [x + 1, y] then
      begin
        jau [x + 1, y] := true;
        eil [uod].x := x + 1;
        eil [uod].y := y;
        inc (uod)
      end
    end;
    if (y + 1 <= yy) and (lenta [x, y + 1] < lenta [x, y] + 1) then
    begin
      if lenta [x, y] + 1 > max then
      begin
        max := lenta [x, y] + 1;
        ckx := x;
        cky := y + 1
      end;
      lenta [x, y + 1] := lenta [x, y] + 1;
      if not jau [x, y + 1] then
      begin
        jau [x, y + 1] := true;
        eil [uod].x := x;
        eil [uod].y := y + 1;
        inc (uod)
      end
    end;
    if (x - 1 >= 1) and (lenta [x - 1, y] < lenta [x, y] + 1) then
    begin
      if lenta [x, y] + 1 > max then
      begin
        max := lenta [x, y] + 1;
        ckx := x - 1;
        cky := y
      end;
      lenta [x - 1, y] := lenta [x, y] + 1;
      if not jau [x - 1, y] then
      begin
        jau [x - 1, y] := true;
        eil [uod].x := x - 1;
        eil [uod].y := y;
        inc (uod)
      end
    end;
    if (y - 1 >= 1) and (lenta [x, y - 1] < lenta [x, y] + 1) then
    begin
      if lenta [x, y] + 1 > max then
      begin
        max := lenta [x, y] + 1;
        ckx := x;
        cky := y - 1
      end;
      lenta [x, y - 1] := lenta [x, y] + 1;
      if not jau [x, y - 1] then
      begin
        jau [x, y - 1] := true;
        eil [uod].x := x;
        eil [uod].y := y - 1;
        inc (uod)
      end
    end;
    inc (gal)
  end;
  banga := max;
  x := ckx;
  y := cky
end;

procedure atgal (x, y : byte; var lenta : Tlenta);
begin
  if lenta [x, y] <> 0 then
  begin
    lenta [x, y] := -1;
    if (x + 1 <= xx) and (lenta [x + 1, y] + 1 = lenta [x, y])
    then atgal (x + 1, y, lenta) else
    if (x - 1 >= 1) and (lenta [x - 1, y] + 1 = lenta [x, y])
    then atgal (x - 1, y, lenta) else
    if (y + 1 <= yy) and (lenta [x, y + 1] + 1 = lenta [x, y])
    then Atgal (x, y + 1, lenta) else
    if (y - 1 >= 1) and (lenta [x, y - 1] + 1 = lenta [x, y])
    then atgal (x, y - 1, lenta)
  end
end;

procedure valymas (var lenta : Tlenta);
var
  ckx, cky : integer;
begin
  for ckx := 1 to xx do
  for cky := 1 to yy do
  if lenta [ckx, cky] > 0 then lenta [ckx, cky] := 0
end;

function paieska (var lenta : Tlenta) : integer;
var
  pgx, pgy,
  ckx, cky : byte;
  viso, ilg : integer;
begin
  viso := 0;
  for ckx := 1 to xx do
  for cky := 1 to yy do
  if lenta [ckx, cky] > -1 then
  begin
    pgx := ckx;
    pgy := cky;
    ilg := banga (pgx, pgy, lenta);
    atgal (ckx, cky, lenta);
    pgx := ckx;
    pgy := cky;
    ilg := ilg + banga (ckx, cky, lenta);
    atgal (ckx, cky, lenta);
    viso := viso + ilg div 2
  end;
  paieska := viso
end;

begin
  nuskaitymas (xx, yy, lenta);
  writeln (paieska (lenta))
end.