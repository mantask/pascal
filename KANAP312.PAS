{ MK 2002                    }
{ Mantas Kanaporis           }
{ Vilniaus œemynos gimnazija }
{ -------------------------- }
{ III met÷ I skyrius         }
{ 2 uÿdavinys                }

{
 Taikysime modifikuot– paie’kos ‘ plot‘ algoritm–. Imsime
 vir’◊n“ ir, jei galima, j– ‘trauksime ‘ pirm– ar tai antr– klas“ -
 masyv–.
}

Program KANAP02;

Type
  TG = array [1 .. 20, 1 .. 20] of boolean;
  Tmas = array [1 .. 20] of integer;

var
  viso : Integer;
  ok : boolean;
  g : TG;


procedure nuskaitymas (var viso : INteger; var G : TG);
var
  f : TExt;
  v1, v2, ck, kiek : Integer;
begin
  fillchar (g, sizeof (g), 0);
  assign (f, 'duom.txt');
  reset (f);
  readln (f, viso, kiek);
  for ck := 1 to kiek do
  begin
    readln (f, v1, v2);
    if v1 <> v2 then
    begin
      g [v1, v2] := true;
      g [v2, v1] := true
    end
  end;
  close (f)
end;

function galima (v : Integer; var m1, m2 : Tmas) : boolean;
var
  ck : integer;
  ok : boolean;
begin
  ok := true;
  ck := 1;
  while (ck <= 20) and (m1 [ck] <> 0) do
  begin
    if g [m1 [ck], v] then
    begin
      ok := false;
      break
    end;
    inc (ck)
  end;
  if ok then
  begin
    m1 [ck] := v;
    galima := true;
    exit
  end;
  ok := true;
  ck := 1;
  while (ck <= 20) and (m2 [ck] <> 0) do
  begin
    if g [m2 [ck], v] then
    begin
      ok := false;
      break
    end;
    inc (ck)
  end;
  if ok then
  begin
    m2 [ck] := v;
    galima := true;
    exit
  end;
  galima := false
end;

function rask (viso : Integer; var g : Tg) : boolean;
var
  m1, m2, eil : Tmas;
  ck, gal, uod : Integer;
  jau : set of 1 .. 20;
begin
  fillchar (m1, sizeof (m1), 0);
  fillchar (m2, sizeof (m2), 0);
  eil [1] := 1;
  gal := 1;
  uod := 2;
  jau := [1 .. viso];
  while jau <> [] do
  begin
    if gal = uod then
    begin
      for ck := 1 to viso do
      if ck in jau then
      begin
        eil [gal] := ck;
        inc (uod);
        break
      end
    end;

    if galima (eil [gal], m1, m2) then
    begin
      for ck := 1 to viso do
      if (ck in jau) and (g [eil [gal], ck]) then
      begin
        eil [uod] := ck;
        inc (uod)
      end;
      jau := jau - [eil [gal]]
    end
    else
    begin
      rask := false;
      exit
    end;

    inc (gal)
  end;
  rask := true
end;

procedure rasymas (ok : boolean);
var
  f : Text;
begin
  assign (f, 'rez.txt');
  rewrite (f);
  if ok then writeln (f, 'GALIMA')
        else writeln (f, 'NEGALIMA');
  close (f)
end;

begin
  nuskaitymas (viso, g);
  ok := Rask (viso, g);
  rasymas (ok)
end.
