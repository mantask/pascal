program trinaris;
uses crt;
var i:integer;
    a,b,c,dis:real;
    x1,x2,ri,m,n:real;
    z1,z2,ats,plius,plius1,pl1,pl2:char;
    sla:string;
label 1,11,12,13,2,21;

{----------------------------}
{ TiS� Mantas Kanaporis 2000 }
{----------------------------}

{-=pradzia=-}
FUNCTION skaitymas:real;
var tekstas: string;
    num, kabl_poz, atmn, pradz_num: integer;
    yra_kabl, yra_min, klaida: boolean;
    TXTiSK,skaitmuo: real;

function laipsnis_10 (rodiklis: integer):real;
   var kartas: integer;
       laipsnis: real;
   BEGIN
   laipsnis:=1;
   for kartas:=1 to rodiklis do begin
         laipsnis:=laipsnis*10;
       end;
   laipsnis_10:=laipsnis;
   END;

BEGIN
   repeat
     TXTiSK:=0;
     klaida:=false;
     yra_kabl:=false;
     yra_min:=false;
     readln(tekstas);
     if (length(tekstas)=1) and ((tekstas[1]='.')or(tekstas[1]='-')) then klaida:=true;
     if length(tekstas)=0 then klaida:=true;
     for num:=1 to length(tekstas) do begin
          if tekstas[num] in ['0'..'9','.','-'] then else klaida:=true;
          if tekstas[num]='-' then begin if num<>1 then klaida:=true; yra_min:=true end;
          if tekstas[num]='.' then
             if yra_kabl then klaida:=true else
                begin yra_kabl:=true; kabl_poz:=num; end;
     end;
     if yra_min then pradz_num:=2 else pradz_num:=1;
     for num:=pradz_num to length(tekstas) do begin
         case tekstas[num] of
              '.':skaitmuo:=0;
              '-':skaitmuo:=0;
              '0':skaitmuo:=0;
              '1':skaitmuo:=1;
              '2':skaitmuo:=2;
              '3':skaitmuo:=3;
              '4':skaitmuo:=4;
              '5':skaitmuo:=5;
              '6':skaitmuo:=6;
              '7':skaitmuo:=7;
              '8':skaitmuo:=8;
              '9':skaitmuo:=9;
         end;
         if num>kabl_poz then atmn:=1 else atmn:=0;
         if yra_kabl then TXTiSK:=TXTiSK+skaitmuo*laipsnis_10(length(tekstas)+atmn-num)
              else TXTiSK:=TXTiSK+skaitmuo*laipsnis_10(length(tekstas)-num);
     end;
     if yra_kabl then TXTiSK:=TXTiSK/laipsnis_10(length(tekstas)+1-kabl_poz);
     if yra_min then skaitymas:=-TXTiSK else skaitymas:=TXTiSK;
   until not klaida;
END;
{-=pabaiga=-}
{ TiS� }

begin
    clrscr;
    {cia garsas prasideda}
    sound(500);
    delay(10000);
    sound(1000);
    delay(10000);
    sound(1500);
    delay(10000);
    nosound;
    {cia baigiasi}
1:  clrscr;
    writeln('KLSP� Mantas Kanaporis 2000');
    writeln('===========================');
    writeln;
    writeln('Iveskite kintamuosius eil�s tvarka pagal ax�+bx+c=0 formul�, kai a nelygu 0');
    writeln;
    write('Iveskite a: ');
11: a:=skaitymas;
    if a=0 then
               begin
                  writeln;
                  writeln('!!! kintamasis a negali b�ti lygus nuliui !!!');
                  readkey;
                  goto 1;
               end
    else
    begin
    write('Iveskite b: ');
12: b:=skaitymas;
    write('Iveskite c: ');
