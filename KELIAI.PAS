program keliai;

var
  f : text;
  g : array [1 .. 10, 1 .. 10] of boolean; { pats grafas }
  eile : array [1 .. 100] of byte; { eile }
  ck, pgx, pgy,
  galv, uod, { galva, uodega }
  br, virs, { briaunu ir virsuniu skaicius }
  prad, pab : byte; { pradinis ir galutinis miestai }
  yra : boolean; { ar yra kelias }

begin
  assign (f, 'kel.dat');
  reset (f);
  readln (f, prad, pab);
  readln (f, virs, br);
  for ck := 1 to br do
  begin
    readln (f, pgx, pgy);
    g [pgx, pgy] := true;
    g [pgy, pgx] := true;
  end;
  close (f);

  galv := 1;
  uod := 2;
  eile [1] := prad;
  yra := false;
  while (galv < uod) and not yra do
  begin
    for ck := 1 to virs do
    if (g [eile [galv], ck]) and (ck <> eile [galv]) then
    begin
      eile [uod] := ck;
      inc (uod);
      g [eile [galv], ck] := false;
      g [ck, eile [galv]] := false;
      if ck = pab then
      yra := true
    end;
    inc (galv)
  end;

  writeln (yra);
end.