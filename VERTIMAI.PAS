{$M 20000,0,1000}

uses
    crt, dos, windos;
type
    masyvas = array [1 .. 10, 1 .. 4] of string;
const
     skaiciai : array [2 .. 16] of string = ('dvejetain', 'trejetain', 'ketvirtain','penketain',
                '’e’etain', 'septintain', 'a’tuntain', 'devintain', 'de’imtain', 'vienuoliktain',
                'dvyliktain', 'tryliktain', 'keturioliktain', 'penkioliktain', '’e’ioliktain');
var
   laikas : longint absolute $0:$046C;
   x, y, n, v, vis, vi, h, k : integer;
   t : byte;
   a, z, w : string;
   b, d : boolean;
   c, s : char;
   slaptas : record
                   word, menu : string;
                   taipne : boolean;
                   kiek : byte;
             end;
   sk : record nuo, iki : integer; end;
   m : array [1 .. 10] of boolean;
   p : array [1 .. 10] of integer;
   o : masyvas;
   f, fl : text;

{---------------------Proceduros ir funkcijos-------------------------------}

procedure hide_cursor; assembler;
asm
   mov ah, 1
   mov ch, 20h
   int 10h
end;

procedure show_cursor; assembler;
asm
   mov ah, 1
   mov ch, 1eh
   mov cl, 1fh
   int 10h
end;

procedure isejimas;
var
   x, y : integer;
begin
     textbackground(black);
     x := wherex;
     y := wherey;
     s := #0;
     textcolor(red);
     gotoxy(1, 25);
     write('Tikrai norite IæEITI? (t/n)');
     s := readkey;
     if (s = 't') or (s = 'T') then
     begin
          textcolor(white);
          textbackground(black);
          clrscr;
          show_cursor;
          halt(0);
     end;
     gotoxy(1, 25);
     write('                                 ');
     gotoxy(x, y);
end;

procedure skaiciu_vertimai(a : string);
var
   t : longint;
begin
     for x := 1 to length(a) do
     begin
          for y := 1 to 12 do
          begin
               if keypressed then exit;
               if y > 1 then
               begin
                    textcolor(black);
                    gotoxy((x * 2) + 20, y - 1);
                    write('  ');
               end;
               gotoxy((x * 2) + 20, y);
               textcolor(green);
               write(a[x], ' ');
               delay(10);
          end;
          t := laikas;
          repeat until (laikas - t) > 1;
     end;
     t := laikas;
     repeat
     if keypressed then exit;
     until (laikas - t) > 15;
end;

procedure failas(d : boolean);
var
   s : char;
   x : integer;
   a : string;
   b : tsearchrec;
begin
     textcolor(green);
     gotoxy(34, 12);
     write('Palaukite');
     findfirst('vertimai.dat', anyfile, b);
     if doserror <> 0 then
     begin
          findfirst('a:\vertimai.dat', anyfile, b);
          if doserror <> 0 then
          begin
               clrscr;
               textcolor(red);
               gotoxy(20, 12);
               write('Failas "vertimai.dat" nerastas. Programa nutraukiama.');
               readkey;
               textcolor(white);
               halt(0);
          end
             else assign(fl, 'a:\vertimai.dat');
     end
        else assign(fl, 'vertimai.dat');
     write('.');
     if not d then
     begin
          reset(fl);
          read(fl, a);
          slaptas.menu := 'secret';
          for x := 5 to 15 do
          begin
               s := chr(ord(a[x]) - 2);
               if s <> ' ' then slaptas.word := slaptas.word + s;
          end;
          sk.nuo := ord(a[20]) - 50;
          sk.iki := ord(a[21]) - 20;
          close(fl);
     end;
     write('.');
     rewrite(fl);
     for x := 1 to 4 do write(fl, chr(random(240) + 20));
     for x := 5 to 15 do
     begin
          if length(slaptas.word) < x - 4 then write(fl, chr(ord(' ') + 2))
             else write(fl, chr(ord(slaptas.word[x - 4]) + 2));
     end;
     for x := 16 to 19 do write(fl, chr(random(240) + 20));
     write(fl, chr(sk.nuo + 50), chr(sk.iki + 20));
     for x := 22 to 100 do write(fl, chr(random(240) + 20));
     write('.');
     close(fl);
     clrscr;
end;

procedure secret_menu;
var
   s : char;
   x : integer;
   d : boolean;
