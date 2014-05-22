program gyventojai;
uses crt;
var metai,future,metai2:longint;
    sutikimas:char;
label 1,2,3;
begin
1: clrscr;
   writeln('             ษอออออออออออออออออป');
   writeln('             บ PeopleCount 1.0 บ  (c) Gytis Morkืnas 2000') ;
   writeln('             ศอออออออออออออออออผ');
   writeln;
   writeln('Si programa skirta prognozuoti Lietuvos gyventoju skaiciui');
   writeln('ateityje,jei ju pokytis bus toks kaip siandien');
   writeln;
   write('Tai kuriu metu Lietuvos populiacija norite suzinoti?  ');
   readln(metai);
   if metai<=2000 then
               begin
                   writeln('Jei norite suzinoti praeiti, tam yra statistika!');
                   goto 1;
               end
   ELSE
    BEGIN
       metai2:=metai-2000;
       future:=3705000-4400*metai2;
       if future<=0 then
                begin
                   writeln('Kaip matote tada lietuviu jau nebebus siame pasaulyje...');
                   readkey;
                   goto 3;
                end
       ELSE
        BEGIN
       writeln;
       writeln('****************************************************');
       writeln( metai,' - aisiais metais Lietuvoje bus ', future ,' gyventoju');
       writeln('****************************************************');
       writeln;
           readkey;
3:         clrscr;
           writeln('             ษอออออออออออออออออป');
           writeln('             บ PeopleCount 1.0 บ  (c) Gytis Morkืnas 2000') ;
           writeln('             ศอออออออออออออออออผ');
           writeln;
           writeln('Skaiciuosite is naujo? T/N');
           sutikimas:=readkey;
           if sutikimas='t' then goto 1
           ELSE
             BEGIN
               if sutikimas='n' then
               else goto 3;
             END;
        END;
    END;
end.