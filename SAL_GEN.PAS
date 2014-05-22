{ MK 2001 }
{ programa generuoja zemelapi salos.pas uzdaviniui }
program gen;

const
  ilgx = 1000;
  ilgy = 1000;
  sal = 10; { salu teritorija uzims 10% }

var
  f : text;
  ckx, cky : integer;
  sk : byte;

begin
  assign (f, 'sal.dat');
  rewrite (f);
  writeln (f, ilgx, ' ', ilgy);
  for cky := 1 to ilgy do
  begin
    for ckx := 1 to ilgx do
    begin
      sk := random (100);
      if sk < sal then write (f, 1)
                  else write (f, 0);
    end;
    writeln (f);
  end;
end.