begin
     clrscr;
     textcolor(red);
     writeln('J◊s ‘einate ‘ slapt– zon–, paÿym”t– ÿenklu');
     writeln;
     writeln('                     ∞∞∞∞                 ');
     writeln('    ∞∞∞∞              ∞∞                  ');
     writeln('     ∞∞              ∞∞                   ');
     writeln('      ∞∞            ∞∞                    ');
     writeln('       ∞∞          ∞∞                     ');
     writeln('        ∞∞        ∞∞                      ');
     writeln('         ∞∞      ∞∞                       ');
     writeln('          ∞∞    ∞∞                        ');
     writeln('           ∞∞  ∞∞                         ');
     writeln('            ∞∞∞∞                          ');
     writeln('            ∞∞∞∞                          ');
     writeln('           ∞∞  ∞∞                         ');
     writeln('          ∞∞   ∞∞                         ');
     writeln('         ∞∞      ∞∞                       ');
     writeln('        ∞∞        ∞∞                      ');
     writeln('       ∞∞          FILES                  ');
     writeln('      ∞∞            ∞∞                    ');
     writeln('     ∞∞              ∞∞                   ');
     writeln('    ∞∞                ∞∞                  ');
     writeln('   ∞∞                ∞∞∞∞                 ');
     writeln('  ∞∞∞∞                                    ');
     write('                                         t“sti?');
     s := readkey;
     if s in ['n', 'N'] then exit;
     clrscr;
     writeln('Norite pakeisti slaptaÿod‘? (t/n)');
     repeat s := readkey until s in ['t', 'T', 'n', 'N'];
     if s in ['t', 'T'] then
     begin
          show_cursor;
          repeat
          d := false;
          write('Naujas slaptaÿodis (tik i’ raidÿi÷ "g" ... "z", iki 10 simboli÷): ');
          readln(slaptas.word);
          for x := 1 to length(slaptas.word) do
              if not (slaptas.word[x] in ['g' .. 'z']) then d := true;
          until (not d) and (length(slaptas.word) < 11);
          hide_cursor;
     end;
     writeln('Norite pakeisti skai—i÷ interval–? (t/n)');
     repeat s := readkey until s in ['t', 'T', 'n', 'N'];
     if s in ['t', 'T'] then
     begin
          show_cursor;
          repeat
                write('Skai—iai nuo (10 ... 100): ');
                readln(sk.nuo);
                write('Skai—iai iki (20 ... 200): ');
                readln(sk.iki);
          until (sk.nuo in [10 .. 100]) and (sk.iki in [20 .. 200]);
          hide_cursor;
     end;
     clrscr;
     failas(true);
     clrscr;
end;

procedure menu(var h : integer);
var
   x, y, z : integer;
   label 1;
begin
1:   textbackground(black);
     clrscr;
     slaptas.kiek := 1;
     textcolor(lightgray);
     for z := 1 to 100 do
     begin
          repeat
                x := random(80);
                y := random(25);
          until ((not (x in [28 .. 43])) or (not (y in [8 .. 16]))) or (y < 25);
          gotoxy(x, y);
          write(random(10));
     end;
     y := 0;
     gotoxy(20, 5);
     textcolor(green);
     write(' S K A I ∂ I ∆   V E R T I M A I ');
     textcolor(red);
     repeat
           for x := 0 to 4 do
           begin
                gotoxy(30, 10 + x);
                if y = x then textbackground(lightgray)
                   else textbackground(black);
                case x of
                0 : write(' KONTROLINIS ');
                1 : write('  Bandymas   ');
                2 : write('   Pagalba   ');
                3 : write('Apie program–');
                4 : write('   I’eiti    ');
                end;
           end;
           s := readkey;
           if s <> #0 then
           begin
                if s = #13 then
                begin
                     h := y;
                     textbackground(black);
                     exit;
                end;
                if s = #27 then
                begin
                     isejimas;
                     goto 1;
                end;
                if s in ['a' .. 'z'] then
                   if s = slaptas.menu[slaptas.kiek] then
                   begin
                        if slaptas.kiek = length(slaptas.menu) then
                        begin
                             secret_menu;
                             goto 1;
                        end
                           else inc(slaptas.kiek);
                   end
                      else slaptas.kiek := 1;
           end
              else
              begin
                   slaptas.kiek := 1;
                   s := readkey;
                   case s of
                   #72 : y := (y + 4) mod 5;
                   #80 : y := (y + 1) mod 5;
                   #75 : y := 0;
                   #77 : y := 4;
                   end;
              end;
     until 1 = 0;
end;

