{Vytautas �iapas
 VTGTM lic�jus
 8 skyrius
 4 u�davinys}

program jpm084;

var i, j : 1..60;
    n : 1..10;
    x, y : string [60];
    t, f : text;

begin
  assign (t, 'duom.txt');
  reset (t);
  assign (f, 'rez.txt');
  rewrite (f);
  readln (t, n);
  for j := 1 to n do
   begin
    y := '';
    readln (t, x);
    for i := 1 to 60 do
     begin
      if (x[i] = ' ') and ((x [i+1]=' ') or (x[i+1] = ',') or
         (x[i+1] = '.') or (x[i+1] = ':') or (x[i+1] = ';')) then y := y
      {Jeigu yra du eiantys i� eil�s tarpai,
       tada naujoj eilut�j vienas tarpas trinamas}
      else if (x[i] = ' ') and ((x[i-1] = '(')  or (ord (x[i-1]) = 247))  then y := y
      {Kad b�t� tarpas prie� atsidaran�ias kabutes ir skliaustus}
      else if (x[i] = ' ') and ((x[i+1] = ')') or (ord (x[i+1]) = 242)) then y := y
      {Kad neb�t� tarpo tarp skliaust� ir kabu�i�}
      else if (x[i] = ',') or (x[i] = '.') or
             (x[i] = ':') or (x[i] = ';') then
               begin
                  y := y + x[i];
                  if x [i+1] <> ' ' then y := y + ' '
                end
      {Jeigu po '.', ',', ':', ';' n�ra tarpo, jis sukuriamas naujoje eilut�je}
      else y := y + x[i];
     end;
    writeln (f, y);
   end;
  close (t);
  close (f);
end.
