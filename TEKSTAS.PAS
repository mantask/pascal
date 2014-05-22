program tekstas;
uses crt;
var seka: array [1..maxint] of char;
    a,b:integer;
    c:char;
label 1;
begin
   clrscr;
   for a:= 1 to 10000 do
         begin
             seka[a]:=readkey;
             if ord(seka[a])= 27 then goto 1;
             write(seka[a]);
         end;
1: b:=a-1;
   writeln;
   for a:=1 to b do
     begin
        write(seka[a]);
     end;
     readkey;
end.