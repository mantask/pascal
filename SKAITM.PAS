{ MK 2001 }
{ Trys vienodi skaitmenys }
{ Is 9 olimpiados 1 etapo vyresniems }

program olimp;

var
  ck, pg1, pg2,
  sk1, sk2 : word;
  pagr : array [2 .. 100] of word;

procedure tikrink (sk : word; var ats1, ats2 : word);
var
  ck : byte;
begin
  ats1 := 0;
  ats2 := 0;
  for ck := 2 to 100 do
  begin
    if (sk mod pagr [ck] = 0) and (sk div pagr [ck] < ck) then
    begin
      if ats1 = 0 then ats1 := ck
                  else if ats2 = 0 then ats2 := ck
                                   else break
    end
  end
end;

begin
  sk1 := 1;
  sk2 := 10000;
  for ck := 2 to 100 do
  pagr [ck] := ck * (ck + 1) + 1;

  writeln;
  for ck := sk1 to sk2 do
  begin
    tikrink (ck, pg1, pg2);
    if (pg1 <> 0) and (pg2 <> 0) then writeln (ck, ' ', pg1, ' ', pg2)
  end;
end.