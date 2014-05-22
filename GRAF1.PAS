program DIJKSTROS_ALGORITMAS;

const
  max = 10;

var
  graf : array [1 .. max, 1 .. max] of integer; { grafas }
  atst, griz : array [1 .. max] of integer; { atstumai, grizimas }
  eil : array [1 .. max] of boolean; { virsuniu aibe }
  viso, { virsuniu skaicius }
  v1, v2 : integer; { pradine ir galine virsunes }
  { ----Pagalbiniai-----}
  f : text;
  pg1, pg2, pg, ck : integer;

procedure grizk (virs : integer);
begin
  if virs = v1 then writeln (virs)
  else
  begin
    write (virs, ' ');
    grizk (griz [virs])
  end
end;

function tuscia : boolean;
var
  ck : integer;
  t : boolean;
begin
  t := true;
  for ck := 1 to viso do
  if eil [ck] then
  begin
    t := false;
    break
  end;
  tuscia := t
end;

begin
  { nuskaitymas }
  assign (f, 'graf1.dat');
  reset (f);
  readln (f, viso);
  readln (f, v1, v2);
  while not eof (f) do
  begin
    readln (f, pg1, pg2, pg);
    graf [pg1, pg2] := pg;
    graf [pg2, pg1] := pg
  end;
  close (f);

  { pasiruosimas }
  for ck := 1 to viso do
  begin
    atst [ck] := - 1;
    eil [ck] := true
  end;
  atst [1] := 0;

  { paieska }
  repeat
    pg := 0;
    for ck := 1 to viso do  { randame nenagrineta virsune, kuri jungiasi su v1 }
    if eil [ck] and (atst [ck] <> -1) then pg := ck;
    if pg = 0 then break; { jei nebera jungiu virsuniu, tai ir nenagrinejam }
    for ck := 1 to viso do { tikriname gretimas virsunes }
    if (graf [pg, ck] <> 0) and { jei atstumas yra mazesnis nei buvo anksciau }
    ((atst [pg] + graf [pg, ck] < atst [ck]) or (atst [ck] = -1)) then
    begin
      atst [ck] := atst [pg] + graf [pg, ck];
      griz [ck] := pg
    end;
    eil [pg] := false
  until tuscia;

  { grizimas rekursija }
  if griz [v2] <> 0 then grizk (v2)
                    else writeln (v1, ' ir ', v2, ' yra nejungios');
  writeln ('Ilgis ', atst [v2]);
end.