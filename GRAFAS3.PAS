{ MK 2001 }
{ Dijkstros algoritmas }
program grafas;

var
  f : text;
  pg1, pg2, pg3, ck,
  sk, { virsuniu skaicius }
  maz, { atstumas iki sios virsunes maziausias }
  v1, v2 : shortint; { pradine ir galutine virsunes }
  g : array [1 .. 100, 1 .. 100] of shortint;
  griz, { is kurios i ta virs ateita }
  ats : array [1 .. 100] of shortint; { atstumai tarp virsuniu }
  aib : set of byte;

begin
  assign (f, 'graf3.dat');
  reset (f);
  readln (f, sk, v1, v2);
  while not eof (f) do
  begin
    readln (f, pg1, pg2, pg3);
    g [pg1, pg2] := pg3;
    g [pg2, pg1] := pg3;
  end;
  close (f);

  for ck := 1 to sk do
  ats [ck] := -1;
  ats [v1] := 0;
  aib := [1 .. sk];

  while v2 in aib do
  begin
    ck := 1;
    while not (ck in aib) do
    inc (ck);
    maz := ck;
    { randame asciausiai esancia nenagrineta virsune }
    for ck := 1 to sk do
    if (ck in aib) then
    if (ats [ck] < ats [maz]) and (ats [ck] <> -1) then maz := ck;
    aib := aib - [maz];
    { randam kelius i artimiausias nuo maz virs ir irasom ilgius }
    for ck := 1 to sk do
    if (ck in aib) and (g [maz, ck] <> 0) then
    if (ats [ck] = -1) or ((ats [maz] + griz [ck]) < ats [ck]) then
    begin
      ats [ck] := ats [maz] + g [maz, ck];
      griz [ck] := maz;
    end;
  end;

  pg1 := v2;
  while v1 <> pg1 do
  begin
    write (pg1, ' ');
    pg1 := griz [pg1];
  end;
  writeln (v1)
end.