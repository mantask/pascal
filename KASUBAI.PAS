program kasubai;

var
  liek : integer;
  ilg : longint;

begin
  ilg := 1;
  liek := 1;
  while liek <> 0 do
  begin
    inc (ilg);
    liek := liek * 10 + 1;
    if liek >= 2003 then liek := liek mod 2003
  end;
  writeln (ilg)
end.