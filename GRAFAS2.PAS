{ MK 2001 }
{ paieskos i ploti algoritmas }
program grafas;

var
  f : text;
  g : array [1 .. 100, 1 .. 100] of boolean;
  eil,   { nagrinejamu virs eile }
  griz,  { is kurios i kuria ateita }
  ats : array [1 .. 100] of shortint; { atstumai tarp virsuniu }
  pg1, pg2, ck, ck1,
  ilg, { atstumas nuo pirmos virsunes iki nagrinejamos }
  galv, uod, { pirma nagrinejama ir pirma laisva }
  sk, { virsuniu skaicius }
  v1, v2 : shortint; { pradine ir galine virsunes }


begin
  assign (f, 'graf.dat');
  reset (f);
  readln (f, v1, v2);
  sk := 0;
  while not eof (f) do
  begin
    inc (sk);
    readln (f, pg1, pg2);
    g [pg1, pg2] := true;
    g [pg2, pg1] := true
  end;
  close (F);

  for ck := 1 to sk do
  ats [ck] := -1;
  ats [v1] := 0;

  eil [1] := v1;
  galv := 1;
  uod := 2;

  ilg := 0;
  while (galv < uod) and (ats [v2] = -1) do
  begin
    inc (ilg);
    for ck := galv to uod - 1 do
    begin
      for ck1 := 1 to sk do
      if (g [ck, ck1]) and (ats [ck1] = -1) then
      begin
        eil [uod] := ck1;
        inc (uod);
        ats [ck1] := ilg;
        griz [ck1] := ck;
      end;
      inc (galv);
    end
  end;

  pg1 := v2;
  while pg1 <> v1 do
  begin
    write (pg1, ' ');
    pg1 := griz [pg1]
  end;
  writeln (pg1)
end.