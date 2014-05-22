{ MK 2002                    }
{ Mantas Kanaporis           }
{ Vilniaus œemynos gimnazija }
{ -------------------------- }
{ IX skyrius                 }
{ 4 uÿdavinys                }


{ ID∏JA yra surikiuoti kiekvienos fig◊ros briaun÷ ilgius did”jimo tvarka.
  Tada i’ eil”s lyginti kiekvienos fig◊ros atitinkamos briaunos ilg‘ su
  duotosios fig◊ros atitinkama briauna. Jei bent viena lyginamosios fig◊ros
  atitinkama briauna yra ilgesn”, t.y., didesn”, uÿ pradÿioje duoto
  daugiakampio, tai rei’kia, kad nagrin”jamas daugiakampis netilps. Tokiu
  b◊du yra patikrinamos visos fig◊ros. }

program JPM_9_4;

Type
  Tbr = array [1 .. 101, 1 .. 20] of integer; { briaun÷ masyvo tipas }

var
  br : Tbr;           { briaun÷ masyvas }
  matas,              { erdv”s matas }
  viso : integer;     { gretasieniu skai—ius }
  telpa,              { telpanci÷ gretasieni÷ skai—ius }
  ck1, ck2 : byte;    { pagalbiniai ciklo kintamieji }
  f : text;           { pagalbinis failo kintamasis }

{ Rikiuojamas briaun÷ masyvas briaun÷ did”jimo tvarka }
procedure rikiuok (var br : Tbr);
var
  ckV, ck1, ck2 : byte;
  pg : integer;
begin
  { imamas kievienas daugiakampis }
  for ckV := 1 to viso + 1 do
  { naudojamas rikiavimas sukeitimu }
  for ck1 := 1 to matas - 1 do
  for ck2 := 1 to matas - ck1 do
  if br [ckv, ck2] > br [ckv, ck2 + 1] then
  begin
    pg := br [ckv, ck2];
    br [ckv, ck2] := br [ckv, ck2 + 1];
    br [ckv, ck2 + 1] := pg
  end;
end;

{ funkcija randa kiek daugiakampi÷ telpa ‘ pradin‘ }
function kiek (br : Tbr) : byte;
var
  ok : boolean;                { ar nagrin”jamas daug. telpa }
  telpa,                       { telpan—i÷ skai—ius }
  ckV, ckM : byte;             { pagalbiniai ciklo kintamieji }
begin
  telpa := 0;
  for ckV := 2 to viso + 1 do  { nagrin”jami visi daugiakampiai, }
  begin                        { i’skyrus pradin‘ }
    ok := true;
    for ckM := 1 to matas do   { jei bent viena briauna netelpa, tai }
    if br [1, ckM] < br [ckV, ckM] then ok := false; { netelpa visa fig◊ra }
    if OK then inc (telpa)
  end;
  kiek := telpa
end;


begin
  { skaitomi pradiniai duomenys }
  assign (f, 'duom.txt');
  reset (f);
  readln (f, matas, viso);
  for ck1 := 1 to matas do
  read (f, br [1, ck1]);
  readln (F);
  for ck1 := 2 to viso + 1 do
  begin
    for ck2 := 1 to matas do
    read (f, br [ck1, ck2]);
    readln (F)
  end;
  close (f);

  { skai—iuojama kiek telpa }
  rikiuok (br);
  telpa := kiek (br);

  { para’omas atsakymas }
  writeln (telpa)
end.
