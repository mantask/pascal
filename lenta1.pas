{ MK 2002 }
{ XII Olimpiados 224 uzdavinys LENTA }
{ nera teisingas algoritmas, reikia taikyti grafo virsunio poru algoritma }

program lentaMAS;

type
  Tlenta = array [1 .. 50, 1 .. 50] of integer;

var
  xx, yy : integer;
  lenta : Tlenta;

procedure  nuskaitymas (var xx, yy : integer; var lenta : Tlenta);
var
  f : text;
  pgx, pgy, ck, pg : integer;
begin
  assign (f, 'lenta.dat');
  reset (f);
  readln (f, xx, yy);
  for pgx := 1 to xx do
  for pgy := 1 to yy do
  lenta [pgx, pgy] := 0;
  readln (f, pg);
  for ck := 1 to pg do
  begin
    readln (f, pgx, pgy);
    lenta [pgx, pgy] := -1;
  end;
  close (f)
end;

procedure zymek (var lenta : Tlenta);
var
  ckx, cky : Integer;
begin
  for ckx := 1 to xx do
  for cky := 1 to yy do
  if lenta [ckx, cky] <> -1 then
  begin
    if (ckx - 1 >= 1) and (lenta [ckx - 1, cky] > -1) then inc (lenta [ckx, cky]);
    if (cky - 1 >= 1) and (lenta [ckx, cky - 1] > -1) then inc (lenta [ckx, cky]);
    if (ckx + 1 <= xx) and (lenta [ckx + 1, cky] > -1) then inc (lenta [ckx, cky]);
    if (cky + 1 <= yy) and (lenta [ckx, cky + 1] > -1) then inc (lenta [ckx, cky])
  end
end;

procedure min (var x, y : integer; var lenta : Tlenta);
var
  pgx, pgy, ckx, cky : integer;
begin
  pgx := 0;
  pgy := 0;
  for ckx := 1 to xx do
  for cky := 1 to yy do
  if (lenta [ckx, cky] <> -1) and ((pgx = 0) and (pgy = 0) or
     (lenta [ckx, cky] < lenta [pgx, pgy])) then
  begin
    pgx := ckx;
    pgy := cky
  end;
  x := pgx;
  y := pgy
end;

procedure valyk (var maz, x, y : integer; var lenta : Tlenta);
var
  pgx, pgy : integer;
begin
  maz := 1;
  pgx := x;
  pgy := y;
  if (x - 1 >= 1) and (lenta [x - 1, y] > -1) and
    ((pgx = x) and (pgy = y) or (lenta [x - 1, y] < lenta [pgx, pgy])) then
  begin
    pgx := x - 1;
    pgy := y;
    maz := 2
  end;
  if (x + 1 <= xx) and (lenta [x + 1, y] > -1) and
    ((pgx = x) and (pgy = y) or (lenta [x + 1, y] < lenta [pgx, pgy])) then
  begin
    pgx := x + 1;
    pgy := y;
    maz := 2
  end;
  if (y - 1 >= 1) and (lenta [x, y - 1] > -1) and
    ((pgx = x) and (pgy = y) or (lenta [x, y - 1] < lenta [pgx, pgy])) then
  begin
    pgy := y - 1;
    pgx := x;
    maz := 2
  end;
  if (y + 1 <= yy) and (lenta [x, y + 1] > -1) and
    ((pgx = x) and (pgy = y) or (lenta [x, y + 1] < lenta [pgx, pgy])) then
  begin
    pgy := y + 1;
    pgx := x;
    maz := 2
  end;
  lenta [x, y] := -1;
  if (pgx <> x) or (pgy <> y) then
  begin
    lenta [pgx, pgy] := -1;
  end
end;

function rask (var lenta : TLenta) : integer;
var
  ckx, cky, sk, maz, viso : integer;
begin
  viso := 0;
  for ckx := 1 to xx do
  for cky := 1 to yy do
  if lenta  [ckx, cky] > -1 then inc (viso);

  sk := 0;
  while viso > 0 do
  begin
    min (ckx, cky, lenta);
    valyk (maz, ckx, cky, lenta);
    dec (viso, maz);
    if maz = 2 then inc (sk)
  end;
  rask := sk
end;

begin
  nuskaitymas (xx, yy, lenta);
  zymek (lenta);
  writeln (rask (lenta))
end.
