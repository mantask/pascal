{------------------------------}
{ Piano¨ Mantas Kanaporis 2000 }
{------------------------------}
program garsas;
   uses crt;
   const do1 = 523;
         dod = 555;
         re2 = 587;
         red = 623;
         mi3 = 659;
         fa4 = 698;
         fad = 741;
         sol5 = 784;
         sold = 832;
         la6 = 880;
         lad = 934;
         si7 = 988;
         trukme = 100;
   var key: char;
       uzteks, dega: boolean;
       ck, x, y, deges: integer;
       nata: string;


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



   {procedura baltui kavisui}
   procedure klavisasB (x, y: integer; dega: boolean);
         var ck, col: integer;
      begin
         if dega then col := 14 else col := 15;
         TextBackground(col); TextColor(0);
         for ck := 1 to 10 do begin
            gotoxy(x,y);
            if ck = 10 then writeln('ÀÄÄÄÄÙ') else writeln('³    ³');
            inc(y);
         end;
         gotoxy(80,25);
      end;

   {procedura juodami kavisui}
   procedure klavisasJ (x, y: integer; dega: boolean);
         var ck, col: integer;
      begin
         if dega then col := 14 else col := 0;
         TextBackground(col); TextColor(15);
         for ck := 1 to 7 do begin
            gotoxy(x,y); writeln('    ');
            inc(y);
         end;
         gotoxy(80,25);
      end;

   {groja nurodyta nata}
   procedure groja (nata: integer);
         var garsas, ck: integer;
      begin
         case nata of
            1: garsas := do1;
            2: garsas := re2;
            3: garsas := mi3;
            4: garsas := fa4;
            5: garsas := sol5;
            6: garsas := la6;
            7: garsas := si7;
            8: garsas := dod;
            9: garsas := red;
           11: garsas := fad;
           12: garsas := sold;
           13: garsas := lad;
         end;
         sound(garsas);
         for ck := 1 to 100 do begin
            delay(trukme);
            if keypressed then begin nosound; exit; end;
         end;
         nosound;
      end;

      {is paspausto mygtuko padaro skaiciu}
      function nat_nr (mygtukas: char): integer;
         begin
            case mygtukas of
               '1': nat_nr := 1;
               '2': nat_nr := 2;
               '3': nat_nr := 3;
               '4': nat_nr := 4;
               '5': nat_nr := 5;
               '6': nat_nr := 6;
               '7': nat_nr := 7;
               'Q','q': nat_nr := 8;
               'W','w': nat_nr := 9;
               'R','r': nat_nr := 11;
               'T','t': nat_nr := 12;
               'Y','y': nat_nr := 13;
            end;
         end;

begin
   clrscr;
   hide_cursor;
   TextColor(blink); TextBackground(lightcyan);
   gotoxy(30,11); writeln('                    ');
   gotoxy(30,12); writeln('   Sveiki atvyke!   ');
   gotoxy(30,13); writeln('                    ');
   gotoxy(80,25);
   readkey;
   TextBackground(black); TextColor(white);
   clrscr;
   dega := false;
   x := 13; y := 7;

   {surasau natu numerius}
   for ck := 1 to 7 do begin
      gotoxy(x,y); writeln(ck);
      x := x + 6;
   end;

   {surasau natu pavadinimus}
   x := 12; y := 8;
   for ck := 1 to 7 do begin
       case ck of
           1: nata := 'DO';
           2: nata := 'RE';
           3: nata := 'MI';
           4: nata := 'FA';
           5: nata := 'SOL';
           6: nata := 'LA';
           7: nata := 'SI';
       end;
       gotoxy(x,y); writeln(nata);
       x := x + 6;
   end;

   {grojimas}
   uzteks := false;
   repeat
     gotoxy(80,25);
     key := readkey;
     while key in ['1'..'7','Q','W','R','T','Y','q','w','r','t','y'] do begin

          x := 10; y := 10;
          for ck := 1 to 7 do begin
             if nat_nr(key) = ck then dega := true;
             klavisasB(x,y,dega);
             if nat_nr(key) = ck then
                 begin dega := false; deges := nat_nr(key); end;
             x := x + 6;
          end;

          x := 14; y := 10;
          for ck := 1 to 6 do begin
             if nat_nr(key) = ck + 7 then dega := true;
             if ck <> 3 then klavisasJ(x,y,dega);
             if nat_nr(key) = ck + 7 then
                 begin dega := false; deges := nat_nr(key); end;
             x := x + 6;
          end;

          groja(deges);

          x := 10; y := 10;
          for ck := 1 to 7 do begin
             klavisasB(x,y,dega);
             x := x + 6;
          end;

          x := 14; y := 10;
          for ck := 1 to 6 do begin
             if ck <> 3 then klavisasJ(x,y,dega);
             x := x + 6;
          end;

          key := ' ';
      end;
   until ord(key) = 27;
   show_cursor;
end.

