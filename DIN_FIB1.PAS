{ MK 2002 }
{ ------- }
{ Dinaminio programavimo pavyzdys fibonadzio sekai, }
{ skaiciuojant is virsaus. }

program fibonadzio_seka;

Type
  Tfib = array [0 .. 100] of integer;

var
  fib : Tfib;
  n, ck : integer;

function f (n : integer; var fib : Tfib) : integer;
begin
  if fib [n] <> -1 then f := fib [n]
  else if n = 0 then f := 0
       else if n = 1 then f := 1
            else
            begin
              fib [n] := f (n - 1, fib) + f (n - 2, fib);
              f := fib [n]
            end
end;

begin
  for ck := 0 to 100 do
  fib [ck] := -1;
  writeln (f (23, fib))
end.