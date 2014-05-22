program Geometrija;
uses crt;
var a, b, e, f, trh, trkr, stkr, stkr2, sst, trpagr1, trpagr2, lygpagr, lygh, slyg: integer;
    spind, spind2, Spind3, lps: integer;
    myg, sutikimas, pas, patvirtinimas: char;
    d, c, S, Str, C2, I, Sskrit1: real;
label 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, pr;
begin
1:  clrscr;
    writeln('********************************************************************');
    writeln('GEOMETRINIU FIG«R∆ SKAICIAVIMO PROGRAMA 1.1  (c) Gytis Morkunas 2000');
    writeln('********************************************************************');
    writeln;
    writeln('Ka noresite skaiciuoti? (Paspauskite atitinkama skaiciu.)');
    writeln;
    writeln('1 - Statusis trikampis pagal Pitagor–.');
    writeln('2 - Trikampio plotas.');
    writeln('3 - Sta—iakampio plotas.');
    writeln('4 - Trapecijos plotas.');
    writeln('5 - Lygiagretainio plotas.');
    writeln('6 - Apskritimo ilgis.');
    writeln('7 - Lanko ilgis.');
    writeln('8 - Skritulio plotas.');
pr: pas:=readkey;
    if pas='2'then
       begin
       clrscr;
       writeln('********************************************************************');
       writeln('GEOMETRINIU FIG«R∆ SKAICIAVIMO PROGRAMA 1.1  (c) Gytis Morkunas 2000');
       writeln('********************************************************************');
       writeln;
4:     writeln('Koks trikampio aukstines ilgis?');
       read(trh);
       if trh<0 then
                  begin
                     writeln('Zioply, neigiamas buti negali!');
                     goto 4;
                  end;
5:     writeln('Koks krastines i kuria nuleista aukstine ilgis?');
       read(trkr);
              if trkr<0 then
                    begin
                       writeln('Zioply, neigiamas buti negali!');
                       goto 5;
                    end;
        S:=(trh*trkr)/2;
        writeln('**************************************');
        writeln('Trikampio plotas = ',S);
        writeln('**************************************');
        readkey;
      end
    else
      begin
        if pas='3' then
                      begin
                         clrscr;
                         writeln('********************************************************************');
                         writeln('GEOMETRINIU FIGURU SKAICIAVIMO PROGRAMA 1.0  (c) Gytis Morkunas 2000');
                         writeln('********************************************************************');
6:                       writeln('Koks staciakampio krastines ilgis?');
                         read(stkr);
                         if stkr<0 then
                                      begin
                                         writeln('Zioply, neigiamas buti negali!');
                                         goto 6;
                                      end
                         else
                            begin
7:                             writeln('Koks gretimos krastines ilgis?');
                               read(stkr2);
                               if stkr2<0 then
                                         begin
                                            writeln('Zioply, neigiamas buti negali!');
                                            goto 7;
                                         end
                               else
                                  begin
                                     Sst:=stkr*stkr2;
                                     writeln('***********************************');
                                     writeln('Staciakampio plotas = ',Sst);
                                     writeln('***********************************');
                                     readkey;
                                  end;
                            end;
                      end
        else
           begin
              if pas='4' then
                begin
                 clrscr;
                 writeln('********************************************************************');
                 writeln('GEOMETRINIU FIGURU SKAICIAVIMO PROGRAMA 1.0  (c) Gytis Morkunas 2000');
                 writeln('********************************************************************');
                 writeln;
8:               writeln('Koks vieno trapecijos pagrindo ilgis?');
                 read(trpagr1);
                 if trpagr1<0 then
                                begin
                                   writeln('Zioply, neigiamas buti negali!');
                                   goto 8;
                                end
                 else
9:                 begin
                      writeln('Koks kito trapecijos pagrindo ilgis?');
                      read(trpagr2);
                      if trpagr2<0 then
                                     begin
                                        writeln('Zioply, neigiamas buti negali!');
                                        goto 9;
                                     end
                      else
10:                     begin
                           writeln('Koks trapecijos aukstines ilgis?');
                           read(trh);
                           if trh<0 then
                                      begin
                                         writeln('Zioply, neigiamas buti negali!');
                                         goto 10;
                                       end
                           else
                              begin
                                Str:=((trpagr1*trpagr2)/2)*trh;
                                writeln('*************************************');
                                writeln('Trapecijos plotas = ',Str);
                                writeln('*************************************');
                                readkey;
                              end;
                        end;
                   end;
                end
              else
                begin
                  if pas='5' then
                             begin
                                clrscr;
                                writeln('********************************************************************');
                                writeln('GEOMETRINIU FIGURU SKAICIAVIMO PROGRAMA 1.0  (c) Gytis Morkunas 2000');
                                writeln('********************************************************************');
                                writeln;
