{ MK 2002                    }
{ Mantas Kanaporis           }
{ Vilniaus œemynos gimnazija }
{ -------------------------- }
{ X skyrius                  }
{ 5 uÿdavinys                }

{ ID∏JA yra pritaikyti paie’kos ‘ gyl‘ metod–. Skai—iaus paskutin‘ skaitmen‘
  atmetin”sime tol, kol nieko neliks. Tada sura’ysime atmestus skaitmenis. }

program Kanap105;

var
  f : Text;      { pagalbinis failo kintamasis }
  sk : integer;  { skai—ius, kur‘ turime pavaizduoti grafi’kai }

procedure graf (sk : integer; var f : text);
var
  pg, { pagalbinis, reikalingas paskutiniam skaitmemiui saugoti }
  ck : integer; { pagalbinis ciklo kintamasis }
begin
  if sk = 0 then exit; { jei vis– skai—i÷ i’kaid”me skaitmenimis, galime }
                       { nutraukti tolimesnius bandymus skaidyti }
  graf (sk div 10, f); { atmetamas pask. skaitmuo ir "lendama gilyn" }

  pg := sk mod 10;     { paimamas paskutinis skaitmuo }
  if pg = 0 then writeln (f, '*') { jei pask. sk. - nulis, tai ra’ome '*' }
  else
  begin                    { jei ne nulis, tai ra’ome t– skaitmen‘ tiek }
    for ck := 1 to pg do   { kart÷, kokia yra to skaitmens vert” }
    write (f, pg);
    writeln (f)
  end
end;

begin
  { skaitomi pradiniai duomenys }
  assign (f, 'duom.txt');
  reset (f);
  readln (f, sk);
  close (f);

  { atliekami skai—iavimai ir i’ karto ra’oma ‘ paruo’t– tam fail– }
  assign (f, 'rez.txt');
  rewrite (f);
  graf (sk, f);
  close (f)
end.
