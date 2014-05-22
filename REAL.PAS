{ panaudojam masyva tustiems elemtams kaupti, tada is likuciu uzpildom ji.
 Po to imam likucius ir ziurim ar galim sukeisti su uzpildytu masyvu. }
program realizacija;

type
  Tirasas = array [1 .. 4] of word; { numeris, dienu skaicius, pelnas, tvarka }
  Tkont = array [1 .. 1000] of Tirasas;

var
  f : text;
  pelnas : integer;
  skTust, { laisvu dienu skaicius }
  plius,
  didz, { brangiausias konteineris }
  pg1, pg, d, {  }
  ck, sk : word; { konteineriu skaicius }
  kont : Tkont;
  pgI : Tirasas;
  tusti : array [1 .. 1000] of word;

procedure quicksort (k1, k2 : word; var kont : Tkont; nr : byte);
var
  vid, pg,
  pg1, pg2 : word;
begin
  vid := kont [(k2 + k1) div 2, NR];
  pg1 := k1;
  pg2 := k2;
  repeat
    while kont [pg1, nr] < vid do inc (pg1);
    while kont [pg2, nr] > vid do dec (pg2);
    if pg1 < pg2 then
    begin
      pg := kont [pg1, nr];
      kont [pg1, nr] := kont [pg2, nr];
      kont [pg2, nr] := pg;
      inc (pg1);
      dec (pg2);
    end;
  until pg1 > pg2;
  if k1 < pg2 then quicksort (k1, pg2, kont, nr);
  if pg1 < k2 then quicksort (pg1, k2, kont, nr)
end;

begin
  assign (f, 'real.dat');
  reset (f);
  readln (f, sk);
  for ck := 1 to sk do
  begin
    kont [ck, 1] := ck;
    kont [ck, 4] := 0;
    readln (f, kont [ck, 2], kont [ck, 3]);
  end;
  close (f);

  quicksort (1, sk, kont, 2);
  d := kont [sk, 2];

  { rasim didziausia dienos konteineri ir ji paliksim }
  pg := 1;
  for ck := 1 to d do
  begin
    while ck < kont [pg, 3] do
    begin
      if kont [pg, 3] > kont [didz, 3] then
      didz := pg;
      inc (pg);
    end;
    if pg = ck then kont [didz, 4] := pg
               else
               begin
                 inc (sktust);
                 tusti [skTUst] := ck;
                 dec (pg);
               end
  end;

  { uzpildysim laisvas dienas }
  quicksort (1, sk, kont, 3);
  pg1 := 1;
  for ck := 1 to sktust do
  begin
    while kont [pg1, 2] > tusti [ck] do inc (pg1); { brang. kont. iki laisvos }
    kont [tusti [ck], 4] := pg;
    inc (pg);
  end;

  { rasim ar nera labiau vertu parduoti konteineriu, nei jau radome }
{  quicksort (1, sk, kont, 1);
  pg := 1;
  for ck := 1 to sk do
  begin
    while () and () do inc (pg);
  end;


  { surasysim likucius }
  plius := 0;
  for ck := d + 1 to sk do
  begin
    while kont [ck + plius, 4] <> 0 do
    inc (plius);
    kont [ck + plius, 4] := ck;
  end;

  { apskaiciuosim pelna }
  quicksort (1, sk, kont, 1);
  pelnas := 0;
  for ck := 1 to sk do
  if kont [ck, 4] <= d then pelnas := pelnas + kont [ck, 3];

  assign (f, 'real.rez');
  rewrite (f);
  writeln (pelnas);
  for ck := 1 to sk do
  writeln (kont [ck, 4]);
  close (f);
end.
{konteineriai:
>>> dienu skaicius | pelnas
ats :
pelnas
tvarka}

