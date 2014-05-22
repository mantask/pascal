{ MK 2002 }
{ XII Olimpiados uzdavinys JAPONAI }

program Japonai;

type
  Tsk = -1 .. 1;
  TG = array [0 .. 101, 0 .. 101] of Tsk;
  Teil = array [1 .. 250] of integer;
  Tmas = array [0 .. 101] of integer;
  Taib = set of 0 .. 101;

var
  sav, sve : integer;
  g : Tg;
  Griz : Tmas;

procedure nuskaitymas (var sav, sve : integer; var G : TG);
var
  ck, ckx, cky, pg : Integer;
  f : text;
begin
  assign (f, 'japonai.dat');
  reset (f);
  readln (f, sav, sve);
  pg := sav + sve + 2;
  for ckx := 0 to pg do
  for cky := 0 to pg do
  g [ckx, cky] := 0;
  for ck := 1 to sav do
  g [0, ck] := 1;
  for ck := sav + 1 to sav + sve do
  g [ck, pg - 1] := 1;
  for ck := 1 to sav do
  begin
    while not eoln (f) do
    begin
      read (f, pg);
      g [ck, pg + sav] := 1
    end;
    readln (f)
  end;
  close (f)
end;

procedure pakelk (v, viso : integer; var h : Tmas; var sr : TG);
var
  ck, mini : integer;
  galima : boolean;
begin
  galima := true;
  mini := -1;
  for ck := 0 to viso - 1 do
  if (g [v, ck] > sr [v, ck]) then
  if (h [ck] >= h [v]) and ((mini = -1) or (h [ck] <= h [mini]))
  then mini := ck
  else galima := false;
  if galima then h [v] := h [mini] + 1
end;

function min (sk1, sk2 : integer) : integer;
begin
  if sk1 < sk2 then min := sk1
               else min := sk2
end;

procedure paleisk (v, viso : integer; var sr : TG; var bak, h : Tmas;
          var aib : Taib; var uod : integer; var eil : Teil; var griz : Tmas);
var
  pg, ck : integer;
begin
  for ck := 0 to viso - 1 do
  if (g [v, ck] > sr [v, ck]) and (h [ck] + 1 = h [v]) then
  begin
    pg := min (g [v, ck] - sr [v, ck], bak [v]);
    bak [v] := bak [v] - pg;
    bak [ck] := bak [ck] + pg;
    sr [v, ck] := sr [v, ck] + pg;
    sr [ck, v] := -sr [v, ck];
    griz [v] := ck;

    if not (ck in aib) and (ck <> 0) and (ck <> viso - 1) and (bak [ck] <> 0)
    then
    begin
      aib := aib + [ck];
      eil [uod] := ck;
      uod := uod mod viso + 1
    end
  end;
end;

procedure srautai (var griz : Tmas);
var
  sr : TG;
  eil : Teil;
  h, bak : Tmas;
  ck, pg, viso,
  gal, uod : integer;
  aib : Taib;
begin
  viso := sve + sav + 2;
  for ck := 0 to viso - 1 do
  begin
    h [ck] := 0;
    griz [ck] := 0;
    bak [ck] := 0
  end;
  gal := 1;
  h [0] := viso;

  for ck := 1 to sav do
  begin
    bak [ck] := 1;
    griz [ck] := 0;
    eil [ck] := ck;
    sr [0, ck] := 1;
    sr [ck, 0] := -1
  end;
  aib := [1 .. sav];
  uod := sav + 1;

  while aib <> [] do
  begin
    pg := eil [gal];
    gal := gal mod viso + 1;
    aib := aib - [pg];
    while bak [pg] <> 0 do
    begin
      pakelk (pg, viso, h, sr);
      paleisk (pg, viso, sr, bak, h, aib, uod, eil, griz);
    end
  end;
end;

procedure grizk (var grizk : Tmas);
var
  ck : integer;
begin
  for ck := 1 to sav do
  writeln (griz [ck])
end;

begin
  nuskaitymas (sav, sve, g);
  srautai (griz);
  grizk (griz);
  readln
end.
