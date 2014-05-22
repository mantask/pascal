program generatorius;

const
  viso = 50;

var
  f : Text;
  cK : Integer;

begin
  assign (f, 'duom.txt');
  rewrite (f);
  for ck := 1 to viso do
  writeln (f, '0.5 ', ck * 2 - 1, ' ', '5.5 ', ck * 2 - 1);
  close (f)
end.