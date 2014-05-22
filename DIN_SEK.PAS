{ MK 2002 }

program seka;

type
  Tseka = array [1 .. 100] of integer;

var
  f : text;
  s, ilg, pries : Tseka;
  ck1, ck2, pg, max : integer;

begin
  { prad duom skaitymas }
  assign (f, 'seka.dat');
  reset (F);
  readln (f, pg);
  for ck1 := 1 to pg do
  read (f, s [ck1]);
  close (f);

  { paleisim dinaminio programavimo principu paremta skaiciavima }
  ilg [1] := 1;
  pries [1] := 0;
  for ck1 := 2 to pg do
  begin
    max := -maxint;
    for ck2 := 1 to ck1 - 1 do
    if (ilg [ck2] > max) and (s [ck1] > s [ck2]) then
    begin
      max := ilg [ck2] + 1;
      pries [ck1] := ck2
    end;
    if max = -maxint then
    begin
      ilg [ck1] := 1;
      pries [ck1] := 0;
    end
    else ilg [ck1] := max
  end;

  { rasim ilgiausios sekos paskutini elementa }
  max := - maxint;
  for ck1 := 1 to pg do
  if ilg [ck1] > max then max := ck1;

  { rasysim atsakymus }
  pg := max;
  for ck1 := 1 to ilg [max] - 1 do
  begin
    write (s [pg], ' ');
    pg := pries [pg]
  end;
  writeln (s [pg])
end.