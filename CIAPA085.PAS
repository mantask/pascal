{Vytautas ∂iapas
 VTGTM lic”jus
 8 skyrius
 5 uÿdavinys}

program jpm085;

var eil : string [80];
    f, t : text;
    a : char;
    i : 1..80;

begin
  assign (f, 'duom.txt');
  reset (f);
  assign (t, 'rez.txt');
  rewrite (t);
  readln (f, eil);
  i := 1;
  while i <= 80 do            {Sukei—iame pirm– ir antr– elementus vietomis}
    begin
      a := eil [i];
      eil [i] := eil [i+1];
      eil [i + 1] := a;
      i := i + 2;
    end;
  for i := 1 to 80 do
    write (t, eil[i]);
  close (t);
  close (f)
end.