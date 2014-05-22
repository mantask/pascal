{MK 2001}
{Sprendimas Baltic Olimpiad of Informatic 2000 uzdaviniui Elektronine Plokstele}
program BOI_PLOKSTELE;
  Type Tats = record {rasto mazgo grandines kelias}
              num : word;
              kryptys : string
      end;
      Ttinkl = array [1 .. 15, 1 .. 15] of 0 .. 2;
  var ck, ckx, cky, {pagalbiniai ciklo kintamieji}
      pg, {kiek ziedu sudaro el plokstele, reikalingas ciklui}
      kr,{reikalingas ziedam tikrinant}
      ilg : byte;{tinklelio iligis}
      tinkl : Ttinkl;{tinklelis. 0-tuscia,1-mazgas,2-grandine}
      max : word;{max rastu kontaktu skaicius}
      f : text;{tekstinis failas}
      pgAts, Atsak : string; {pagalbinis kvieciant galima procedura}
      pgTaip : boolean; {ar galima sujungti}
      ats : Tats;{mazgo numeris ir jungimo kelias}
      mATS : array [1 .. 120] of Tats;{galutinis atsakymas su mazgu nr ir keliais}

{varant visa sita suda reikai tikrinti ar rastas rekursiskas kelias yra trumpiausias}
{reikia sutvarkyti, kad 2 irasytu i tinlk tik paciam gale, kai jau rastas trumpiausias kelias ir isnagrineti visis variantai}
  procedure galima (x, y : byte; var tinkl : Ttinkl; var taip : boolean; var pgats : string; ats : string);
  begin
    if taip then
    begin
      if (pgAts = '') or (length (ats) < length (pgAts)) then pgAts := ats;
      exit
    end
    else begin
{E}   if (x + 1) > ilg then begin taip := true; exit end
      else if not taip and (tinkl [x + 1, y] = 0) then
      begin
        if tinkl [x, y] <> 1 then tinkl [x, y] := 2;
        galima (x + 1, y, tinkl, taip, pgAts, ats + 'E');
        if not taip then tinkl [x, y] := 0;
      end;
{W}   if (x - 1) < 1 then begin taip := true; exit end
      else if not taip and (tinkl [x - 1, y] = 0) then
      begin
        if tinkl [x, y] <> 1 then tinkl [x, y] := 2;
        ats := ats + 'W';
        galima (x - 1, y, tinkl, taip, pgAts, ats);
        if not taip then ats := copy (ats, 1, length (ats) - 1);
        if not taip then tinkl [x, y] := 0;
      end;
{N}   if (y - 1) < 1 then begin taip := true; exit end
      else if (not taip and (tinkl [x, y - 1] = 0)) then
      begin
        if tinkl [x, y] <> 1 then tinkl [x, y] := 2;
        ats := ats + 'N';
        galima (x, y, tinkl, taip, pgAts, ats);
        if not taip then ats := copy (ats, 1, length (ats) - 1);
        if not taip then tinkl [x, y] := 0;
      end;
{S}   if (y + 1) > ilg then begin taip := true; exit end
      else if not taip and (tinkl [x, y + 1] = 0) then
      begin
        if tinkl [x, y] <> 1 then tinkl [x, y] := 2;
        ats := ats + 'S';
        galima (x, y, tinkl, taip, pgAts, ats);
        if not taip then ats := copy (ats, 1, length (ats) - 1);
        if not taip then tinkl [x, y] := 0;
      end
    end
  end;

begin
  {nuskaitomi prad. duomenys}
  assign (f, 'ele.in');
  reset (f);
  readln (f, ilg);
  for cky := 1 to ilg do
  begin
    for ckx := 1 to ilg do
    read (f, tinkl [ckx, cky]);
    readln (f);
  end;
  close (f);

  {tikrinami visi mazgai}
  max := 0; {kol kas nera rastu susungtu mazgu}
  if ilg mod 2 = 1 then pg := ilg div 2 + 1
                   else pg := ilg div 2;
  kr := 0;
  while kr < pg do
  begin
    for ckx := 1 + kr to ilg - kr do
    begin
      if tinkl [ckx, kr + 1] = 1 then
      begin
        pgTaip := false;
        pgAts := '';
        galima (ckx, 1 + kr, tinkl, pgTaip, pgAts, atsak);
        if pgTaip then
        begin
          inc (max);
          mAts [max].num := ckx;
          mAts [max].kryptys := pgAts;
        end;
      end;
      if tinkl [ckx, ilg - kr] = 1 then
      begin
        pgTaip := false;
        pgAts := '';
        galima (ckx, ilg - kr, tinkl, pgTaip, pgAts, atsak);
        if pgTaip then
        begin
          inc (max);
          mAts [max].num := ilg * (ilg - 1) + ckx;
          mAts [max].kryptys := pgAts;
        end;
      end;
    end;
    for cky := 1 + kr to ilg - kr do
    begin
      if tinkl [kr + 1, cky] = 1 then
      begin
        pgTaip := false;
        pgAts := '';
        galima (kr + 1, cky, tinkl, pgTaip, pgAts, atsak);
        if pgTaip then
        begin
          inc (max);
          mAts [max].num := ilg * (cky - 1) + 1;
          mAts [max].kryptys := pgAts;
        end;
      end;
      if tinkl [ilg - kr, cky] = 1 then
      begin
        pgTaip := false;
        pgAts := '';
        galima (ilg - kr, cky, tinkl, pgTaip, pgAts, atsak);
        if pgTaip then
        begin
          inc (max);
          mAts [max].num := ilg * cky;
          mAts [max].kryptys := pgAts;
        end;
      end;
    end;
    inc (kr)
  end;

  {surasomi atsakymai}
{  assign (f, 'ele.out');
  rewrite (f);
}  writeln ({f,} max);
  for ck := 1 to max do
  begin
    write ({f, }mATS [ck].num, ' ');
    pg := 1;
    while mATS [ck].kryptys [pg] <> '' do
    begin
      write ({f,} mATS [ck].kryptys [pg]);
      inc (pg);
    end;
  end;
{ close (f);}
end.