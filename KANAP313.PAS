{ MK 2002                    }
{ Mantas Kanaporis           }
{ Vilniaus œemynos gimnazija }
{ -------------------------- }
{ III met÷ I skyrius         }
{ 3 uÿdavinys                }

{
 Pradÿioje suformuosime hierarchin‘ med‘, t. y., nustatysime, kam
 pavaldus pirmasis narys, kam pavaldus pirmojo nario valdininkas ir t. t.
 Analogi’kai ir su antruoju nariu. Tada rasime pirm–j‘ nuo hierarchinio
 medÿio apa—ios bendr– nar‘, kuris ir bus bendras j÷ valdininkas.
}

Program KANAP03;

type
  Tmas = array [1 .. 20] of integer;

var
  mas : TMas;
  v1, v2, viso, ats : integer;

procedure nuskaitymas (var v1, v2, viso : Integer; var mas : TMas);
var
  f : Text;
  ck : Integer;
begin
  assign (f, 'duom.txt');
  reset (f);
  readln (f, viso, v1, v2);
  mas [1] := 0;
  for ck := 2 to viso do
  readln (f, mas [ck]);
  close (f)
end;

function rask (v1, v2 : Integer; var mas : Tmas) : Integer;
var
  mas1, mas2 : Tmas;
  ck1, ck2, viso1, viso2 : Integer;
begin
  viso1 := 0;
  while v1 <> 0 do
  begin
    inc (viso1);
    mas1 [viso1] := v1;
    v1 := mas [v1];
  end;
  viso2 := 0;
  while v2 <> 0 do
  begin
    inc (viso2);
    mas2 [viso2] := v2;
    v2 := mas [v2]
  end;
  for ck1 := 1 to viso1 do
  for ck2 := 1 to viso2 do
  if mas1 [ck1] = mas2 [ck2] then
  begin
    rask := mas1 [ck1];
    exit
  end
end;

procedure rasymas (ats : integer);
var
  f : TExt;
begin
  assign (f, 'rez.txt');
  rewrite (f);
  writeln (f, ats);
  close (f)
end;

begin
  nuskaitymas (v1, v2, viso, mas);
  ats := rask (v1, v2, mas);
  rasymas (ats)
end.
