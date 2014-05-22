program meistras;

Type
  Tg = array [0 .. 251, 0 .. 251] of boolean;
  Teil = array [1 .. 252] of integer;

var
  G : TG;
  viso, ilg : integer;
  eil : Teil;

procedure nuskaitymas (var viso : Integer; var G : TG);
var
  f : Text;
  pg, ck, ckx, cky : Integer;
begin
  assign (f, 'meistras.dat');
  reset (f);
  readln (f, viso, pg);
  for ckx := 1 to viso do
  for cky := 1 to viso do
  G [ckx, cky] := false;
  for ck := 1 to pg do
  begin
    readln (f, ckx, cky);
    g [ckx, cky] := true
  end;
  close (f)
end;

procedure PradPab (viso : Integer; var G : TG);
var
  ckx, cky : integer;
  OK : boolean;
begin
  { surasom pabaigas }
  for ckx := 1 to viso do
  begin
    OK := true;
    for cky := 1 to viso do
    if g [ckx, cky] then ok := false;
    if OK then g [ckx, viso + 1] := true
  end;
  { surasom pradzias }
  for cky := 1 to viso do
  begin
    ok := true;
    for ckx := 1 to viso do
    if g [ckx, cky] then ok := false;
    if OK then g [0, cky] := true
  end
end;

function galima (virs : Integer) : boolean;
var
  ck : Integer;
  ok : boolean;
begin
  ok := true;
  for ck := 1 to viso + 1 do
  if g [ck, virs] then
  begin
    ok := false;
    break
  end;
  galima := ok
end;

procedure kelias (viso : integer; var G : TG; var eil : Teil; var ilg : integer);
var
  ck, gal, uod : integer;
begin
  eil [1] := 0;
  gal := 1;
  uod := 2;
  while Gal < Uod do
  begin
    for ck := 1 to viso + 1 do
    if g [eil [gal], ck] then
    begin
      g [eil [gal], ck] := false;
      if galima (ck) then
      begin
        eil [uod] := ck;
        inc (uod)
      end
    end;
    inc (gal)
  end;
  ilg := gal - 1
end;

procedure rasymas (viso, ilg : Integer; eil : Teil);
var
  f : Text;
  ck : integer;
begin
  assign (f, 'meistras.rez');
  rewrite (f);
  for ck := 2 to ilg do
  if eil [ck] <> viso + 1 then write (f, eil [ck], ' ');
  close (f)
end;

begin
  nuskaitymas (viso, g);
  pradPab (viso, g);
  kelias (viso, g, eil, ilg);
  rasymas (viso, ilg, eil)
end.