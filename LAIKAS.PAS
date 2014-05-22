program asd;
   uses crt;
   var time : integer absolute $0000:$046c;
       ck, t : integer;
begin
   clrscr;
   repeat
      inc (time);
      time := time mod 38;
      nosound;
      if (time = 18) or (time = 37) then inc (ck);
      if ck = 1000 then begin ck := 1; inc (t); sound (4200); end;
      gotoxy (5, 5); write (t);
   until keypressed;
   while keypressed do readkey;
end.