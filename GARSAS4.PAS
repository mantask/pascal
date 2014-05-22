program garsas;
   uses crt, dos;
   var ck, g, t: integer;
      a : char;
      ad:boolean;
   procedure p (g,t: integer);
      begin
         sound (g);
         delay (t);
         nosound;
         delay (102);
      end;
begin

   t := 5;
   for ck := 200 to 10000 do
     begin
      if keypressed then
                     begin
                        a := readkey;
                        if ord (a) = 27 then break;
                     end;
      g := ck;
      p (g,t);
     end;
     keep (0);

end.