{ MK 2002                    }
{ Mantas Kanaporis           }
{ Vilniaus �emynos gimnazija }
{ -------------------------- }
{ IX skyrius                 }
{ 5 u�davinys                }


{ ID�JA yra, panaudojant s�ra�o dalijim� i dvi dalis, rekursi�kai rasti
  reikiam� pavard�. Imamas masyvo vidurinis elementas, ir �i�rima, ar
  numerio reik�m� didesn� ar ma�esn� u� ie�komo. Jei reik�m� ma�esn�, tai
  imama pirma masyvo dalis ir �i�rimas vidurinis jos elementas. Taip
  masyvas rekursi�kai skaidomas iki tol, kol vidurinis elementas ir bus lygus
  ie�komam.
  PASTABA: kadangi s�lygoje nenurodytas maksimalus s�ra�o ilgis, tod�l a� j�
  pasirinkau pats, t. y., prisilyginau 1000. Jei bus pateiktas ilgesnis
  s�ra�as, tai reiks padidinti konstantos MAX reiksme. Salygoje taip pat
  nenurodyti simboliai, i� kuri� bus formuojamas numeris, tod�l imu
  standartin� angl� kalbos ab�c�l�, t. y., ['A' .. 'Z']. }

program JPM_9_5;

const
  max = 1000;             { maksimalus s�ra�o ilgis }

type
  Tsavin = record         { savininko tipas }
    pavarde : string [20];
    num_raid : string [3];
    num_sk : 1 .. 999;
  end;

var
  sk : integer;           { savinink� skaicius }
  sarasas : array [1 .. MAX] of Tsavin; { pats automob. savinink� s�ra�as }
  savin : tsavin;         { ie�komo savininko duomenys }
  pg, ck : integer;       { pagalbiniai kintamieji }
  f : text;               { pagalbinis failo kintamasis }
  pgEil : string;    { pagalbinis kint., reikalingas prad. duom. nuskaityti }

{ rekursin� proced�ra, randanti savinink�
  pr - nagrin�jamo s�ra�o prad�ia
  pb - nagrin�jamo s�ra�o pabaiga
  savin - ie�komo savininko duomenys }
procedure paieska (var savin : Tsavin; pr, pb : integer);
var
  vid : integer;             { vidurinis narys }
begin
  if pr + 1 = pb then        { jei s�ra�� sudaro 2 elementai }
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
  if (savin.num_sk = sarasas [vid].num_sk) and { jei vidurinio s�ra�o nario }
     (savin.num_raid = sarasas [vid].num_raid) { numeris yra ie�komas, }
  then savin.pavarde := sarasas [vid].pavarde  { tai galim baigti paie�k� }
  else
  begin
    if pr = pb then exit; { jei prad�ia = pabaiga, reikia nutraukti paie�k� }
    { toliau nagrin�jama s�ra�o dalis iki vid. arba nuo vid. }
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
  if savin.pavarde = '' then writeln ('Pavard� nerasta')
                        else writeln (savin.pavarde)
end.