program kasuba;

var
  ckx, cky : byte;
  pg, sum1, sum2 : word;
  lent : array [1 .. 7, 1 .. 7] of byte;
  sumos : array [1 .. 7, 1 .. 2] of word;

begin
  for ckx := 1 to 7 do
  write ('  --');
  writeln;

  for cky := 1 to 7 do
  begin
    for ckx := 1 to 7 do
    begin
      pg := (cky - 1) * 7 + ckx;
      lent [ckx, cky] := pg;
      inc (sumos [cky, 1], pg);
      inc (sumos [ckx, 2], pg);
      write (pg : 4)
    end;
    writeln (' | ', sumos [cky, 1] : 4)
  end;

  for ckx := 1 to 7 do
  write ('  --');
  writeln;
  for ckx := 1 to 7 do
  write (sumos [ckx, 2] : 4);
  writeln;

  for cky := 1 to 2 do
  for ckx := 1 to 7 do
  if sumos [ckx, cky] mod 2 = 0 then inc (sum1, sumos [ckx, cky])
                                else inc (sum2, sumos [ckx, cky]);

  writeln;
  writeln ('Nelyg - ', sum1, ' Lyg - ', sum2)
end.