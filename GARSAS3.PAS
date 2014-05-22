program garsas;
   uses crt;
   var ck, g, t: integer;
      a : char;
   procedure p (g,t: integer);
      begin
         sound (g);
         delay (t);
         nosound;
         delay (100);
      end;
begin
   t := 5;
   for ck := 200 to 10000 do begin
      if keypressed then break;
      g := abs (5*ck*ck*ck div ck*ck mod 10000);
      p (g,t);
     end;
end.