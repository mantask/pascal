{ MK 2002                    }
{ Mantas Kanaporis           }
{ Vilniaus Ïemynos gimnazija }
{ -------------------------- }
{ X skyrius                  }
{ 3 uØdavinys                }

{ ID¸JA yra rasti trumpiasiĞ keliĞ, taikant paieÕkos Ô gylÔ metodĞ, t. y.,
  rekursiÕkai vaikÕÑioti Ô visas puses, kol bus prieitas kraÕtas. ½siminti
  reikia tik trumpiausiĞ keliĞ ir jo ilgÔ. }

Program Kanap103;

Type
  Tlabir = array [1 .. 10, 1 .. 10] of char; { labirinto tipas }

var
  ilgis : integer; { rasto trumpiasio kelio ilgis }
  ck : byte;       { pagalbinis ciklo kintamasis }
  kelias,          { labirinto kopija su rastu trumpiausiu keliu }
  labir : Tlabir;  { pats labirintas }

{ nuskatomi pradiniai duomenys }
procedure nuskaitymas (var labir : Tlabir);
var
  ckx, cky : byte;
  f : text;
begin
  assign (f, 'kvadr.txt');
  reset (f);
  for cky := 1 to 10 do
  begin
    for ckx := 1 to 10 do
    read (f, labir [ckx, cky]);
    readln (f)
  end;
  close (f)
end;

procedure eik (gylis : integer; x, y : byte; var labir : Tlabir;
               var ilgis : integer; var kelias : Tlabir);
begin
  { jei perÓjom kli×ÑiÖ ruoØĞ, ir rastas kelias yra trumpesnis uØ ankstesnÔ }
  if (x = 10) and (labir [x, y] = '.') and (gylis < ilgis) then
  begin
    kelias := labir;         { Ôsimenam trumpiausiĞ keliĞ }
    kelias [x, y] := '+';    { paØymime paskutinÔ langelÔ }
    ilgis := gylis;          { Ôsimename trumpiausio kelio ilgÔ }
  end
  else
  begin
    labir [x, y] := '+'; { paØymim, kad buvo eita Ô nagrinÓjamĞ langĞ }

    { einama Ô deÕinÒ, jei ten galima eiti }
    if (x + 1 <= 10) and (labir [x + 1, y] = '.')
    then eik (gylis + 1, x + 1, y, labir, ilgis, kelias);

    { einama Ô kairÒ, jei ten galima eiti }
    if (x - 1 > 0) and (labir [x - 1, y] = '.')
    then eik (gylis + 1, x - 1, y, labir, ilgis, kelias);

    { einama Ô virÕÖ, jei ten galima eiti }
    if (y + 1 <= 10) and (labir [x, y + 1] = '.')
    then eik (gylis + 1, x, y + 1, labir, ilgis, kelias);

    { einama Øemyn, jei ten galima eiti }
    if (y - 1 > 0) and (labir [x, y - 1] = '.')
    then eik (gylis + 1, x, y - 1, labir, ilgis, kelias);

    labir [x, y] := '.' { atØymima, kad buvo eita Ô nagrinÓjamĞ langĞ }
  end
end;

{ ÔraÕomas atsakymas (trumpiausio kelio ilgis, pats kelias) Ô failĞ }
procedure rasymas (ilgis : byte; Kelias : Tlabir);
var
  ckx, cky : byte;
  f : text;
begin
  assign (f, 'kvadr.txt');
  rewrite (f);
  writeln (f, ilgis);
  for cky := 1 to 10 do
  begin
    for ckx := 1 to 10 do
    write (f, kelias [ckx, cky]);
    writeln (f)
  end;
  close (f)
end;

begin
  nuskaitymas (labir);

  ilgis := maxint;         { tarkim, trumpiasias kelias yra begalinis }
  for ck := 1 to 10 do     { pradedam ieÕkoti kelio iÕ kli×ÑiÖ ruoØo kairÓs }
  if labir [1, ck] = '.' then
  eik (1, 1, ck, labir, ilgis, kelias);

 { jei kelio neradome, tai ÔraÕom Ô failĞ labirintĞ, kitu atveju rastĞ keliĞ }
  if ilgis = maxint then rasymas (0, labir)
                    else rasymas (ilgis, kelias)
end.

