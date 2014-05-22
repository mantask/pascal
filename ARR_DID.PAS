program ann;
uses crt;
var seka: array[1..100] of integer;
    n,x,m: integer;
begin
   clrscr;
   writeln('Kiek skaiciu ivedinesi');
   read (x);
   writeln;
   for m:= 1 to x do
     begin
        read (seka[x]);
        if seka[x] > n then n:=seka[x];
     end;
   writeln;
   writeln('saicius yra ',n);
   readkey;
end.