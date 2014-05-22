{ MK 2002 }
{ ------- }
{ Dinaminio programavimo pavyzdys fibonadzio sekai, }
{ skaiciuojant is apacios. }

program fibonadzio_seka;

var
  fib : array [0 .. 100] of integer;
  ck : integer;

begin
  fib [0] := 0;
  fib [1] := 1;
  ck := 1;
  while (ck <= 100) and (maxint - fib [ck - 1] > fib [ck]) do
  begin
    inc (ck);
    fib [ck] := fib [ck - 1] + fib [ck - 2]
  end;
  writeln (ck, ' fibonadzio seko narys ', fib [ck])
end.