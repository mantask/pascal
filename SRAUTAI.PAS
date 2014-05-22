{ MK 2002 }
{ Srautu leidimo zemyn metodo realizacija }

program srautai;

const
  max = 100;

type
  Tgraf = array [1 .. max, 1 .. max] of integer;
  Tmas = array [1 .. max] of integer;
  Taib = set of 1 .. max;

var
  sraut, g : Tgraf;
  bakas, eil, H : Tmas;
  ckx, cky,
  virs,
  gal, uod : integer;
  aib : Taib;

procedure nuskaitymas (var virs : integer; var g : Tgraf);
var
  f : text;
  pg1, pg2, pg3 : integer;
begin
  assign (f, 'srautai.dat');
  reset (f);
  readln (f, virs);
  while not eof (f) do
  begin
    readln (f, pg1, pg2, pg3);
    g [pg1, pg2] := pg3
  end;
  close (f)
end;

procedure pakelti (nr : integer; var h : Tmas);
var
  max, ck : integer;
  galima : boolean;
begin
  galima := true;
  max := -1;
  for ck := 1 to virs do
  if g [nr, ck] > sraut [nr, ck] then
  begin
    if (h [ck] < h [nr]) then galima := false
                         else if (max = -1) or (h [ck] < h [max])
                              then max := ck;
  end;
  if galima then h [nr] := h [max] + 1
end;

procedure paleisti (nr : integer; var srautai : Tgraf; var bakas : Tmas;
                      var uod : integer; var eil : Tmas; var aib : Taib);
var
  pg, ck : Integer;
begin
  for ck := 1 to virs do
  if (h [ck] + 1 = h [nr]) and (g [nr, ck] > sraut [nr, ck]) then
  begin
    if g [nr, ck] - sraut [nr, ck] < bakas [nr]
    then pg := g [nr, ck] - sraut [nr, ck]
    else pg := bakas [nr];
    bakas [nr] := bakas [nr] - pg;
    bakas [ck] := bakas [ck] + pg;
    sraut [nr, ck] := sraut [nr, ck] + pg;
    sraut [ck, nr] := -sraut [nr, ck];
    if (ck <> 1) and (ck <> virs) and (bakas [ck] > 0) and not (ck in aib) then
    begin
      aib := aib + [ck];
      eil [uod] := ck;
      inc (uod)
    end
  end
end;

begin
  nuskaitymas (virs, g);

  for ckx := 1 to virs do
  begin
    for cky := 1 to virs do
    sraut [ckx, cky] := 0;
    eil [ckx] := 0;
    h [ckx] := 0
  end;

  gal := 1;
  uod := 1;
  h [1] := virs;
  aib := [];

  for ckx := 1 to virs do
  if g [1, ckx] > 0 then
  begin
    aib := aib + [ckx];
    eil [uod] := ckx;
    inc (uod);
    sraut [1, ckx] := g [1, ckx];
    sraut [ckx, 1] := -g [1, ckx];
    bakas [ckx] := g [1, ckx]
  end;

  while gal < uod do
  begin
    aib := aib - [eil [gal]];
    while bakas [eil [gal]] > 0 do
    begin
      pakelti (eil [gal], h);
      paleisti (eil [gal], sraut, bakas, uod, eil, aib)
    end;
    inc (gal)
  end
end.