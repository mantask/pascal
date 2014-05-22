{ MK 2002 }
{ III Olimpiados 19 uzd. }
program langeliai;

type
  Tlent = array [1 .. 100, 1 .. 100] of integer;

var
  lent : TLent;
  pg,
  ckx, cky,
  xx, yy : integer;

procedure nuskaitymas (var x, y : integer; var lent : TLent);
var
  c : char;
  pg, ck, ckx, cky : integer;
  f : text;
begin
  assign (f, 'din_lang.dat');
  reset (f);
  readln (f, y, x);
  for ckx := 1 to x do
  for cky := 1 to y do
  lent [ckx, cky] := 0;
  readln (f, pg);
  for ck := 1 to pg do
  begin
    readln (f, ckx, cky);
    lent [ckx, cky] := -1
  end;
  close (f)
end;

function max (x, y : Integer) : integer;
begin
  if (lent [x - 1, y - 1] = -1) or
     (lent [x - 1, y] = -1) or
     (lent [x, y - 1] = -1)
  then max := 1
  else
  begin
    if (lent [x - 1, y] <= lent [x - 1, y - 1]) and
       (lent [x - 1, y] <= lent [x, y - 1])
    then max := lent [x - 1, y] + 1
    else if lent [x, y - 1] <= lent [x - 1, y - 1]
         then max := lent [x, y - 1] + 1
         else max := lent [x - 1, y - 1] + 1
  end
end;

begin
  nuskaitymas (xx, yy, lent);

  { ribiniai atvejai }
  for ckx := 1 to xx do
  if lent [ckx, 1] <> -1 then lent [ckx, 1] := 1;
  for cky := 1 to yy do
  if lent [1, cky] <> -1 then lent [1, cky] := 1;

  { pagrindinis lenteles pildymas is apacios }
  pg := -maxint;
  for cky := 2 to yy do
  for ckx := 2 to xx do
  begin
    if lent [ckx, cky] <> -1 then lent [ckx, cky] := max (ckx, cky);
    if lent [ckx, cky] > pg then pg := lent [ckx, cky]
  end;

  writeln (pg)
end.