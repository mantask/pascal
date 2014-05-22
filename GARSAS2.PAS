program garsas;
   uses crt;
   var ck, g, t: integer;
      a : char;
   procedure p (g,t: integer);
      begin
         sound (g);
         delay (t);
         nosound;
      end;
begin
   t := 5;
   for ck := 200 to 10000 do begin
      if keypressed then break;
      g := 5*ck*ck*ck div ck*ck  ;
      p (g,t);
     end;
end.