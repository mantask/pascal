{ MK 2002                    }
{ Mantas Kanaporis           }
{ Vilniaus Ïemynos gimnazija }
{ -------------------------- }
{ IX skyrius                 }
{ 5 uØdavinys                }


{ ID¸JA yra, panaudojant sĞraÕo dalijimĞ i dvi dalis, rekursiÕkai rasti
  reikiamĞ pavardÒ. Imamas masyvo vidurinis elementas, ir Øi×rima, ar
  numerio reikÕmÓ didesnÓ ar maØesnÓ uØ ieÕkomo. Jei reikÕmÓ maØesnÓ, tai
  imama pirma masyvo dalis ir Øi×rimas vidurinis jos elementas. Taip
  masyvas rekursiÕkai skaidomas iki tol, kol vidurinis elementas ir bus lygus
  ieÕkomam.
  PASTABA: kadangi sĞlygoje nenurodytas maksimalus sĞraÕo ilgis, todÓl aÕ jÔ
  pasirinkau pats, t. y., prisilyginau 1000. Jei bus pateiktas ilgesnis
  sĞraÕas, tai reiks padidinti konstantos MAX reiksme. Salygoje taip pat
  nenurodyti simboliai, iÕ kuriÖ bus formuojamas numeris, todÓl imu
  standartinÒ anglÖ kalbos abÓcÓlÒ, t. y., ['A' .. 'Z']. }

program JPM_9_5;

const
  max = 1000;             { maksimalus sĞraÕo ilgis }

type
  Tsavin = record         { savininko tipas }
    pavarde : string [20];
    num_raid : string [3];
    num_sk : 1 .. 999;
  end;

var
  sk : integer;           { savininkÖ skaicius }
  sarasas : array [1 .. MAX] of Tsavin; { pats automob. savininkÖ sĞraÕas }
  savin : tsavin;         { ieÕkomo savininko duomenys }
  pg, ck : integer;       { pagalbiniai kintamieji }
  f : text;               { pagalbinis failo kintamasis }
  pgEil : string;    { pagalbinis kint., reikalingas prad. duom. nuskaityti }

{ rekursinÓ proced×ra, randanti savininkĞ
  pr - nagrinÓjamo sĞraÕo pradØia
  pb - nagrinÓjamo sĞraÕo pabaiga
  savin - ieÕkomo savininko duomenys }
procedure paieska (var savin : Tsavin; pr, pb : integer);
var
  vid : integer;             { vidurinis narys }
begin
  if pr + 1 = pb then        { jei sĞraÕĞ sudaro 2 elementai }
  begin                      { tai jie ir patikrinami }
    if (savin.num_sk = sarasas [pr].num_sk) and
       (savin.num_raid = sarasas [pr].num_raid)
    then savin.pavarde := sarasas [pr].pavarde;
    if (savin.num_sk = sarasas [pb].num_sk) and
       (savin.num_raid = sarasas [pb].num_raid)
    then savin.pavarde := sarasas [pb].pavarde;
    exit
  end;
  vid := (pr + pb) div 2;       { vidurinis narys }
  if (savin.num_sk = sarasas [vid].num_sk) and { jei vidurinio sĞraÕo nario }
     (savin.num_raid = sarasas [vid].num_raid) { numeris yra ieÕkomas, }
  then savin.pavarde := sarasas [vid].pavarde  { tai galim baigti paieÕkĞ }
  else
  begin
    if pr = pb then exit; { jei pradØia = pabaiga, reikia nutraukti paieÕkĞ }
    { toliau nagrinÓjama sĞraÕo dalis iki vid. arba nuo vid. }
    if savin.num_raid < sarasas [vid].num_raid
    then paieska (savin, pr, vid)
    else if savin.num_raid > sarasas [vid].num_raid
         then paieska (savin, vid, pb)
         else if savin.num_sk < sarasas [vid].num_sk
              then paieska (savin, pr, vid)
              else paieska (savin, vid, pb)
  end
end;

begin
  { nuskaitomi pradiniai duomenys }
  assign (f, 'duom.txt');
  reset (f);
  readln (f, savin.num_raid, savin.num_sk);
  readln (f, sk);
  for ck := 1 to sk do
  begin
    readln (f, pgEil);
    pg := pos (' ', pgEil);
    sarasas [ck].pavarde := copy (pgEil, 1, pg - 1);
    sarasas [ck].num_raid := copy (pgEil, pg + 1, 3);
    delete (pgEil, 1, pg + 3);
    val (pgEil, sarasas [ck].num_sk, pg)
  end;
  close (f);

  { rekursiskai ieskosime numerio }
  paieska (savin, 1, sk);

  { spausdinamas atsakymas }
  if savin.pavarde = '' then writeln ('PavardÓ nerasta')
                        else writeln (savin.pavarde)
end.