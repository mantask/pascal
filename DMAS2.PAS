{didziausias masyvas 1360x1360 of boolean}
program didelis_masyvas2;
Const
  max = 1360;
  pgmax = 170; {1000 div 8}
  bits : array [0 .. 7] of byte = (1, 2, 4, 8, 16, 32, 64, 128);
type
  Telementas = array [0 .. pgmax - 1] of byte; {1000 div 8}
  Tmas = array [0 .. max - 1] of ^Telementas;
Var
  mas : Tmas;
  ck : Word;

procedure itrauk (var elementas : Telementas; y : word);
begin
  elementas [y div 8] := elementas [y div 8] or bits [y mod 8]
end;

procedure istrauk (var elementas : Telementas; y : word);
begin
  elementas [y div 8] := elementas [y div 8] xor bits [y mod 8]
end;

function parodyk (x, Y : word) : boolean;
begin
   if (mas [x]^[y div 8] and bits [y mod 8]) = bits [y mod 8]
   then parodyk := true
   else parodyk := false;
end;

begin
  {atminties ir pradiniu reiksmiu isskyrimas}
  for ck := 0 to max - 1 do
  begin
    new (mas [ck]);
    fillchar (mas [ck]^, sizeof (mas [ck]^), 0);
  end;

  {testavimas}
  itrauk (mas [1319]^, 1319);
  writeln (parodyk (1319, 1319));

  {atminties islaisvinimas}
  for ck := 0 to max - 1 do
  dispose (mas [ck])
end.