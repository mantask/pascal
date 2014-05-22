program Pitagoras;
uses crt;
var a, b, e, f, duomenys, c1: integer;
    myg, sut: char;
    d,c: real;
label 1,2,3;
begin
1: clrscr;
   writeln('*****************************************************************');
   writeln('APSKAICIAVIMO PAGAL PITAGORA PROGRAMA 1.1 (c) Gytis Mork◊nas 2000');
   writeln('*****************************************************************');
   writeln;
   writeln('Kokius J◊s turite duomenis?');
   writeln;
   writeln('Jei du statinius, spauskite - 1');
   writeln('Jei statin‘ ir ‘ÿambin“ - 2');
3: myg:=readkey;
   if myg='1' then
      begin
        writeln;
        writeln;
        write('Koks vieno statinio ilgis? ');
        read(a);
        write('Koks kito statinio ilgis? ');
        read(b);
        c:=sqrt(sqr(a)+sqr(b));
        writeln;
        writeln('--------------------------------------');
        writeln('Iÿambin” lygi ',c);
      end
   else
      begin
          if myg='2' then
                        begin
                           writeln;
                           writeln;
                           write('Koks izambines ilgis? ');
                           read(e);
                           write('Koks statinio ilgis? ');
                           read(f);
                           d:=sqrt(sqr(e)-sqr(f));
                           writeln;
                           writeln('----------------------------------------');
                           writeln('Statinis = ',d);
                        end
             else
                begin
                  goto 3;
                end;
      end;
          writeln('====================================');
          writeln;
          writeln('Norite skai—iuoti i’ naujo? T/N');
2:        sut:=readkey;
          if sut='t'then goto 1
             else
                begin
                   if sut='n' then
                      else
                         begin
                            goto 2;
                         end;
                end;
end.