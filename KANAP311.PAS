{ MK 2002                    }
{ Mantas Kanaporis           }
{ Vilniaus œemynos gimnazija }
{ -------------------------- }
{ III met÷ I skyrius         }
{ 1 uÿdavinys                }

{
 Remsimes Oilerio teoremomis. Jei grafas turi n” vienos arba dvi
 nelyginio laipsnio vir’◊nes, tai Oilerio cikl– jis turi, prie’ingu
 atveju - neturi.
}

Program KANAP01;

type
  Tmas = array [1 .. 50, 1 .. 50] of boolean;

var
  mas : Tmas;
  viso : Integer;
  ok : boolean;

procedure nuskaitymas (var viso : Integer; var mas : Tmas);
var
  f : Text;
  ck, kiek, v1, v2 : Integer;
begin
  fillchar (mas, sizeof (mas), 0);
  assign (f, 'duom.txt');
  reset (f);
  readln (f, viso, kiek);
  for ck := 1 to kiek do
  begin
    readln (f, v1, v2);
    if v1 <> v2 then
    begin
      mas [v1, v2] := true;
      mas [v2, v1] := true
    end;
  end;
  close (f)
end;

function rask (viso : integer; var mas : Tmas) : boolean;
var
  ck, ck1, nelyg, pg : Integer;
begin
  nelyg := 0;
  for ck := 1 to viso do
  begin
    pg := 0;
    for ck1 := 1 to viso do
    if mas [ck, ck1] then inc (pg);
    if pg mod 2 = 1 then inc (nelyg)
  end;
  if (nelyg = 2) or (nelyg = 0) then rask := true
                                else rask := false
end;

procedure rasymas (ok : boolean);
var
  f : Text;
begin
  assign (f, 'rez.txt');
  rewrite (f);
  if ok then writeln (f, 'PAVYKS')
        else writeln (f, 'NEPAVYKS');
  close (f)
end;

begin
  nuskaitymas (viso, mas);
  ok := rask (viso, mas);
  rasymas (ok)
end.
