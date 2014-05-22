{ MK 2001                    }
{ Mantas Kanaporis           }
{ Vilniaus œemynos gimnazija }
{ -------------------------- }
{ VII skyrius                }
{ 4 uÿdavinys                }

program kanap074;

uses
  graph;

const
  cx = 319;        { rago centro koordinat” }
  cy = 239;        { rago centro koordinat” }

var
  gm, gd : integer;

{ Proced◊ra pie’ia raga.
  Parametrai:
  | Rratas - apskritimo, kuriuo i’sid”st“ kiti apskritimai, spindulys
  | Rdidz - didÿiausio (pradinio) apskritimo spindulys }
Procedure Ragas (Rratas, Rdidz : integer);
var
  x, y,                        { kiekvieno apskritimo centro koordinat”s }
  ck : integer;                { pagalbinis ciklo kintamasis }
  r,                           { pie’iamo apskritimo spindulys }
  maz : real;                  { spindulio maÿinimo ÿingsnis }
begin
  maz := Rdidz / 60;           { kas kiek maÿ”s spindulio ilgis }
  r := Rdidz;                  { pie’im didziausia apskritima }
  for ck := 0 to 59 do         { pie’ime apskritimus kas 6 laipsnius }
  begin                        { skai—iuojamos kito apskr. koordinat”s }
    x := cx + round (Rratas * cos (ck * 6 * pi / 180));
    y := cy + round (Rratas * sin (ck * 6 * pi / 180));
    circle (x, y, trunc (R));
    R := r - maz;              { kito apskr. spindulys }
  end;
end;

begin
  initgraph (gm, gd, '');

  ragas (100, 100);

  repeat until port [$60] = 1;     { laukiam Esc paspaudimo }
  closegraph;
end.