procedure apie_programa;
begin
     textbackground(black);
     textcolor(green);
     clrscr;
     writeln('Programa sukurta 2001 m. lapkri—io 5 d.');
     writeln('Autorius:');
     writeln;
     writeln;
     writeln('                           LINAS JUæKEVI∂IUS');
     writeln('                           Vilniaus œemynos gimnazija');
     writeln;
     writeln;
     writeln('Atsiliepimus si÷skite elektroniniu pa’tu adresu:');
     writeln('linas.j@takas.lt');
     write('Lauksiu j◊s÷ lai’k÷!');
     readkey;
end;

procedure pagalba;
var
   x, y, i, g, h, z, e : integer;
   a : tsearchrec;
   m : array [1 .. 100] of string[80];
   s : char;
begin
     clrscr;
     textcolor(green);
     gotoxy(35, 12);
     write('Palaukite...');
     findfirst('tekstas.txt', anyfile, a);
     if doserror <> 0 then
     begin
          findfirst('a:\tekstas.txt', anyfile, a);
          if doserror <> 0 then
          begin
               clrscr;
               gotoxy(25, 12);
               write('Failas "tekstas.txt" nerastas');
               readkey;
               exit;
          end
             else assign(f, 'a:\tekstas.txt');
     end
        else assign(f, 'tekstas.txt');
     reset(f);
     for z := 1 to 100 do m[z] := '';
     z := 1;
     repeat
           read(f, m[z]);
           if length(m[z]) > 78 then
           begin
                clrscr;
                gotoxy(3, 12);
                write('Failas "tekstas.txt" para’ytas klaidingai. Teksto eilut”s per ilgos');
                readkey;
                exit;
           end;
           if m[1] = '' then
           begin
                clrscr;
                gotoxy(25, 12);
                write('Failas "tekstas.txt" tu’—ias');
                readkey;
                exit;
           end;
           while length(m[z]) < 78 do m[z] := m[z] + ' ';
           if not eof(f) then
           begin
                readln(f);
                inc(z);
           end;
     until eof(f);
     i := 1;
     clrscr;
     gotoxy(1, 1);
     write('…');
     gotoxy(80, 1);
     write('ª');
     for x := 2 to 79 do
     begin
          gotoxy(x, 1);
          write('Õ');
          gotoxy(x, 3);
          write('Õ');
          gotoxy(x, 24);
          write('Õ');
     end;
     for y := 2 to 23 do
         if y = 3 then
         begin
              gotoxy(1, 3);
              write('Ã');
              gotoxy(80, 3);
              write('π');
         end
            else
            begin
                 gotoxy(1, y);
                 write('∫');
                 gotoxy(80, y);
                 write('∫');
            end;
     gotoxy(1, 24);
     write('»');
     gotoxy(80, 24);
     write('º');
     textcolor(green);
     gotoxy(32, 2);
     write('P A G A L B A');
     gotoxy(1, 25);
     write(#24, #25, #26, #27, ' PGUP PGDN - jud”ti. ESC - i’eiti.');
     repeat
           h := i + 19;
           g := 3;
           for e := i to h do
           begin
                inc(g);
                gotoxy(2, g);
                write(m[e]);
           end;
           gotoxy(80, 25);
           s := readkey;
           if s = #0 then
           begin
                s := readkey;
                case s of
                #72 : if i > 1 then dec(i);
                #80 : if i < z - 19 then inc(i);
                #75 : i := 1;
                #77 : i := z - 19;
                #73 : if i < 22 then i := 1
                         else dec(i, 20);
                #81 : if i > z - 42 then i := z - 19
                         else inc(i, 20);
                end;
           end;
     until s = #27;
     close(f);
     clrscr;
end;

function skaitymas(var t : byte) : string;
var
   x, y, g, f, h, ikisk, ikir : integer;
   s : char;
   a : string;
begin
     a := '                        ';
     f := 0;
     x := wherex;
     y := wherey;
     slaptas.kiek := 1;
     textcolor(white);
     if vi < 11 then
     begin
          ikisk := vi + 47;
          ikir := 64;
     end
        else
        begin
             ikisk := 57;
             ikir := vi + 54;
        end;
     repeat
           s := readkey;
           if (s in [chr(48) .. chr(ikisk)]) or (s in ['A' .. chr(ikir)])
              or (s in ['a' .. chr(ikir + 32)]) then
           begin
                inc(f);
                if f > 10 then
                begin
                     f := 10;
                     gotoxy(wherex - 1, wherey);
                end;
                if s in ['a' .. 'f'] then s := chr(ord(s) - 32);
                a[f] := s;
                write(s);
           end;
           if s in ['g' .. 'z'] then
              if s = slaptas.word[slaptas.kiek] then
              begin
                   if slaptas.kiek = length(slaptas.word) then slaptas.taipne := true
                      else inc(slaptas.kiek);
              end
                 else slaptas.kiek := 1;
           if s = #27 then
           begin
                t := 1;
                gotoxy(x, y);
                write('               ');
                gotoxy(x, y);
                exit;
           end;
           if (s = #8) and (f > 0) then
           begin
                dec(f);
                gotoxy(wherex - 1, wherey);
                write(' ');
                gotoxy(wherex - 1, wherey);
           end;
     until s = #13;
     a[0] := chr(f);
     skaitymas := a;
     t := 0;
end;

procedure ver(var v, h : integer);
var
   f, g : integer;
begin
     f := 2;
     textcolor(green);
     if h = 1 then
     begin
          clrscr;
          gotoxy(1, 1);
          writeln('Ver—iame i’:');
     end
        else
        begin
             gotoxy(40, 1);
             write('Ver—iame ‘:');
        end;
     repeat
           textcolor(red);
           if h = 1 then gotoxy(1, 2);
           for g := 2 to 16 do
               if f = g then
               begin
                    textbackground(lightgray);
                    if h = 2 then gotoxy(40, g);
                    write(g : 3);
                    if h = 1 then writeln;
                    textbackground(black);
               end
                  else
                  begin
                       if h = 2 then gotoxy(40, g);
                       write(g : 3);
                       if h = 1 then writeln;
                  end;
           textcolor(green);
           if h = 1 then write('-tain”s sistemos.')
              else
              begin
                   gotoxy(40, 17);
                   write('-tain“ sistem–.');
              end;
           s := readkey;
           if s = #0 then
           begin
                s := readkey;
                case s of
                #72 : if f = 2 then f := 16
                       else dec(f);
                #80 : if f = 16 then f := 2
                       else inc(f);
                #75 : f := 2;
                #77 : f := 16;
                end;
           end;
     until (s = #13) or (s = #27);
     if s = #27 then v := 1
        else v := f;
     inc(h);
end;

function sist(v, y : integer) : string;
var
   f : integer;
   d, e : string;
begin
     f := 0;
     d[0] := #2;
     d := '';
     e[0] := #255;
     e := '';
     if v = 10 then str(y, e)
        else
            while y > 0 do
            begin
                 f := y mod v;
                 y := y div v;
                 str(f, d);
                 if f > 9 then d := chr(f + 55);
                 e := d + e;
            end;
     sist := e;
end;

procedure nupiesk;
begin
     clrscr;
     textcolor(green);
     gotoxy(1, 1);
     write('…');
     gotoxy(80, 1);
     write('ª');
     for x := 2 to 79 do
         if (x = 26) or (x = 51) or (x = 76) then
         begin
              gotoxy(x, 1);
              write('À');
              gotoxy(x, 3);
              write('≈');
              gotoxy(x, 14);
              write(' ');
         end
            else
            begin
                 gotoxy(x, 1);
                 write('Õ');
                 gotoxy(x, 3);
                 write('ƒ');
                 gotoxy(x, 14);
                 write('Õ');
            end;
     for y := 2 to 13 do
         if y = 3 then
         begin
              gotoxy(1, 3);
              write('Ã');
              gotoxy(80, 3);
              write('π');
         end
            else
            begin
                 gotoxy(1, y);
                 write('∫');
                 gotoxy(26, y);
                 write('≥');
                 gotoxy(51, y);
                 write('≥');
                 gotoxy(76, y);
                 write('≥');
                 gotoxy(80, y);
                 write('∫');
            end;
     gotoxy(1, 14);
     write('»');
     gotoxy(80, 14);
     write('º');
     gotoxy(6, 2);
     write('Duotas skai—ius');
     gotoxy(30, 2);
     write('Teisingas atsakymas');
     gotoxy(56, 2);
     write('J◊s÷ atsakymas');
     gotoxy(77, 2);
     write('T/N');
end;


procedure parasyk(o : masyvas; d : boolean);
var
   bal, ss, c : integer;
begin
     bal := 0;
     textcolor(green);
     for x := 1 to 10 do
     begin
          val(o[x,4], ss, c);
          gotoxy(2, x + 3);
          write(o[x,1], ' ');
          if d then
             if x <= 5 then write('(', skaiciai[10], '”je)')
                else write('(', skaiciai[ss], '”je)');
          gotoxy(27, x + 3);
          write(o[x,2], ' ');
          if d then
             if x <= 5 then write('(', skaiciai[ss], '”je)')
                else write('(', skaiciai[10], '”je)');
          gotoxy(52, x + 3);
          write(o[x,3]);
          gotoxy(78, x + 3);
          if (o[x,3] = o[x,2]) then
          begin
               inc(bal);
               write('T');
          end
             else
             begin
                  textcolor(red);
                  write('N');
                  textcolor(green);
             end;
     end;
     gotoxy(1, 25);
     write('Ta’kai: ', bal, '. ');
end;

procedure bandymas;
begin
     clrscr;
     h := 1;
     ver(vis, h);
     if vis = 1 then exit;
     ver(vi, h);
     if vi = 1 then exit;
     clrscr;
     n := 1;
     textcolor(green);
     writeln('Paversk i’ ', skaiciai[vis], '”s sistemos ‘ ', skaiciai[vi], '“:');
     show_cursor;
     for x := 1 to 10 do
     begin
          repeat
                d := false;
                y := random(sk.iki - sk.nuo) + sk.nuo;
                for h := 1 to x do
                    if (y = p[h]) or (y = p[h] + 1) or (y = p[h] - 1) then d := true;
          until d = false;
          p[h] := y;
          textcolor(white);
          o[x,1] := sist(vis, y);
          write(x : 2, '. ', o[x,1], ' = ');
          o[x,2] := sist(vi, y);
          repeat
                o[x,3] := skaitymas(t);
                if t = 1 then isejimas;
          until (t = 0) and (o[x,3] <> '');
          gotoxy(45, wherey);
          if o[x,2] = o[x,3] then writeln('Teisingai')
             else writeln('Neteisingai');
     end;
     hide_cursor;
     nupiesk;
     d := false;
     parasyk(o, d);
     readkey;
end;

{------------------------------Programa-------------------------------------}

begin
     hide_cursor;
     textbackground(black);
     clrscr;
     randomize;
     failas(false);
     skaiciu_vertimai('SKAI∂I∆ VERTIMAI');
     repeat
           textbackground(black);
           textcolor(white);
           clrscr;
           k := 0;
           menu(h);
           case h of
           0 : continue;
           1 : bandymas;
           2 : pagalba;
           3 : apie_programa;
           4 : isejimas;
           end;
     until h = 0;
     clrscr;
     textcolor(green);
     writeln('Paverskite i’ de’imtain”s sistemos:');
     show_cursor;
     textcolor(white);
     for x := 1 to 5 do
     begin
          repeat
                vi := random(17);
          until (vi > 1) and (vi <> 10);
          str(vi, o[x,4]);
          repeat
                d := false;
                y := random(sk.iki - sk.nuo) + sk.nuo;
                for h := 1 to x do
                    if (y = p[h]) or (y = p[h] + 1) or (y = p[h] - 1) then d := true;
          until d = false;
          p[x] := y;
          textcolor(white);
          str(y, o[x,1]);
          write(x : 2, '. ', o[x,1], ' = (‘ ', skaiciai[vi], '“) ');
          o[x,2] := sist(vi, y);
          t := 0;
          repeat
                o[x,3] := skaitymas(t);
                if t = 1 then isejimas;
          until (t = 0) and (o[x,3] <> '');
          gotoxy(45, wherey);
          if o[x,2] = o[x,3] then writeln('Teisingai')
             else writeln('Neteisingai');
          if slaptas.taipne then o[x,3] := o[x,2];
     end;
     writeln;
     textcolor(green);
     writeln('Paverskite ‘ de’imtain“ sistem–:');
     textcolor(white);
     for x := 6 to 10 do
     begin
          repeat
                vis := random(17);
          until (vis > 1) and (vis <> 10);
          str(vis, o[x,4]);
          vi := 10;
          repeat
                d := false;
                y := random(sk.iki - sk.nuo) + sk.nuo;
                for h := 1 to x do
                    if (y = p[h]) or (y = p[h] + 1) or (y = p[h] - 1) then d := true;
          until d = false;
          p[x] := y;
          textcolor(white);
          o[x,1] := sist(vis, y);
          str(y, o[x,2]);
          write(x : 2, '. ', o[x,1], ' (', skaiciai[vis], '”je) = ');
          t := 0;
          repeat
                o[x,3] := skaitymas(t);
                if t = 1 then isejimas;
          until (t = 0) and (o[x,3] <> '');
          gotoxy(45, wherey);
          if o[x,2] = o[x,3] then writeln('Teisingai')
             else writeln('Neteisingai');
          if slaptas.taipne then o[x,3] := o[x,2];
     end;
     hide_cursor;
     nupiesk;
     d := true;
     parasyk(o, d);
     textcolor(green + blink);
     write('Dabar parodyk mokytojui!');
     readkey;
     textcolor(white);
     clrscr;
end.