{ MK 2002 }
{ Kompiuterija Nr. 60 Kasubos skyrius }
program kvardratai;

Type
  TMas = array [1 .. 100] of 0 .. 9;

var
  sk : longint;

procedure sudek (sk, nuo : integer; var ilg : Integer; var mas : Tmas);
var
  pz : Integer;
  pg : Longint;
begin
  pg := sk;
  pz := nuo + 1;
  while pg <> 0 do
  begin
    if pz > ilg then ilg := pz;
    pg := mas [pz] + pg;
    mas [pz] := pg mod 10;
    pg := pg div 10;
    inc (pz)
  end
end;

procedure kvadr (sk : Longint; var ilg : integer; var mas : Tmas);
var
  sk1, sk2, pg : longint;
  pg1, pg2, pz1, pz2 : Integer;
begin
  fillchar (mas, sizeof (mas), 0);
  ilg := 0;
  sk1 := sk + 1;
  pz1 := -1;
  while sk1 > 0 do
  begin
    pg1 := sk1 mod 10;
    sk1 := sk1 div 10;
    inc (pz1);
    sk2 := sk - 1;
    pz2 := -1;
    while sk2 > 0 do
    begin
      pg2 := sk2 mod 10;
      sk2 := sk2 div 10;
      inc (pz2);
      pg := pg1 * pg2;
      sudek (pg, pz1 + pz2, ilg, mas);
    end
  end
end;

procedure tikrink (sk : longint);
var
  ok : boolean;
  ck, pg, ilg : Integer;
  mas : Tmas;
begin
  kvadr (sk, ilg, mas);
  if ilg mod 2 = 0 then
  begin
    pg := ilg div 2;
    ok := true;
    for ck := 1 to pg do
    if mas [ck] <> mas [ck + pg] then
    begin
      ok := false;
      break
    end;
    if ok then writeln (sk, ' x ', sk)
  end
end;

begin
  sk := 0;
  writeln ('::::::::::::|mk2002:::::::::::::::::::::::::::::::::::::');
  while sk < 2147483645 do
  begin
    inc (sk);
    tikrink (sk)
  end
end.