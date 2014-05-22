program mestras;

type
  TG = array [0 .. 251, 0 .. 251] of boolean;
  Teil = array [1 .. 252] of integer;

var
  g : TG;
  viso : integer;

procedure nuskaitymas (var viso : integer; var G : TG);
var
  f : text;
  pgx, pgy,
  pg, ck : integer;
begin
  assign (f, 'meistras.dat');
  reset (f);
  readln (f, viso, pg);
  for pgx := 0 to viso + 1 do
  for pgy := 0 to viso + 1 do
  g [pgx, pgy] := false;
  for ck := 1 to viso do
  begin
    readln (f, pgx, pgy);
    g [pgx, pgy] := true
  end;
  close (f)
end;

procedure PradPab (viso : Integer; var G : Tg);
var
  ckx, cky : integer;
  pg : boolean;
begin
  for ckY := 1 to viso do
  begin
    pg := true;
    for ckx := 1 to viso do
    if g [ckx, cky] then
    begin
      pg := false;
      break
    end;
    if pg then g [0, cky] := true
  end;
  for ckx := 1 to viso do
  begin
    pg := true;
    for cky := 1 to viso do
    if g [ckx, cky] then
    begin
      pg := false;
      break
    end;
    if pg then g [ckx, viso + 1] := true
  end
end;

procedure rasymas (ilg : integer; var eil : Teil);
var
  ck : Integer;
  f : text;
begin
  assign (f, 'meistras.rez');
  rewrite (f);
  for ck := 2 to ilg - 1 do
  write (f, eil [ck], ' ');
  close (f)
end;

function galima (v, nr : integer; var G : TG) : boolean;
var
  ok : boolean;
  ck : integer;
begin
  ok := true;
  for ck := 0 to viso + 1 do
  if (v <> ck) and (g [ck, nr]) then
  begin
    ok := false;
    break
  end;
  galima := ok
end;

procedure keliauk (viso : integer; g : TG);
var
  eil : Teil;
  eita : array [0 .. 251] of boolean;
  ck, pg,
  uod, gal : integer;
begin
  for ck := 1 to 251 do
  eita [ck] := false;
  gal := 1;
  uod := 2;
  eil [1] := 0;
  eita [0] := true;
  while gal < uod do
  begin
    for ck := 0 to viso do
    if g [eil [gal], ck] then
    begin
      g [eil [gal], ck] := false;
      if not eita [ck] and galima (eil [gal], ck, g) then
      begin
        eil [uod] := ck;
        eita [ck] := true;
        inc (uod)
      end
    end;
    inc (gal)
  end;
  rasymas (uod, eil)
end;

begin
  nuskaitymas (viso, g);
  PradPab (viso, g);
  Keliauk (viso, g)
end.
