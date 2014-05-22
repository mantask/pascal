 uses crt;
 var a,b : byte;
     time : byte absolute 0:$046c;
    g : integer;
    ams : array [1..128] of boolean;

begin
   clrscr;
   repeat
    inc (time);
    ams [a] := false;
    a := port [$60];
    ams [a] := true;
    writeln (ams [2]);
    gotoxy (3, 2);
    writeln (a :3, b:5);
    if keypressed then readkey;
    if time > 17 then inc (g, 100);
    if a < $80 then
         begin
           sound (g);
           time := 0;
         end
               else
         begin
            nosound;
            g := 100;
         end;
   until a = 1;
   nosound
end.