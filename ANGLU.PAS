{ ---------------------------- }
{ MoKa 1 Mantas Kanaporis 2001 }
{ ---------------------------- }
program MoKa1;
   uses crt, dos, windos;
   const mnZ = 3; mnN = 2; mnT = 0; {mn ziba, neziba, tekstas (spalvu kodai)}
         Zd = 500;
         ilgis = '                            °±²'; {mn ilgis 31}
         duom = '²±°                             °±²'; {duomenu lauko plotis}
         fonas = 0; {standartinis fonas}
         gradiantas = 3; {patamsejimai apie meniu juosteles}
         diena: array [0..6] of string [14] =
           ('Sekmadienis', 'Pirmadienis', 'Antradienis', 'TreÑiadienis',
            'Ketvirtadienis', 'Penktadienis', '¾estadienis');

   type mnP = array [1..5] of string [25]; {mn pavadinimu masyvai}
        zodyn = array [1..Zd] of string[28];
   var mnV, mnA: mnP; {virsutinio ir apatinio mn pav}
       ck, ck1, Kilgis, Zilgis, ntr, pg: integer;
       m, men, d, savd: word;
       zfail: string; {zodyno failo pav}
       Zzodyn, Rzodyn: zodyn;
       zodynas, klaidos: text; {zodyno failas}
       zodynai: array [1 .. 100] of string [12];
       pavadinimas: TSearchRec;

       { P R O C E D U R O S   I R   F U N K C I J O S }

  procedure PUNKTAS (num: integer); forward;
  procedure ZvARDAS (vardas: string); forward;

  {paslepia kursoriu}
  procedure HIDE_CURSOR; assembler;
   asm
     mov ah, 1
     mov ch, 20h
     int 10h
   end;

  {atstato kursoriu}
  procedure SHOW_CURSOR; assembler;
   asm
     mov ah, 1
     mov ch, 1eh
     mov cl, 1fh
     int 10h
   end;

  {zodynu pavadinimams ar naujiems zodziams ivesti}
  procedure NUSKAITt (Lilgis: integer; var Ats: string;
                      var Esc: boolean; x, y: integer);
     var ck, k: integer;
         simb: char;
         laik: string;
  begin
     show_cursor;
     ats := laik; laik := ''; esc := false; gotoxy (x, y);
     for ck := 0 to Lilgis + 1 do
      begin
         simb := readkey;
         if simb = #27 then begin ats := ''; esc := true; hide_cursor; exit end;
         if simb = #13 then
             begin
                if laik [ck] = ' ' then delete (laik, ck, 1);
                if laik [1] = ' ' then delete (laik, 1, 1);
                ats := laik; hide_cursor; exit
             end;
         if (simb = #8) and (ck <> 0) then
           begin
              delete (laik, ck, 1);
              if ck > Lilgis then ck := Lilgis;
              gotoxy (x + ck - 1, y); writeln (' '); gotoxy (x + ck - 1, y);
              ck := ck - 2
           end
           else if (simb = #8) and (ck = 0) then dec (ck)
             else  if ord (simb) = 0 then
                  begin
                    simb := readkey;
                    dec (ck)
                  end
              else if (simb = ' ') and (laik [ck] = ' ') or (ord (simb) in [1..31]) then dec (ck)
                else if (ck + 1) <= Lilgis then
                 begin
                    write (simb);
                    if simb in ['A'..'Z'] then simb := chr (ord (simb) + 32);
                    laik := laik + simb
                 end
                 else dec (ck)
      end;
     hide_cursor;
  end;

  {naujo zodyno kurimas}
  procedure NAUJASz (var zfail: string; var zodynas: text);
    var ck : integer;
  begin
     for ck := 1 to length (zfail) do
       if (zfail [ck] = '\') or (zfail [ck] = '/')
       or (zfail [ck] = ':') or (zfail [ck] = '*')
       or (zfail [ck] = '?') or (zfail [ck] = '"')
       or (zfail [ck] = '<') or (zfail [ck] = '>')
       or (zfail [ck] = '|') or (zfail [ck] = ' ')
       then begin delete (zfail, ck, 1); dec (ck) end;
     {$I-} reset (zodynas); {$I+}
     if IOResult = 0 then close (zodynas);
     assign (zodynas, zfail);
     rewrite (zodynas)
  end;

  {nutrina visa meniu lauka}
  procedure VALMN;
     var y: integer;
  begin
     window (5, 5, 39, 23);
     textbackground (fonas); clrscr;
     window (1, 1, 80, 25)
  end;

  {didina num (1..kiekis) reiksme}
  procedure PAD (var sk: integer; kiekis: integer);
  begin
     if sk < kiekis then inc (sk) else sk := 1
  end;

  {mazina n (1..5) reiksme}
  procedure MAZ (var sk: integer; kiekis: integer);
  begin
     if sk > 1 then dec (sk) else sk := kiekis
  end;


  {nuskaito zodyna i masyvus Zzodyn ir Rzodyn}
  procedure NUSKAITz (zfail: string; var Zzodyn, Rzodyn: zodyn;
                                     var z: integer);
  begin
     z := 0;
     while not eof (zodynas) do
       begin
        inc (z); readln (zodynas, Zzodyn [z]); readln (zodynas, Rzodyn [z]);
       end
  end;

   {piesia meniu mygtuka}
   procedure MENIU (nr: integer; ziba: boolean);
      var ck, x, y: integer;
   begin
      x := 5;
      case nr of
         1: y := 5;
         2: y := 9;
         3: y := 13;
         4: y := 17;
         5: y := 21;
      end;
      if ziba then textbackground (mnZ) else textbackground (mnN);
      textcolor (mnT);
      for ck := 0 to 2 do
        begin gotoxy (x, y + ck); writeln (ilgis); end;
      gotoxy (x + 1, y ); writeln (mnV [nr]);
      gotoxy (x + 2, y + 1); writeln (mnA [nr]);
      textbackground (fonas);
      if ziba then textcolor (gradiantas) else textcolor (fonas);
      gotoxy (x + 1, y + 3); writeln ('°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°');
      for ck := 1 to 2 do
           begin gotoxy (x + 31, y + ck); writeln('°') end
   end;

   {piesia duomenis}
   procedure DUOMENYS;
      var ck, x, y: integer;
   begin
      textcolor (mnT); textbackground (mnN);
      x := 40; y := 5;
      for ck := 0 to 18 do
          begin gotoxy (x, y + ck); writeln (duom) end;
      zVardas (zfail)
   end;

   {meniu rodykliu vaiksciojimas}
   function ROD (mnSk: integer): integer;
     var myg: char;
         num: integer;
   begin
      num := 1;
      while myg <> #13 do
        begin
           myg := readkey;
           if myg = #0 then
             begin
               myg := readkey;
               case myg of
                 #80, #75: begin
                             meniu (num, false);
                             pad (num, mnSk);
                             meniu (num, true)
                           end;
                 #72, #77: begin
                             meniu (num, false);
                             maz (num, mnSk);
                             meniu (num, true)
                           end
               end
             end
        end;
      rod := num
   end;

   {nupiesia visa meniu}
   procedure MENIUv;
   begin
      valmn;
      meniu (1, true); {piesiamas visus meniu}
      for ck := 2 to 5 do meniu (ck, false);
      duomenys;

      punktas (rod (5)) {leidzia rodylemis pasirinkti meniu}
   end;

   {virsuj paraso zodyno failo varda}
   procedure zVARDAS (vardas: string);
   begin
      textbackground (fonas); textcolor (gradiantas);
      gotoxy (45,2); writeln (m,'-', men,'-', d,', ', diena [savd]);
      gotoxy (45,3); writeln ('Ïodynas: ', vardas :12)
   end;

   {nukaityti faila}
   procedure ATz (zfail: string; var zodynas: text; var fl: boolean);
   begin
      assign (zodynas, zfail);
      {$I-}
      reset (zodynas);
      {$I+}
      if IOResult <> 0 then fl := false else fl := true
   end;

   {kas atsitinka paspaudus mn punktus}
   procedure PUNKTAS (num: integer);

       procedure SUBMNx (num, sub: integer; var zodynas: text; var ntr: integer); forward;

       {vieno submeniu piesimas}
       procedure SUBMENIU (mn, sub: integer; ziba: boolean);
          var x, y: integer;
              pav: string [15];
       begin
         if ziba then textbackground (mnZ) else textbackground (mnN);
         textcolor (mnT); x := 5; if sub = 1 then y := 10 else y := 15;
         for ck := 0 to 2 do begin gotoxy (x, y + ck); writeln (ilgis) end;
         case mn of
           1: if sub = 1 then pav := 'TESTAS' else pav := 'PERÏIÇR¸TI';
           2: if sub = 1 then pav := 'KLAIDOS' else pav := '½VERTINIMAS';
           3: if sub = 1 then pav := 'NAUJAS' else pav := 'PASIRINKTI';
         end;
         gotoxy (x + 1, y);  writeln (pav);
         textbackground (fonas);
         if ziba then textcolor (gradiantas) else textcolor (fonas);
         gotoxy (x + 1, y + 3); writeln ('°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°');
         for ck := 1 to 2 do
             begin gotoxy (x + 31, y + ck); writeln('°') end

       end;

       {piesia visus submeniu}
       procedure SUBMNv (mn: integer);
          var myg: char;
              num: integer;
       begin
          submeniu (mn, 1, true);
          submeniu (mn, 2, false);
          num := 1; myg := #77;
          while myg <> #13 do
           begin
              myg := readkey;
              if myg = #27 then meniuV
              else
                 if myg = #0 then
                   begin
                     myg := readkey;
                     case myg of
                       #80, #75: begin
                                   submeniu (mn, num, false);
                                   pad (num, 2);
                                   submeniu (mn, num, true)
                                 end;
                       #72, #77: begin
                                   submeniu (mn, num, false);
                                   maz (num, 2);
                                   submeniu (mn, num, true)
                                 end
                     end
                   end
           end;
          submnX (mn, num, zodynas, ntr)
       end;

       {x sbmeniu punkto pasirinkimas}
       procedure SUBMNx (num, sub: integer; var zodynas: text; var ntr: integer);
          var ck, x, k, y: integer;
              simb: char;
              klaid, stZ, nutr: boolean;
              buvesZ, tmp: string;
              proc: real;
          label 31, 32;
       begin
          if num = 1 then
              case sub of
                 {Pradeti testa}
                 1:begin
                     valmn; ntr := zilgis;
                     textbackground (mnZ); textcolor (mnT);
                     {$I-} reset (zodynas); {$I+}
                     if IOResult <> 0 then
                       begin
                          textbackground (mnZ); textcolor (mnT);
                          window (10, 12, 29, 14); clrscr;
                          gotoxy (2, 1); writeln ('[!]');
                          gotoxy (2, 2); writeln ('PASIRINKITE ÏODYNµ');
                          simb := readkey;
                          exit;
                       end;
                     window (10, 12, 29, 14); clrscr;
                     gotoxy (2, 1); writeln ('APSUKTI REIK¾MES?');
                     gotoxy (7, 2); writeln ('T/N');
                     window (1, 1, 80, 25);
                     simb := #77;
                     repeat
                       simb := readkey;
                       if simb = #27 then exit;
                     until (simb = #116) or (simb = #110) or (simb = #84) or (simb = #78);
                     stZ := false;
                     if (simb = #116) or (simb = #84) then stZ := true;
                     valmn;
                     ck := 0; y := -1; klaid := false; x := 0;
                     rewrite (klaidos); close (klaidos);
                     repeat
                        inc (ck);
                        textbackground (mnZ); textcolor (mnT);
                        window (5, 12, 35, 14); clrscr;
                        gotoxy (2, 1); if stZ then writeln (Zzodyn [ck])
                                              else writeln (Rzodyn [ck]);
                        textbackground (mnN);
                        gotoxy (2, 2);
                        writeln ('                             ');
                        nuskaitT (28, buvesZ, nutr, 2, 2);
                        if nutr then
                            begin
                              if klaid then
                                    begin
                                       close (klaidos); reset (klaidos);
                                       while not eof (klaidos) do
                                         begin
                                          inc (y); ntr := ck div 2;
                                          readln (klaidos);
                                          Kilgis := y div 2;
                                         end;
                                       close (klaidos)
                                    end;
                              exit
                            end;
                        if (not stZ and (Zzodyn [ck] <> buvesZ)) or (stZ and (Rzodyn [ck] <> buvesZ)) then
                         begin
                           if not klaid then begin klaid := true; rewrite (klaidos) end;
                           if (not stz and (Zzodyn [ck] <> buvesZ)) then
                              begin
                                writeln (klaidos, Zzodyn [ck]);
                                writeln (klaidos, buvesZ, '*')
                              end;
                           if (stZ and (Rzodyn [ck] <> buvesZ)) then
                             begin
                                writeln (klaidos, Rzodyn [ck]);
                                writeln (klaidos, buvesZ, '*')
                             end
                         end;
                        if y >= 19 then y := 19 else y := y + 2;
                        window (43, 5, 71, 23);
                        gotoxy (1, y);
                        if stZ
                          then begin
                             if buvesZ = Rzodyn [ck]
                              then write ('+')
                              else write ('-');
                             write (Zzodyn [ck]);
                             for x := 1 to 28 - length (Zzodyn [ck]) do write (' ');
                             write ('>', buvesZ);
                             for x := 1 to 28 - length (buvesZ) do write (' ')
                          end
                          else begin
                            if buvesZ = Zzodyn [ck]
                              then write ('+')
                              else
                                begin
                                  textcolor (red);
                                  write ('-');
                                end;
                            write (Rzodyn [ck]);
                            for x := 1 to 28 - length (Rzodyn [ck]) do write (' ');
                            write ('>', buvesZ);
                            for x := 1 to 28 - length (buvesZ) do write (' ');
                            textcolor (mnT)
                          end;
                    until ck >= Zilgis;
                    valmn;
                    textbackground (mnZ); textcolor (mnT);
                    window (10, 12, 29, 14); clrscr;
                    gotoxy (2, 1); writeln ('[*]');
                    gotoxy (2, 2); writeln ('TESTAS BAIGTAS');
                    simb := readkey;
                    y := 0;
                    {$I-} reset (klaidos); {$I+}
                    if ioresult = 0 then
                      begin
                         while not eof (klaidos) do
                           begin
                            inc (y);
                            readln (klaidos);
                           end;
                         close (klaidos); Kilgis := y div 2
                      end
                      else proc := 100;
                    proc := (Zilgis - kilgis) * 100 / Zilgis; clrscr;
                    gotoxy (2, 1); writeln ('[*]');
                    gotoxy (2, 2); writeln ('ATSAK¸TE ', proc :2 :0, ' proc.');
                    simb := readkey
                 end;

                 {Perziuri zodyno turini}
                 2: begin
                     {$I-} reset (zodynas); {$I+}
                     if IOResult <> 0 then
                       begin
                          valmn;
                          textbackground (mnZ); textcolor (mnT);
                          window (10, 12, 29, 14); clrscr;
                          gotoxy (2, 1); writeln ('[!]');
                          gotoxy (2, 2); writeln ('UÏKRAUKITE ÏODYNµ');
                          simb := readkey;
                          exit;
                       end;
                      window (43, 5, 71, 23);
                      textbackground (mnN); textcolor (0); clrscr;
                      atZ (zfail, zodynas, nutr);
                      nuskaitZ (zfail, Zzodyn, Rzodyn, zilgis);
                      x := 1;
                      repeat
                          gotoxy (1, 1);
                          Writeln ('   Zodyno ilgis - ', zilgis);
                          if x = 1 then writeln ('[þ]') else writeln ('<<<');
                          if Zilgis > 8 then k := x + 7 else k:= Zilgis;
                          for ck := x to k do
                            begin
                              write (Zzodyn [ck]);
                              for y := 1 to 29 - length (Zzodyn [ck]) do write (' ');
                              write ('>', Rzodyn [ck]);
                              for y := 1 to 28 - length (Rzodyn [ck]) do write (' ');
                            end;
                          gotoxy (1, 19);
                          if ck >= Zilgis then write ('[þ]') else write ('>>>');
                          repeat
                            simb := readkey;
                            if simb = #27 then
                              begin clrscr; window (1, 1, 80, 25); exit end;
                            case simb of
                              #73: if x < 9 then x := 1 else x := x - 8;
                              #81: if Zilgis - k >= 7 then x := x + 8 else x := x + (Zilgis - k);
                              #72: if x > 1 then dec (x);
                              #80: if k <> zilgis then inc (x);
                            end
                          until simb in [#27, #72, #73, #80, #81];
                      until false
                 end
          end;

          if num = 2 then
                case sub of
                  {perziuri padarytas klaidas}
                  1: begin
                     {$I-} reset (klaidos); {$I+}
                     if IOResult <> 0 then
                       begin
                          valmn;
                          textbackground (mnZ); textcolor (mnT);
                          window (10, 12, 29, 14); clrscr;
                          gotoxy (2, 1); writeln ('[!]');
                          gotoxy (2, 2); writeln ('ATLIKITE TESTµ');
                          simb := readkey;
                          exit;
                       end;
                    y := 0;
                    while not eof (klaidos) do
                     begin
                        inc (y);
                        readln (klaidos);
                        Kilgis := y div 2
                     end;
                    close (klaidos);
                    buvesZ := zfail;
                    window (43, 5, 71, 23);
                    textbackground (mnN); textcolor (0); clrscr;
                    atZ ('klaidos.dat', zodynas, nutr);
                    nuskaitZ ('klaidos.dat', Zzodyn, Rzodyn, zilgis);
                    x := 0;
                    repeat
                        gotoxy (1, 1); inc (x);
                        Writeln ('  Padaryta klaidÖ: ', Kilgis);
                        if x = 1 then writeln ('[þ]') else writeln ('<<<');
                        If Kilgis > 8 then k := x + 7 else k := Kilgis;
                        for ck := x to k do
                          begin
                            write (Zzodyn [ck]);
                            for y := 1 to 29 - length (Zzodyn [ck]) do write (' ');
                            write ('>', Rzodyn [ck]);
                            for y := 1 to 28 - length (Rzodyn [ck]) do write (' ');
                          end;
                        gotoxy (1, 19);
                        if ck >= Kilgis then write ('[þ]') else write ('>>>');
                        repeat
                          simb := readkey;
                          if simb = #27 then
                            begin
                              clrscr; window (1, 1, 80, 25);
                              atZ (buvesZ, zodynas, nutr);
                              nuskaitZ (buvesZ, Zzodyn, Rzodyn, Zilgis);
                              exit
                            end;
                          if simb = #0 then simb := readkey;
                          case simb of
                              #73: if x < 9 then x := 0 else x := x - 8;
                              #81: if Kilgis - k >= 7 then x := x + 8 else begin x := x + (Kilgis - k); dec (x) end;
                              #72: if x > 1 then x := x - 2 else dec (x);
                              #80: if k >= Kilgis then dec (x);
                          end
                        until simb in [#27, #72, #73, #80, #81];
                    until false
                  end;
                  {suteikiamas ivertinimas}
                  2: begin
                    x := 0; y := 0;
                    valmn;
                    textbackground (mnZ); textcolor (mnT);
                    window (10, 12, 29, 14); clrscr;
                    {$I-} reset (klaidos); {$I+}
                    if ioresult = 0 then
                      begin
                         while not eof (klaidos) do
                           begin
                            inc (y);
                            readln (klaidos);
                           end;
                         close (klaidos); Kilgis := y div 2
                      end
                      else proc := 100;
                    if ntr = 0 then ntr := 1;
                    proc := (ntr - kilgis) * 100 / ntr; clrscr;
                    x := 1;
                    if (proc >= 15) and (proc < 25) then x := 2;
                    if (proc >= 25) and (proc < 35) then x := 3;
                    if (proc >= 35) and (proc < 45) then x := 4;
                    if (proc >= 45) and (proc < 55) then x := 5;
                    if (proc >= 55) and (proc < 65) then x := 6;
                    if (proc >= 56) and (proc < 75) then x := 7;
                    if (proc >= 75) and (proc < 85) then x := 8;
                    if (proc >= 85) and (proc < 95) then x := 9;
                    if (proc >= 95) and (proc <= 100) then x := 10;
                    {$I-} reset (klaidos); {$I+}
                    if IOresult = 0 then
                      begin
                         gotoxy (2, 1); writeln ('[*]');
                         gotoxy (2, 2); writeln ('JÇSÆ PAÏYMYS ', x);
                      end
                    else
                      begin
                         gotoxy (2, 1); writeln ('[!]');
                         gotoxy (2, 2); writeln ('NERASTA KLAIDÆ');
                      end;
                    simb := readkey
                  end
                end;

          if num = 3 then
                case sub of
                   {Sukuria nauja zodyna}
                   1: begin
                   31:{$I-} reset (zodynas); {$I+}
                      if IOresult = 0 then close (zodynas);
                      valmn;
                      textbackground (mnZ); textcolor (mnT);
                      x := 10; y := 12;
                      for ck := 0 to 2 do
                         begin gotoxy (x, y + ck);
                               writeln ('                    '); end;
                      gotoxy (x + 1, y); writeln ('NAUJAS ÏODYNAS:');
                      textbackground (mnN);
                      gotoxy (x + 1, y + 1); writeln ('                  ');
                      gotoxy (x + 1, y + 1);
                      buvesZ := zfail;
                      repeat
                        nuskaitT (8, zfail, nutr, x + 1, y + 1);
                      until zfail <> '';
                      zfail := zfail + '.zod';
                      if nutr then begin zfail := buvesZ; exit end
                         else
                           begin
                             valmn;
                             textbackground (mnZ); textcolor (mnT);
                             window (10, 12, 29, 14); clrscr;
                             gotoxy (2, 1); writeln ('AR KURSI ÏODYNµ:');
                             gotoxy (6, 2); writeln (zfail :8);
                             repeat
                               simb := readkey;
                             until (simb = #27) or (simb = #13);
                             if simb = #27 then
                                  begin
                                    zfail := buvesZ;
                                    window (1, 1, 80, 25);
                                    exit
                                  end;
                              atZ (zfail, zodynas, nutr);
                              if nutr then
                                begin
                                   valmn;
                                   textbackground (mnZ); textcolor (mnT);
                                   window (10, 12, 29, 14); clrscr;
                                   gotoxy (2, 1); writeln ('ÏODYNAS EGZISTUOJA:');
                                   gotoxy (6, 2); writeln (zfail :8);
                                   simb := readkey; if simb = #0 then simb := readkey;
                                   window (1, 1, 80, 25);
                                   zfail := buvesZ;
                                   goto 31
                                end;
                             naujasZ (zfail, zodynas);
                             valmn;
                             window (5, 11, 35, 16);
                             textbackground (mnZ); clrscr;
                             gotoxy (2, 1); writeln ('ÏODIS:');
                             gotoxy (2, 4); writeln ('VERTIMAS:');
                             ck := 0; y := 0;
                             repeat
                                inc (ck);
                                textbackground (mnN); window (5, 11, 35, 16);
                                gotoxy (2, 5);
                                writeln ('                             ');
                                repeat
                                  gotoxy (2, 2);
                                  writeln ('                             ');
                                  nuskaitT (28, buvesZ, nutr, 2, 2);
                                until (buvesZ <> '') or (nutr and (ck > 1));
                                if nutr then
                                    begin
                                      close (zodynas);
                                      atZ (zfail, zodynas, nutr);
                                      nuskaitZ (zfail, Zzodyn, Rzodyn, ck);
                                      exit
                                    end;
                                if buvesZ <> #27 then writeln (zodynas, buvesZ);
                                tmp := buvesZ;
                                repeat
                                  gotoxy (2, 5);
                                  writeln ('                             ');
                                  repeat
                                     nuskaitT (28, buvesZ, nutr, 2, 5);
                                  until (buvesZ <> '') or nutr;
                                until not nutr;
                                if buvesZ <> #27 then writeln (zodynas, buvesZ);
                                window (43, 5, 71, 23);
                                if ck <= 9 then gotoxy (1, ck * 2 - 1) else gotoxy (1, 19);
                                write (Tmp);
                                for x := 1 to 29 - length (tmp) do write (' ');
                                write ('>', buvesZ);
                                for x := 1 to 28 - length (buvesZ) do write (' ');
                             until ck = zd;
                             window (1, 1, 80, 25);
                             for ck := 1 to Zd do begin
                               if ck mod 2 = 1
                                 then begin gotoxy (x,y); writeln; end;
                             nuskaitT (80, buvesZ, nutr, x, y);
                             writeln (zodynas, buvesZ);
                             end;

                           end
                   end;
                   {Atidaro arba pakeicia zodyno faila}
                   2: begin
                     32:valmn;
                        textcolor (mnT); textbackground (mnZ);
                        x := 10; y := 8;
                        gotoxy (x, y);
                        for ck := 0 to 10 do
                           begin gotoxy ( x, y + ck);
                                 writeln ('                    '); end;
                        gotoxy (x + 1, y); writeln ('RASTI ÏODYNAI:');
                        textbackground (mnN);
                        for ck := 1 to 9 do
                        begin
                           gotoxy (x + 1, y + ck); writeln ('                  ');
                        end;
                        gotoxy (x + 1, y + 1);
                        ck := 1;
                        FindFirst ('*.zod', faArchive, pavadinimas);
                        zodynai [ck] := pavadinimas.Name;
                        nutr := true;
                        if dosError = 0 then ck := 1 else nutr := true;
                        while DosError = 0 do
                        begin
                           inc (ck);
                           zodynai [ck] := pavadinimas.Name;
                           FindNext(pavadinimas);
                        end;
                        for ck := 1 to 9 do
                        begin
                           gotoxy (x, y + ck);
                           if ck = 1 then
                              begin
                                textbackground (mnZ);
                                write ('>', zodynai [ck]);
                                write ('      ');
                                textbackground (mnN)
                              end;
                        end;
                        if ck > 9 then
                        begin
                           gotoxy (11, 18);
                           writeln ('>>>');
                        end;
                        if not nutr then
                          begin
                             valmn;
                             textbackground (mnZ); textcolor (mnT);
                             window (10, 12, 29, 14); clrscr;
                             gotoxy (2, 1); writeln ('ÏODYNÆ NERASTA:');
                             gotoxy (6, 2); writeln (zfail :8);
                             readkey; while keypressed do readkey;
                             window (1, 1, 80, 25);
                             zfail := buvesZ;
                             goto 32
                          end;

                        ck := 1; ck1 := 1;
                        repeat
                           simb := readkey;
                           num := ord (simb);
                           case num of
                               27: zfail := zodynai [ck];
                               72: begin
                                     textbackground (mnZ);
                                     gotoxy (x, y); write (' ');
                                     textbackground (mnN);
                                     write ('                    ');
                                     if ck < 8 then pg := 1 else pg := ck;
                                     if ck > 1 then begin dec (ck); dec (ck1); end;
{!}                                     for ntr := pg to pg + 8 do
                                     begin
                                       gotoxy (x + 1, y + ntr);
                                       write (
                                     end;
                                     textbackground (mnZ);
                                     write ('>', zodynai [ck]);
                                     write ('      ');
                                     textbackground (mnN)
                                   end;
                               80: begin
                                     if ck < 9 then inc (ck1);
                                     inc (ck);
                                     gotoxy (x, y + ck1);
                                     textbackground (mnZ);
                                     write ('>', zodynai [ck]);
                                     write ('      ');
                                   end;
                        until num = 13;
                        nuskaitZ (zfail, Zzodyn, Rzodyn, Zilgis)
                   end
                end
       end;

      {x meniu punkto pasirinkimas}
      procedure MNx (x: integer);
         var ck: integer;
             myg: char;
      begin
         valmn; submnV (x); meniuV
     end;

      {4 meniu punkto pasirinkimas}
      procedure MN4;
         var myg: char;
      begin
         valmn; window (5, 5, 35, 23);
         textcolor (gradiantas); textbackground (fonas);
         gotoxy (1, 1); writeln ('============================');
         gotoxy (1, 2); writeln ('MoKa - tai programa,  skirta');
         gotoxy (1, 3); writeln ('Ôtvirtinti   uØsienio  kalbÖ');
         gotoxy (1, 4); writeln ('ØodØiams    bei     turimoms');
         gotoxy (1, 5); writeln ('Øinioms   patikrinti.   Jums');
         gotoxy (1, 6); writeln ('tereikia   susikurti    savo');
         gotoxy (1, 7); writeln ('ØodynÐ, atlikti testÐ.  MoKa');
         gotoxy (1, 8); writeln ('suras J×sÖ padarytas klaidas');
         gotoxy (1, 9); writeln ('ir Ôvertins. Klaidas  vÓliau');
         gotoxy (1,10); writeln ('galÓsite perØi×rÓti. PlaÑiau');
         gotoxy (1,11); writeln ('programa apraÕyta "read.txt"');
         gotoxy (1,13); writeln ('    Programavo:             ');
         gotoxy (1,14); writeln ('        Mantas Kanaporis    ');
         gotoxy (1,15); writeln ('    Testavo:                ');
         gotoxy (1,16); writeln ('        Mantas Kanaporis    ');
         gotoxy (1,17); writeln ('        Gytis Mork×nas      ');
         gotoxy (1,19); write   ('============================');
         repeat
            myg := readkey;
            if myg = #27 then meniuV
         until myg = #27;

      end;

   begin
      case num of
         1: mnX (1);
         2: mnX (2);
         3: mnX (3);
         4: mn4;
         5: begin
              textcolor (15); textbackground (0); clrscr; show_cursor;
              {$I-} reset (zodynas); {$I+}
              if IOResult = 0 then close (zodynas);
              {$I-} reset (klaidos); {$I+}
              if Ioresult = 0 then erase (klaidos);
              halt(1)
         end
       end
   end;

            { P A G R I N D I N E   P R O G R A M A }

begin

   exec ('lir.com',''); { paleidziama LIRA }
   window (1, 1, 80, 25);
   assign (klaidos, 'klaidos.dat');
   hide_cursor; textcolor (gradiantas); textbackground (fonas); clrscr;

   writeln ('    ----------------------------');
   writeln ('    MoKa 1 Mantas Kanaporis 2001');
   writeln ('    ----------------------------');

   {meniu ir zodyno failo pavadinimai}
   mnV [1] := 'MOKYMASIS';  mnA [1] := 'Testas, ØodØiai';
   mnV [2] := 'REZULTATAI'; mnA [2] := 'Klaidos, Ôvertinimas';
   mnV [3] := 'ÏODYNAS';    mnA [3] := 'Kurti naujÐ ar pasirinkti';
   mnV [4] := 'APIE';       mnA [4] := 'Apie programÐ ir autoriÖ';
   mnV [5] := 'I¾¸JIMAS';   mnA [5] := 'IÕeiti';
   zfail := '----'; GetDate (m, men, d, savd);

   Kilgis := 0;
   meniuV;

   textcolor (15); textbackground (0);
   show_cursor; window (1, 1, 80, 25); clrscr;
   close (zodynas)
end.
