{MK 2001}
{Sprendimas Baltic Olimpiad of Informatic 2000 uzdaviniui Korys}
program BOI2000_korys;
  var f : text;
      korys : array [1 .. 197, 1 .. 197] of byte; {korys}
      didz : array [1 .. 197] of byte; {didziausi skaiciai}
      ck1, ck2, {ciklo kintamieji}
      kiek,     {krastines ilgis}
      pg, pg1 : byte; {pagalbinis didziausio skaiciaus eiluteje radimui}
      tarpsuma, {pagalbinis}
      max,     {max = kiek * 2 - 1}
      suma : word;  {galutinis atsakymas}
      sk : integer; {randa didziausio skirtuma tarp korio eilutes}
      didinti : boolean; {reikalingas nuskaitymui}

 procedure hon (l1, l2 : byte; tarpsuma : word; var suma : word; sk : integer);
 begin
   if l1 > max then
   begin
     if sk > 0 then tarpsuma := tarpsuma + sk;
     if  tarpsuma > suma then suma := tarpsuma;
   end else
   begin
      if didz [l1] - korys [l1, l2] > sk then sk := didz [l1] - korys [l1, l2];
      hon (l1 + 1, l2, tarpsuma + korys [l1, l2], suma, sk);
      if l1 <= kiek then
      hon (l1 + 1, l2 + 1, tarpsuma + korys [l1, l2], suma, sk);
   end
 end;

begin
  {nuskaitymas}
  assign (f, 'Hon.in');
  reset (f);
  readln (f, kiek);
  pg1 := kiek - 1;
  didinti := true;
  max := kiek * 2 - 1;
  for ck1 := 1 to max do
  begin
    if pg1 = max then didinti := false;
    if didinti then inc (pg1) else dec (pg1);
    for ck2 := 1 to  pg1 do
    read (f, korys [ck1, ck2]);
    readln (f);
  end;
  close (f);

  {didziausiu kiekvienos eilutes skaiciu radimas}
  for ck1 := 1 to max do
  begin
    pg := 0;
    for ck2 := 1 to max do
    if korys [ck1, ck2] > pg then pg := korys [ck1, ck2];
    didz [ck1] := pg;
  end;

  {skaiciavimas}
  tarpsuma := 0;
  suma := 0;
  for ck1 := 1 to kiek do
  begin
    sk := 0;
    tarpsuma := 0;
    hon (1, ck1, tarpsuma, suma, sk);
  end;

  {rezultatu irasymas}
  assign (f, 'hon.out');
  rewrite (f);
  writeln (f, suma);
  close (f);
end.