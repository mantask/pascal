program daliklis;
uses crt;
var a,b,c,d,g:longint;
begin
clrscr;
readln(a,b);
d:=1;
if a>=b then g:=a
        else g:=b;
for c:=1 to g do
 begin
 if (a mod c=0) and (b mod c=0) and (c>d) then d:=c;
 end;
writeln(d);
readkey;
end.