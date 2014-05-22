program kvadratas;
uses crt;
var x, y, kryptis: integer;
begin
   clrscr;
   kryptis:=0;
   x:=1; y:=1;
   gotoxy(x,y);
   repeat
      kryptis := kryptis + 1;
      if kryptis=1 then begin writeln('*'); x:=x+1; gotoxy(x,y); write('*'); x:=x-1; end;
      if kryptis=2 then repeat
                           y:=y+1;
                           gotoxy(x,y);
                           write('*');
                         until x=1;
      if kryptis=3 then begin y:=y+1; gotoxy(x,y); writeln('*'); y:=y+1; gotoxy(x,y); write('*');  end;
      if kryptis=4 then repeat write('*'); x:=x+1; gotoxy(x,y); writeln('*');
                          x:=x+1;
                          y:=y-1;
                          gotoxy(x,y);
                          write('*');
                        until y=1;
      if kryptis=4 then kryptis := 0;
   until x=10
end.