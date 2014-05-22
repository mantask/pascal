{ MK 2001                    }
{ Mantas Kanaporis           }
{ Vilniaus œemynos gimnazija }
{ -------------------------- }
{ VII skyrius                }
{ 3 uÿdavinys                }

program Drakonas;

uses
  graph;

Const
  cx = 400;                                 { centro koordinat” }
  cy = 350;                                 { centro koordinat” }
  ln = 1;                                   { linijos ilgis }
  l = 18;                                   { laipsnis, max 31 }
  kryptys : array [0 .. 3, 0 .. 1] of shortint = { jud”jimo kryptys }
          ((0, -ln), (-ln, 0), (0, ln), (ln, 0));

var
  x, y,                                 { linijos pabaigos koordinat”s }
  gm, gd : integer;
  ck,                                   { pagalbinis ciklo kintamasis }
  sk,                                   { nagrin”jamas skai—ius }
  n : longint;                          { kuria kryptimi br”’im linij– }

{ Funcija randa laipsn‘, kuriuo pak”lus 2, rezultatas butu kiek galima
  maÿiau didesnis arba lygus pradiniui duomeniui }
function didz (sk : longint) : longint;
var
  pg : longint;
begin
  pg := 1;
  while sk div pg > 0 do
  if sk = pg then break
             else pg := pg shl 1;
  didz := pg;
end;

begin
  initgraph (gd, gm, '');
  setcolor (7);
  x := cx;
  y := cy;
  moveto (x, y);

  sk := 1 shl (l - 1);        { kiek viso skai—iu sudarys l laipsnio kreiv“ }
  for ck := 1 to sk do
  begin
    sk := ck;
    n := 1;
    { skai—iavimas ck elemento krypties }
    while sk <> 1 do
    begin
      sk := didz (sk) - sk + 1;
      inc (n)
    end;
    n := (n - 1) mod 4;
    { pie’imas }
    x := x + kryptys [n, 0];
    y := y + kryptys [n, 1];
    lineto (x, y);
  end;

  repeat until port [$60] = 1;  { laukiama Esc paspaudimo }
  closegraph;
end.