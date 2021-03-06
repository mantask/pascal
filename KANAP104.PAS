{ MK 2002                    }
{ Mantas Kanaporis           }
{ Vilniaus �emynos gimnazija }
{ -------------------------- }
{ X skyrius                  }
{ 4 u�davinys                }

{ ID�JA yra pritaikyti t� pat� paie�kos � gyl� metod�. Paie�kos nutraukimo
  s�lyga (ribinis atvejis) yra galutinio �od�io prijungimas. Kas kart�
  naujai paimtas �odis yra pa�ymimas, kad neimti jo kelis kartus. }

Program Kanap104;

Type
  Tzodziai = array [1 .. 20] of string; { �od�i� masyvas }
  Tnum = set of 1 .. 20; { aib�s tipas, reikalingas kintajam, �ymin�iam,
                           panaudotus �od�ius metagramai }
var
  zodziai : Tzodziai; { duoti �od�iai (pradiniai duom.) }
  viso : byte;        { duot� �od�i� skai�ius }
  galima : boolean;   { ar galima sudaryti metagram� }

{ nuskaitomi pradiniai duomenys }
procedure nuskaitymas (var viso : byte; var zodziai : Tzodziai);
var
  F : Text;
  ck : byte;
begin
  assign (f, 'meta.txt');
  reset (f);
  readln (f, viso);
  for ck := 1 to viso do
  readln (f, zodziai [ck]);
  close (f)
end;

{ ar �od�ius, kuri� nr. masyve yra eil1, eil2, galima sujungti metagrandine }
function meta (eil1, eil2 : byte) : boolean;
var
  ck,                   { pagalbinis ciklo kintamasis }
  skirtumai : integer;  { skirtum� tarp duot� �od�i� skai�ius }
begin
  if length (zodziai [eil1]) = length (zodziai [eil2]) then
  begin             { jei �od�i� ilgiai vienodi ir jie skiriasi viena raide, }
    skirtumai := 0; { tai metagrand� sudaryti galime, kitaip - ne }
    for ck := 1 to length (zodziai [eil1]) do
    if zodziai [eil1] [ck] <> zodziai [eil2] [ck] then inc (skirtumai);
    if skirtumai = 1 then meta := true
                     else meta := false
  end
  else meta := false { jei �od�i� ilgiai skiriasi, }
end;                 { sudaryti metegrandies nepavyks }

procedure paieska (nr : byte; num : Tnum; var galima : boolean);
var
  ck : byte;
begin
  if galima then exit; { jei nustat�me, kad galima, neverta toliau ie�koti }
  if 2 in num then galima := true  { jei galima prijunti paskutin� �od�, }
  else                             { tai ir pa�ymime }
  begin
    for ck := 2 to viso do                    { bandoma prijunti �od�, }
    if not (ck in num) and meta (nr, ck) then { kuris dar nepanaudotas ir }
    paieska (ck, num + [ck], galima)          { tinkamas metagrand�iai }
  end
end;

begin
  nuskaitymas (viso, zodziai);

  galima := false;   { darom prielaid�, kad metagrandin�s sudaryti negalim }
  paieska (1, [1], galima);

  if galima then writeln ('GALIMA')   { jei visgi galime, tai ir para�ome }
            else writeln ('NEGALIMA') { jei ne - irgi para�ome }
end.