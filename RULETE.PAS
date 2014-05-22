program rulete;
uses crt;
var SKk, SKv, a, t: integer;
BEGIN
  {   case SKk of
       0:
                 __0__
              9/   *   \1
            8/ *   *   * \2
            |*   * * *   *|
            |    * O *    |
            |*   * * *   *|
            7\ *   *   * /3
              6\ __*__ /4}
    clrscr;      { 5    }
    writeln('Prasau ivesti skaiciu nuo 0 iki 9');
    t:=100;
    readln(SKv);
    if SKv > 9 then writeln('Reikejo ivesti skaiciu nuo 0 iki 9, dabar tai tikrai netspesi :)');
    repeat
       gotoxy(40,12);
       SKk:=SKk+1;
       delay(100);
       write(SKk);
       if SKk=9 then SKk:=-1;
    until keypressed;
    for a:=1 to 20 do begin
         gotoxy(40,12);
         delay(t);
         SKk:=SKk+1;
         writeln(SKk);
         if SKk=9 then SKk:=-1;
         t:=t+250;
    end;
    gotoxy(0,20);
    write('Jus ');
    if SKk<>SKv then write('ne');
    write('atspejote. ');
    readkey;
    readkey;
END.