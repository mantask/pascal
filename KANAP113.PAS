{ MK 2002                    }
{ Mantas Kanaporis           }
{ Vilniaus œemynos gimnazija }
{ -------------------------- }
{ XI skyrius                 }
{ 3 uÿdavinys                }

{ ID∏JA yra pat‘ faktorial– vaizduoti skaitmen÷ masyvu. Kadangi 30! turi
  33 skaitmenis, tai ’iam skai—iui vaizduoti pakanka 33 element÷ masyvo.
  Daugyba atliekama stulpeliu, dauginant kiekvien– skaitmen‘ atskirai.
  Kiekvienas faltorialas iki 30 imtinai yra ‘ra’omas ‘ rezultat÷ fail–. }

program kanap113;

const
  Max = 33;     { skaitmen÷ masyvo ilgis }
  kiek = 30;    { kokio skai—iaus faltorialas }

type
  Tsk = array [1 .. max] of 0 .. 9;
                { skaitmen÷ masyvo tipas }
var
  sk : Tsk;
  ck : integer;
  f : text;

procedure rasyk (sk : Tsk; var f : text);
var
  ck, pg : integer;
begin
  for ck := max downto 1 do   { randamas pirmas uÿpildytas }
  if sk [ck] > 0 then         { faktorialo skaitmen÷ masyvo elementas }
  begin
    pg := ck;
    break
  end;
  for ck := pg downto 1 do    { sura’omi ‘ fail– visi }
  write (f, sk [ck]);         { faktorialo skaitmenys }
  writeln (f)
end;

procedure Fakt (n : integer; var sk : Tsk);
var
  liek, ck, pg : integer;
begin
  liek := 0;
  for ck := 1 to max do
  begin                                { daugyba stulpeliu }
    pg := sk [ck] * n;
    sk [ck] := (pg + liek) mod 10;
    liek := (liek + pg) div 10
  end;

{  if liek > 0 then writeln ('KLAIDA')} { masyvas yra per mazas, reikia }
                                        { padidinti max konstanta }
end;

begin
  for ck := 2 to max do     { paruo’iamas skaitmen÷ masyvas }
  sk [ck] := 0;
  sk [1] := 1;              { vieneto faltorialas 1 }

  assign (f, 'rez.txt');
  rewrite (f);
  writeln (f, 1);           { ‘ra’omas pirmas faktorialas }

  for ck := 2 to kiek do
  begin
    fakt (ck, sk);          { skai—iuojami visi faktorialai iki 30 }
    rasyk (sk, f)           { ir, ai’ku, jie ‘ra’omi ‘ fail– }
  end;

  close (f)
end.