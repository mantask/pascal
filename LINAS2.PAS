program didziausias_skaicius;
uses crt;
var a,b,c,d:longint;
    n:array[1..10000] of longint;
begin
clrscr;
writeln('Kiek skai�i� �vesite? (nuo 1 iki 10000)');
readln(a);
clrscr;
b:= maxlongint;
for c:=1 to a do
   begin
    readln(n[c]);
   end;
for c:=1 to a do
   begin
     if (n[c]>d) then d:=n[c];
     if (n[c]<b) then b:=n[c];
   end;
writeln('Did�iausias skai�ius ',d);
writeln('Ma�iausias skai�ius ',b);
writeln('J� dalmuo ',(d/b):5:3);
readkey;
end.