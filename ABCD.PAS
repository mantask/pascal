{ (a + b + c + d) ^4 = abcd}
program keista;
  var a, b, c, d : 0 .. 9;
      s : longint;
begin
  writeln ('Rezultatai:');
  for a := 0 to 9 do
  for b := 0 to 9 do
  for c := 0 to 9 do
  for d := 0 to 9 do
  begin
    s := a + b + c + d;
    s := s * s * s * s;
    if (s = (a * 1000 + b * 100 + c * 10 + d)) and
       (a <> b) and (b <> c) and (c <> d) then writeln (a, b, c, d);
  end;
end.