13: c:=skaitymas;
    Dis:=sqr(b)-4*a*c;
    writeln;
    if b<0 then plius:='-'
     else plius:='+';
    if c<0 then plius1:='-'
     else plius1:='+';
    if (b<>0) and (c<>0) then writeln('Lygtis ',a:1:2,'x�',plius,abs(b):1:2,'x',plius1,abs(c):1:2,'=0')
      else
         begin
            if (b=0) and (c<>0) then writeln('Lygtis ',a,'x�',plius1,abs(c),'=0')
             else
                begin
                   if (c=0) and (b<>0) then writeln('Lygtis ',a,'x�',plius,abs(b),'=0')
                    else writeln(a,'x�=0');
                end;
         end;
    writeln;
    if dis<0 then writeln('Diskriminantas lygus ', dis)
      else
        begin
           if dis=0 then
                    begin
                       if (b=0) then writeln('Diskriminantas lygus ',dis:1:2,', x=0, /0=',sqrt(dis):2:10)
                        else writeln('Diskriminantas lygus ',dis:1:2,', x=(',-b,'):',2*a,', /0=',sqrt(dis):2:10);
                    end
            else
              begin
                if b=0 then writeln('Diskriminantas lygus ',dis:1:2, ', x=(�/',dis:1:2,'):',2*a,', /',dis,'=',sqrt(dis):2:10)
                  else writeln ('Diskriminantas lygus ',dis:1:2,', x=(',(-1)*b,'�/',dis,'):',2*a,', /',dis,'=',sqrt(dis):2:10);
              end;
        end;
    writeln('-------------------------------------------------------------');
    if dis<0 then
               begin
                  writeln('Diskriminantas yra neigiamas. Lygtis neturi �akn�.');
                  writeln;
                  writeln('Programa nutraukiama...');
               end
    else
       Begin
          x1:=(-b+sqrt(dis))/(2*a);
          x2:=(-b-sqrt(dis))/(2*a);
          if dis=0 then writeln('Lygties �aknis lygi ',x1:2:10)
          else writeln('Lygties �aknys lygios: ',x1:2:10,' ir ',x2:2:10);
          writeln('-------------------------------------------------------------');
          IF x1>0 then z1:='-'
               else
                  begin
                     z1:='+';
                     x1:=-x1;
                  end;
               IF x2>0 then z2:='-'
               else
                  begin
                    z2:='+';
                    x2:=-x2;
                  end;
               write('I�kirta sandauga atrodo taip:  ');
               if (dis=0)and(b=0) then writeln(a,' x�')
               else
                  begin
                     if dis=0 then writeln(a,' (x ',z1,' ',x1:5:3,')�')
                     else
                       begin
                          if (x1=0) and (x2<>0) then writeln(a,'x (x',z2,x2:5:3,')')
                           else
                            begin
                               if (x2=0) and (x1<>0) then writeln(a,'x (x',z1,x2:5:3,')')
                                else if (x1=0) and (x2=0) then writeln(a,'x�')
                                      else writeln (a,' (x ',z1,' ',x1:5:3,') (x ',z2,' ',x2:5:3,')');
                            end;
                       end;
                  end;
             writeln('-------------------------------------------------------------');
             END;
    writeln;
    writeln('I�skirtas trinario kvadratas arba funkcijos vir��n�s koordinat�s:');
{   paraboles virsunes koordinates (m,n) }
    m:=-(b/(2*a));
    n:=-((sqr(b)-4*a*c)/(4*a));
    if m>=0 then pl1:='+'
     else pl1:='-';
    if n>=0 then pl2:='+'
     else pl2:='-';
    if (m=0) and (n=0) then writeln(a,'x�')
     else begin if (m=0) and (n<>0) then writeln(a,'x�',pl2,abs(n))
                 else begin if (m<>0) and (n=0) then writeln(a,'(x',pl1,abs(m),')�')
                             else writeln(a,'(x',pl1,abs(m),')�',pl2,abs(n));
                      end;
          end;
    writeln;
    writeln('******************lygtis*baigta*spr�sti**********************');
    writeln;
21: writeln('Ar prad�sime i� naujo? T/N');
    writeln;
2:  ats:=readkey;
    if (ats='t') or (ats='T') then
                  begin
                     goto 1;
                  end
    else
       begin
          if (ats='n') or (ats='N') then
          else
             begin
                if ats='`' then
                     begin
                        clrscr;
                        writeln('   1 6 8 1');
                        writeln('   6 9 1 4');
                        writeln('   5 1 6 8');
                        writeln('=============');
                        write('SLAPTAZODIS: ');
                        readln(sla);
                        if sla='����' then
                                      begin
                                         clrscr;
                                         writeln('KLSP� Mantas Kanaporis 2000');
                                         writeln('===========================');
                                         writeln;
                                         writeln('Sveikinu, J�s radote galutin�s versijos slaptaviet�!');
                                         writeln('Programa para�yta Paskaliu.');
                                         writeln('KLSP - tai "kvadratin� lyg�i� sprendimo programa".');
                                         writeln;
                                         writeln('Marilyn Manson yra tikra grupe tikriems zmonems');
                                         writeln;
                                         writeln;
                                         writeln;
                                         writeln('            ��������������������������ͻ');
                                         writeln('            � MANTO KANAPORIO PROGRAMA �');
                                         writeln('            ��������������������������ͼ');
                                         readkey;
                                         {kvailas veidas prasideda}
                                         repeat
                                           clrscr;
                                           writeln;
                                           writeln('      /|||\       ');
                                           writeln('     ( O O )       |');
                                           writeln('      \ U /      \|||| ');
                                           writeln('       \_/           /');
                                           delay(10000);
                                           clrscr;
                                           writeln;
                                           writeln('     /|||\');
                                           writeln('    ( - - )');
                                           writeln('     \ U /       \||||');
                                           writeln('      \_/            /');
                                           delay(10000);
                                         until keypressed;
                                         {kvailas veidas baigiasi}
                                         clrscr;
                                         goto 21;
                                         end
                        else
                          begin
                             goto 21;
                          end;
                     end
              else
                begin
                  goto 2
                end;
             end;
       end;
       end;
    clrscr
end.