11:                             writeln('Koks lygiagretainio pagrindo ilgis?');
                                read(lygpagr);
                                if lygpagr<0 then
                                               begin
                                                  writeln('Zioply, neigiamas buti negali!');
                                                  goto 11;
                                               end
                                else
                                  begin
12:                                  writeln('Koks lygiagretainio aukstines ilgis?');
                                     read(lygh);
                                     if lygh<0 then
                                                 begin
                                                    writeln('Zioply, neigiamas buti negali!');
                                                    goto 12;
                                                 end
                                     else
                                        begin
                                           Slyg:=lygh*lygpagr;
                                           writeln('****************************************');
                                           writeln('Lygegretainio plotas = ',Slyg);
                                           writeln('****************************************');
                                           readkey;
                                        end;
                                  end;
                                  end
                  else
                    begin
                       if pas='6' then
                                     begin
                                       clrscr;
                                       writeln('********************************************************************');
                                       writeln('GEOMETRINIU FIGURU SKAICIAVIMO PROGRAMA 1.0  (c) Gytis Morkunas 2000');
                                       writeln('********************************************************************');
                                       writeln;
13:                                    writeln('Koks apskritimo spindulio ilgis?');
                                       read(spind);
                                       if spind<0 then
                                                    begin
                                                       writeln('Zioply, neigiamas buti negali!');
                                                       goto 13;
                                                    end
                                       else
                                          begin
                                             C2:=2*(314/100)*spind;
                                             writeln('**************************************');
                                             writeln('Apskritimo ilgis = ',C2);
                                             writeln('**************************************');
                                             readkey;
                                          end;
                                     end
                       else
                         begin
                            if pas='7' then
                                         begin
                                            clrscr;
                                            writeln('********************************************************************');
                                            writeln('GEOMETRINIU FIGURU SKAICIAVIMO PROGRAMA 1.0  (c) Gytis Morkunas 2000');
                                            writeln('********************************************************************');
                                            writeln;
14:                                         writeln('Koks apskritimo spindulio ilgis?');
                                            read(spind2);
                                            if spind2<0 then
                                                          begin
                                                             writeln('Zioply, neigiamas buti negali!');
                                                             goto 14;
                                                          end
                                            else
                                              begin
15:                                              writeln('Koks lanko laipsninis matas?');
                                                 read(lps);
                                                 if lps<0 then
                                                            begin
                                                               writeln('Zioply, neigiamas buti negali!');
                                                               goto 15;
                                                            end
                                                 else
                                                    begin
                                                       I:=((314/100)*spind2)/lps;
                                                       writeln('**************************************');
                                                       writeln('Lanko ilgis = ',I);
                                                       writeln('**************************************');
                                                       readkey;
                                                    end;
                                              end;
                                         end
                            else
                              begin
                                 if pas='8' then
                                              begin
                                                 clrscr;
                                      writeln('********************************************************************');
                                      writeln('GEOMETRINIU FIGURU SKAICIAVIMO PROGRAMA 1.0  (c) Gytis Morkunas 2000');
                                      writeln('********************************************************************');
                                             writeln;
16:                                              writeln('Koks skritulio spindulio ilgis?');
                                                 read(spind3);
                                                 if spind3<0 then
                                                               begin
                                                                  writeln('Zioply, neigiamas buti negali!');
                                                                  goto 16;
                                                               end
                                                 else
                                                   begin
                                                      Sskrit1:=314/100*sqr(spind3);
                                                      writeln('**************************************');
                                                      writeln('Skritulio plotas = ',Sskrit1);
                                                      writeln('**************************************');
                                                      readkey;
                                                   end;
                                                   end
                                 else
                                 begin
                                    if pas='1'then
                                                begin
   clrscr;
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
        writeln;
        writeln('Gal norite kazka paskaiciuoti dar karta? T/N.');
        sutikimas:=readkey;
        if sutikimas='t'then goto 1
                      else
                          begin
                             if sutikimas='n' then
                             else
                               begin
                                goto 4;
                               end;
                          end;
             end;
              end;
              end;
              end;
              end;
              end;
              end;
              end;
              end.