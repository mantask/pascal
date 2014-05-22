program the_reflecting_god;
uses crt;
var seka: array [1..100] of integer;
    tiesa: array [1..100] of boolean;
    a,b,c,d,e:integer;
label 1;
begin
    clrscr;
    checkbreak:=false;
    c:=-maxint;
    writeln('kiek ivesi?');
1:  read(a);
    if a>100 then
               begin
                   writeln ('Vesk is naujo, zioply!');
                   goto 1;
               end;
    for b:= 1 to a do
       begin
          read (seka[b]);
       end;

    writeln;
    write('skaiciai mazejimo tvarka: ');
  for e:=1 to a do begin
     for b:= 1 to a do
        begin
          if (seka[b]>c) and (not tiesa[b]) then
                begin
                   c:=seka[b];
                   d:=b;
                end;
        end;
    write(seka[d],' ');
    tiesa[d]:=true;
    c:=-maxint;
    end;
    readkey;
end.

