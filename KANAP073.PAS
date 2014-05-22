{ MK 2001                    }
{ Mantas Kanaporis           }
{ Vilniaus œemynos gimnazija }
{ -------------------------- }
{ VII skyrius                }
{ 3 uÿdavinys                }


{ Drakono kreiv“ formuojan—i÷ ir pie’ian—i÷ proced◊r÷ nedariau s–moningai,
  nes proced◊r÷ parametr÷ b◊t÷ tikrai daug ir b◊t÷ labai painu. Dabar,
  norint pakeisti kreiv”s laipsn‘ ar linijos ilg‘, uÿtenka pakeisti konstant÷
  reik’mes. }

program kanap073;

uses
  graph;

const
  n = 15;                                        { kreiv”s laipsnis }
  ln = 2;                                        { linijos ilgis }
  kryptys : array [0 .. 3, 0 .. 1] of shortint = { jud”jimo kryptys }
          ((0, -ln), (-ln, 0), (0, ln), (ln, 0));
  x : integer = 200;                             { piesima nuo cia }
  y : integer = 200;                             { piesima nuo cia }

var
  kreive : array [1 .. 50000] of 0 .. 3;{ drakono kreiv“ sudarantys elementai }
  ck, ckn : longint;             { ciklo kintamieji }
  ilg : longint;                 { kreiv“ sudaran—i÷ element÷ skai—ius }
  gm, gd : integer;

begin

  initgraph (gm, gd, '');

  ilg := 1;                      { pirmo laipsnio kreiv”s element÷ skai—ius }
  kreive [1] := 0;               { pirmo laipsnio kreiv” - br◊k’nys i vir’÷ }
  for ckn := 1 to n do           { formuojamas kreiv”s masyvas }
  begin
    for ck := 1 to ilg do
    begin
      kreive [2 * ilg - ck + 1] := (kreive [ck] + 1) mod 4;
                     { kiekvienas elementas pasukamas ir pridedamas is galo }
    end;
    ilg := ilg shl 1;            { ilgis x 2 }
  end;
  ilg := ilg shr 1;              { ilgis / 2 }

  setcolor (7);
  moveto (x, y);
  for ck := 1 to ilg do            { pie’iama drakono kreiv” i’ masyvo }
  begin                            { pie’iama nurodyta kryptimi }
    x := x + kryptys [kreive [ck], 0];
    y := y + kryptys [kreive [ck], 1];
    lineto (x, y);
  end;

  repeat until port [$60] = 1;    { laukiama Esc paspaudimo }
  closegraph;
end.