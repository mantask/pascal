{ MK 2002                    }
{ Mantas Kanaporis           }
{ Vilniaus �emynos gimnazija }
{ -------------------------- }
{ X skyrius                  }
{ 3 u�davinys                }

{ ID�JA yra rasti trumpiasi� keli�, taikant paie�kos � gyl� metod�, t. y.,
  rekursi�kai vaik��ioti � visas puses, kol bus prieitas kra�tas. �siminti
  reikia tik trumpiausi� keli� ir jo ilg�. }

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
  { jei per�jom kli��i� ruo��, ir rastas kelias yra trumpesnis u� ankstesn� }
  if (x = 10) and (labir [x, y] = '.') and (gylis < ilgis) then
  begin
    kelias := labir;         { �simenam trumpiausi� keli� }
    kelias [x, y] := '+';    { pa�ymime paskutin� langel� }
    ilgis := gylis;          { �simename trumpiausio kelio ilg� }
  end
  else
  begin
    labir [x, y] := '+'; { pa�ymim, kad buvo eita � nagrin�jam� lang� }

    { einama � de�in�, jei ten galima eiti }
    if (x + 1 <= 10) and (labir [x + 1, y] = '.')
    then eik (gylis + 1, x + 1, y, labir, ilgis, kelias);

    { einama � kair�, jei ten galima eiti }
    if (x - 1 > 0) and (labir [x - 1, y] = '.')
    then eik (gylis + 1, x - 1, y, labir, ilgis, kelias);

    { einama � vir��, jei ten galima eiti }
    if (y + 1 <= 10) and (labir [x, y + 1] = '.')
    then eik (gylis + 1, x, y + 1, labir, ilgis, kelias);

    { einama �emyn, jei ten galima eiti }
    if (y - 1 > 0) and (labir [x, y - 1] = '.')
    then eik (gylis + 1, x, y - 1, labir, ilgis, kelias);

    labir [x, y] := '.' { at�ymima, kad buvo eita � nagrin�jam� lang� }
  end
end;

{ �ra�omas atsakymas (trumpiausio kelio ilgis, pats kelias) � fail� }
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
  for ck := 1 to 10 do     { pradedam ie�koti kelio i� kli��i� ruo�o kair�s }
  if labir [1, ck] = '.' then
  eik (1, 1, ck, labir, ilgis, kelias);

 { jei kelio neradome, tai �ra�om � fail� labirint�, kitu atveju rast� keli� }
  if ilgis = maxint then rasymas (0, labir)
                    else rasymas (ilgis, kelias)
end.

