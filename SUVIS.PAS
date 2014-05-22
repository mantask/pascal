{ MK 2001 }
program suvis;

uses
  crt, graph;

type
  Tpiram2D = array [1 .. 4, 1 .. 2] of integer;

const
  sp = 7; { piramides spalva }
  D = 10; { ekrano gylis }
  g = 9.8; { Laisvo kritimo pagreitis }
  ilg = 3; { piramides briaunos ilgis }
  v0 = 300; { pradinis greitis }
  alfa = 45; { kampas i auksti }
  beta = 10; { kampas i sona }
  gama = 30; { kampas, kuriuo skrisdamas kudas suksis apie save }
  linija : array [1 .. 6, 1 .. 2] of 1 .. 4 = { piramides briaunu aprasai }
          ((1,4),(1,2),(1,3),(4,3),(2,4),(2,3));

var
  ckt, ck1, { pagalbinis ciklo kintamasis }
  t, { kiek laiko kunas isbus ore, t.y., kokio ilgio ciklas }
  gd, gm : integer;
  cx, cy, cz, { tasko koordinates }
  deg2rad : real; { 1 laipsnis radianais, palengvins sinn ir coss formavima }
  piram3D : array [1 .. 4, 1 .. 3] of real; { piramides virsuniu 3D koord. }
  piram2D : Tpiram2D; { piramides virsuniu 2D koord. }
  coss, sinn : array [0 .. 359] of real; { sinusu ir kot. lenteles }

{ nupiesia piramide is piram2D masyvo }
procedure piesk (sp : byte);
var
  ck : 1 .. 6;
begin
  setcolor (sp);
  for ck := 1 to 6 do
  line (piram2D [linija [ck, 1], 1], piram2D [linija [ck, 1], 2],
        piram2D [linija [ck, 2], 1], piram2D [linija [ck, 2], 2])
end;

{ randa x koordinate tam tikru laiko momentu }
function Px (t : integer) : real;
begin
  px := v0 * coss [alfa] * coss [beta] * t
end;

{ randa y koordinate tam tikru laiko momentu }
function Py (t : integer) : real;
begin
  Py := v0 * sinn [alfa] * t - g * sqr (t) / 2
end;

{ randa z koordinate tam tikru laiko momentu }
function Pz (t : integer) : real;
begin
  Pz := v0 * coss [alfa] * sinn [beta] * t
end;

{ pasuka taska A (x, y, z) apie tris asis }
procedure pasukimas (var x, y, z : real; xx, yy, zz : integer);
var
  pg : real;
begin
  if xx > 0 then
  begin
    pg := y * coss [xx] - z * sinn [xx];
    z := y * sinn [xx] + z * coss [yy];
    y := pg;
  end;
  if yy > 0 then
  begin
    pg := x * coss [yy] + z * sinn [yy];
    z := z * coss [yy] - x * sinn [yy];
    x := pg;
  end;
  if zz > 0 then
  begin
    pg := x * coss [zz] - y * sinn [zz];
    y := x * sinn [zz] + y * coss [zz];
    x := pg
  end;
end;

{ pakeiciam 3D virsuniu koord ir 2D }
procedure keiskD (var piram2D : Tpiram2D);
var
  ck : 1 .. 4;
  pg : real;
begin
  for ck := 1 to 4 do
  begin
    if piram3D [ck, 3] = 0 then pg := 1
                           else pg := piram3D [ck, 3];
    piram2D [ck, 1] := round (cx + (piram3D [ck, 1]) * D / pg);
    piram2D [ck, 2] := round (cy + (piram3D [ck, 2]) * D / pg);
  end;
end;

begin
  cx := 1;
  cy := 1;
  cz := 1;

  { suformuosim sinn ir coss lenteles }
  deg2rad := pi / 180;
  for ck1 := 0 to 359 do
  begin
    sinn [ck1] := sin (ck1 * deg2rad);
    coss [ck1] := cos (ck1 * deg2rad)
  end;

  { paruosim virsuniu masyva }
  piram3D [1, 1] := 0;
  piram3D [1, 2] := 0;
  piram3D [1, 3] := 0;
  piram3D [2, 1] := ilg;
  piram3D [2, 2] := 0;
  piram3D [2, 3] := 0;
  piram3D [3, 1] := ilg / 2;
  piram3D [3, 2] := 0;
  piram3D [3, 3] := sqrt (sqr (ilg) - sqr (ilg) / 4);
  piram3D [4, 1] := ilg / 2;
  piram3D [4, 2] := sqrt (sqr (ilg) - sqr (ilg) / 4);
  piram3D [4, 3] := 0;

  { rasim kiek laiko kunas bus ore }
  t := round (2 * v0 * sinn [alfa] / g );

  { suformuojam piram2D }
  keiskD (piram2D);

  initgraph (gd, gm, '');
  for ckt := 1 to t do
  begin
    if port [$60] = 1 then break;
    piesk (0);
    cx := Px (ckt) / 150;
    cy := Py (ckt) / 150;
    cz := Pz (ckt);
    for ck1 := 1 to 4 do
    pasukimas (piram3D [ck1, 1], piram3D [ck1, 2], piram3D [ck1, 3], gama, 0, 0);
    keiskD (piram2D);
    piesk (sp);
    delay (1000);
  end;
  closegraph;
end.