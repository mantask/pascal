{
ID: vciapas1
PROG: ride
}
program ride;

var t, f : text;
    com, gr : string[6];
    sum1, sum2, ck : integer;

begin
  sum1 := 1; sum2 := 1;
  assign (t, 'ride.in');
  reset (t);
  assign (f, 'ride.out');
  rewrite (f);
  readln (t, com);
  readln (t, gr);
  for ck := 1 to (length (com)) do         {kometos varda skaidom raidem ir}
    sum1 := sum1 * (ord(com[ck]) - 64);    {suzinoje raides koda atimame 64}
  for ck := 1 to (length (gr)) do          {nes A kodas yra 65, o ateme 64}
    sum2 := sum2 * (ord(gr[ck]) - 64);     {gauname raides eiles tvarka}                  {A - 1, Z - 26}
  if (sum1 mod 47) = (sum2 mod 47) then writeln (f, 'GO')
                                   else writeln (f, 'STAY');
  close (f);
  close (t)
end.

