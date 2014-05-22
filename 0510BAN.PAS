program und;
uses crt;
var myg: char;
begin
  writeln('Naudokites klavisais nuo ` iki \');
  repeat{ ord(myg)=27 do
  {  begin }{
       myg:=readkey;
       if myg='`' then
                   begin
                      sound(100);
                      delay(1000);
                      nosound;
                   end;
       if myg='1' then
                   begin
                      sound(200);
                      delay(1000);
                      nosound;
                   end;
       if myg='2' then
                   begin
                      sound(300);
                      delay(1000);
                      nosound;
                   end;
        if myg='3' then
                   begin
                      sound(400);
                      delay(1000);
                      nosound;
                   end;
        if myg='4' then
                   begin
                      sound(500);
                      delay(1000);
                      nosound;
                   end;
        if myg='5' then
                   begin
                      sound(600);
                      delay(1000);
                      nosound;
                   end;
          if myg='6' then
                   begin
                      sound(700);
                      delay(1000);
                      nosound;
                   end;
       if myg='7' then
                   begin
                      sound(800);
                      delay(1000);
                      nosound;
                   end;
       if myg='8' then
                   begin
                      sound(900);
                      delay(1000);
                      nosound;
                   end;
      if myg='9' then
                   begin
                      sound(1000);
                      delay(1000);
                      nosound;
                   end;

      if myg='0' then
                   begin
                      sound(1100);
                      delay(1000);
                      nosound;
                   end;
      if myg='-' then
                   begin
                      sound(1200);
                      delay(1000);
                      nosound;
                   end;
      if myg='=' then
                   begin
                      sound(1300);
                      delay(1000);
                      nosound;
                   end;
      if myg='\' then
                   begin
                      sound(1400);
                      delay(1000);
                      nosound;
                   end;
  {  end; }
  
  sound(random(1500));
  delay(1500);
  nosound;
  write(myg);
  until ord(myg)=27;
  nosound;
  clrscr;
end.