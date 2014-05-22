program garsas;
   uses crt;
   var ck, g, t: integer;
      a : char;
   procedure p (g,t: integer);
      begin
         sound (g);
         delay (t);
         nosound;
{         delay (2000);    }
      end;
begin
   t := 5;
   for ck := 200 to 10000 do begin
      if keypressed then break;
      g := abs(ck*ck + 2*ck-500);
      p (g,t);
     end;
end.