program virusas;
uses crt;
var x, y, d, k, l:integer;
    a, b:string;
begin
b:='stop';
clrscr;
writeln('Hello! Meet File Killer Virus!');
delay(2000);
clrscr;
write('Installing virus components');
for k:=1 to 10 do
 begin
 write('.');
 delay(200);
 end;
writeln('  Complete');
write('Bye!');
delay(700);
repeat
clrscr;
randomize;
 repeat
 x:=random(78) + 1;
 y:=random(28) + 1;
 gotoxy(x,y);
 write(' ');
 textbackground(random(50));
 sound(random(5000));
 until KeyPressed;
nosound;
clrscr;
textbackground(black);
textcolor(white);
clrscr;
gotoxy(0,0);
write('Enter password: ');
readln(a);
if a<>b then
 begin
 write('Error');
 delay(1000);
 end;
until a=b;
write('Hello Sir Linas. Sorry for disturbing you!');
for d:=1 to 2 do
begin
sound(600);
delay(200);
nosound;
delay(100);
sound(600);
delay(200);
nosound;
delay(100);
sound(500);
delay(200);
nosound;
delay(100);
sound(400);
delay(200);
nosound;
delay(100);
end;
nosound;
delay(1000);
clrscr;
end.