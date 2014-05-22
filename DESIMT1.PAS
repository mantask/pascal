program kopija;

var
  f1, f2 : text;
  eil : string [10];
  pg : char;
  ck, suma : byte;

begin
  assign (f1, 'desimt.txt');
  assign (f2, 'desimt1.txt');
  rewrite (f2);
  reset (f1);

  while not eof (f1) do
  begin
    readln (f1, eil);
    suma := 0;
    for ck := 1 to 10 do
    begin
      suma := suma + ord (eil [ck]) - 48;
    end;
    if suma mod 9 = 0 then writeln (f2, eil);
  end;

  close (f1);
  close (f2);
end.