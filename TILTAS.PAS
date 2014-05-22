{ MK 2002 }
{ XII Olimpiados 225 uzd PAZINTYS }
program tiltas;
{ rasti bent viena tilta }
type
  TG = array [1 .. 200, 1 .. 200] of boolean;
  Taib = set of 1 .. 200;

var
  g : Tg;
  ck, viso : integer;

procedure nuskaitymas (var viso : Integer; var G : Tg);
var
  f : Text;
  ckx, cky, pg, v : integer;
begin
  assign (f, 'tiltas.dat');
  reset (F);
  readln (f, viso);
  for cky := 1 to viso do
  for ckx := 1 to viso do
  g [ckx, cky] := false;
  for ckx := 1 to viso do
  begin
    read (f, pg);
    for cky := 1 to pg do
    begin
      read (f, v);
      g [ckx, v] := true
    end;
    readln (f)
  end;
  close (F)
end;

procedure tikrink (virs, v : integer; var aib : Taib);
var
  ck : Integer;
begin
  if aib <> [1 .. viso] then
  for ck := 1 to viso do
  if (ck <> v) and not (ck in aib) and g [virs, ck]
  then
  begin
    aib := aib + [ck];
    tikrink (ck, v, aib)
  end
end;


function jungus (v : integer) : boolean;
var
  pg, aib : Taib;
begin
  aib := [];
  tikrink (v mod viso + 1, v, aib);
  pg := [1 .. viso] - [v];
  if aib = pg then jungus := true
              else jungus := false
end;

begin
  nuskaitymas (viso, g);
  for ck := 1 to viso do
  if not jungus (ck) then
  begin
    writeln (ck);
    break
  end
end.