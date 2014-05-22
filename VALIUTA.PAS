{ MK 2002 }
{ IV Olimpiados 41 uzd }
program valiuta;

type
  Tg = array [1 .. 10, 1 .. 10] of real;
  Tgriz = array [1 .. 10] of integer;


var
  g : Tg;
  pg, ck, viso : Integer;
  pelnas : real;
  griz : Tgriz;

procedure nuskaitymas (var viso : Integer; var g : Tg);
var
  f : text;
  ckx, cky : integer;
begin
  assign (f, 'valiuta.dat');
  reset (f);
  readln (f, viso);
  for cky := 1 to viso do
  begin
    for ckx := 1 to viso do
    read (f, g [ckx, cky]);
    readln (f)
  end;
  close (F)
end;

procedure paieska (nr : Integer; var pg1 : Integer; var pelnas : real; var griz : Tgriz);
var
  atgal : Tgriz;
  aib : set of 1 .. 10;
  ck, pg : integer;
  atst : array [1 .. 10] of real;
begin
  for ck := 1 to viso do
  begin
    atst [ck] := 0;
    atgal [ck] := 0
  end;
  aib := [1 .. viso];
  atst [nr] := 1;
  while aib <> [] do
  begin
    pg := 0;
    for ck := 1 to viso do
    if (ck in aib) and ((pg = 0) or (atst [ck] > atst [pg])) then pg := ck;
    if pg = 0 then break;
    aib := aib - [pg];
    for ck := 1 to viso do
    if (g [pg, ck] > 0) and (g [pg, ck] * atst [pg] > atst [ck]) then
    begin
      atgal [ck] := pg;
      atst [ck] := atst [pg] * g [pg, ck]
    end;
  end;
  if atst [nr] > pelnas then
  begin
    pelnas := atst [nr];
    griz := atgal;
    pg1 := nr
  end
end;

procedure rasyk (nr : integer; pirm : boolean);
begin
  if (nr = pg) and not pirm then writeln (nr :3)
  else
  begin
    write (nr :3);
    rasyk (griz [nr], false)
  end
end;

begin
  nuskaitymas (viso, g);

  pelnas := 1;
  for ck := 1 to viso do
  griz [ck] := 0;

  for ck := 1 to viso do
  paieska (ck, pg, pelnas, griz);
  if pelnas = 1 then writeln ('NERA')
  else
  begin
    write ((pelnas - 1) * 100 :1 :1, '   ');
    rasyk (pg, true)
  end
end.