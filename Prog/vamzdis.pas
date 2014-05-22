{ MK 2002 }
{ Minimalaus srauto realizavimas }

program vamzdis;

const
  max = 10;

type
  Tg = array [0 .. Max + 1, 0 .. max + 1] of integer;
  Teil = array [0 .. 2 * max] of integer;
  Taib = set of 1 .. max;

var
  viso : integer;
  g : Tg;

procedure nuskaitymas (var viso : integer; var g : TG);
var
  f : text;
  x, y, pg, kiek, ck : integer;
begin
  assign (f, 'vamzdis.dat');
  reset (f);
  readln (f, viso, kiek);
  for x := 0 to viso + 1 do
  for y := 0 to viso + 1 do
  g [x, y] := -1;
  for ck := 1 to kiek do
  begin
    readln (f, x, y, pg);
    g [x, y] := pg
  end;
  close (f)
end;

procedure PradPab (viso : integer; var G : Tg);
var
  ckx, cky : Integer;
  ok : boolean;
begin
  for cky := 1 to viso do
  begin
    ok := true;
    for ckx := 1 to viso do
    if (ckx <> cky) and (g [ckx, cky] > -1) then ok := false;
    if ok then g [0, cky] := 1000
  end;
  for ckx := 1 to viso do
  begin
    ok := true;
    for cky := 1 to viso do
    if (ckx <> cky) and (g [ckx, cky] > - 1) then ok := false;
    if ok then g [ckx, viso + 1] := 1000
  end
end;

procedure pakelk (v : integer; var h : TEil; var sr : TG);
var
  galima : boolean;
  ck, pg : integer;
begin
  galima := true;
  pg := -1;
  for ck := 0 to viso + 1 do
  if (g [v, ck] > sr [v, ck]) or (sr [v, ck] = -1) then
  if h [ck] < h [v] then galima := false
  else if (pg = -1) or (h [ck] < h [pg]) then pg := ck;

  if galima then
  begin
    h [v] := h [pg] + 1
  end
end;

function min (sk1, sk2 : integer) : integer;
begin
  if sk1 < sk2 then min := sk1
               else min := sk2
end;

procedure paleisk (v : integer; var sr : TG; var uod : Integer;
                   var Bak, eil, h : Teil; var aib : Taib);
var
  pg, ck : integer;
begin
  for ck := 0 to viso + 1 do
  if (h [ck] + 1 = h [v]) and ((g [v, ck] > sr [v, ck]) or (sr [v, ck] = -1))
  then
  begin
    pg := min (bak [v], g [v, ck] - sr [v, ck]);
    bak [ck] := bak [ck] + pg;
    bak [v] := bak [v] - pg;
    sr [v, ck] := sr [v, ck] + pg;
    sr [ck, v] := -sr [v, ck];
    if (bak [ck] <> 0) and (ck <> 0) and (ck <> viso + 1) then
    begin
      eil [uod] := ck;
      uod := (uod + 1) mod (viso + 1);
      aib := aib + [ck]
    end
  end;
end;

procedure srautai (viso : integer; var G : tg);
var
  sr : TG;
  bak, h, eil : Teil;
  aib : Taib;
  ck, gal, uod, pg : integer;
begin
  for ck := 0 to viso + 1 do
  begin
    bak [ck] := 0;
    h [ck] := 0;
    eil [ck] := 0
  end;
  fillchar (sr, sizeof (sr), 0);
  aib := [];
  gal := 0;
  uod := 0;
  h [0] := viso + 1;

  for ck := 1 to viso do
  if g [0, ck] <> -1 then
  begin
    aib := aib + [ck];
    eil [uod] := ck;
    uod := (uod + 1) mod (viso + 1);
    bak [ck] := g [0, ck];
    sr [0, ck] := g [0, ck];
    sr [ck, 0] := -g [0, ck]
  end;

  while aib <> [] do
  begin
    pg := eil [gal];
    gal := (gal + 1) mod (viso + 1);
    aib := aib - [pg];
    while bak [pg] <> 0 do
    begin
      pakelk (pg, h, sr);
      paleisk (pg, sr, uod, bak, eil, h, aib)
    end
  end;
  writeln (bak [viso + 1])
end;

begin
  nuskaitymas (viso, g);
  PradPab (viso, g);
  srautai (viso, g);
  readln
end.
