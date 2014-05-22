{ MK 2002 }
{ XI olimpiados 3 etapo 1 dalies uzdavinys }
{ ======================================== }
program lobiai;

var
  f : text;
  virs : array [1 .. 10000, 1 .. 3] of integer; { is kur; maz, did verte }
  pgC : char;
  ck, pgnr, pgsk, pg,
  skKryz, skAkl : integer;
  didz : boolean;

begin
  { Pradiniu duomenu skaitymas }
  assign (f, 'lobiai10.dat');
  reset (f);
  pg := 0;
  readln (f, skKryz, skAkl);
  for ck := 1 to skKryz + skAkl do virs [ck, 1] := -1;
  while not eof (f) do
  begin
    readln (f, pgc, pgsk, pgnr);
    if pgc = 'A' then
    begin
      inc (pg);
      virs [pg + skKryz, 1] := pgsk;
      virs [pg + skKryz, 2] := pgnr;
      virs [pg + skKryz, 3] := pgnr;
    end
    else virs [pgnr, 1] := pgsk
  end;
  close (f);

  { Rasime didz ir maz kiekvienos virsunes vertes }
  for ck := 1 to skAkl do
  begin
    pgnr := ck + skKryz - 1;
    if (virs [virs [pgnr, 1], 2] > virs [pgnr, 2]) and (virs [virs [pgnr, 1], 2] <> 0)
    then virs [virs [pgnr, 1], 2] := virs [pgnr, 2];
    if (virs [virs [pgnr, 1], 3] < virs [pgnr, 3]) and (virs [virs [pgnr, 1], 3] <> 0)
    then virs [virs [pgnr, 1], 3] := virs [pgnr, 3];
  end;
  for ck := 1 to skKryz do
  for pgnr := 1 to skKryz do
  begin
    if (virs [virs [pgnr, 1], 2] > virs [pgnr, 2]) and (virs [virs [pgnr, 1], 2] <> 0)
    then virs [virs [pgnr, 1], 2] := virs [pgnr, 2];
    if (virs [virs [pgnr, 1], 3] < virs [pgnr, 3]) and (virs [virs [pgnr, 1], 3] <> 0)
    then virs [virs [pgnr, 1], 3] := virs [pgnr, 3];
  end;

  { ciklu pereisim visais lygmenimis ir suskaiciuosim atsakyma }
  didz := true;
  pgnr := 1;
  while virs [pgnr, 1] <> 0 do inc (pgNr); { pgNR - iejimo numeris }
  while pgnr <= skKryz do
  begin
    if didz then pgsk := 0
            else pgsk := maxint;
    for ck := 1 to skKryz + skAkl do
    if virs [ck, 1] = pgnr then
    begin
      if (didz) and (virs [ck, 2] > pgsk) then pgnr := ck
    end
    else if (not didz) and (virs [ck, 3] < pgsk) then pgnr := ck;
    didz := not didz;
  end;

  writeln (virs [pgnr, 2])
end.