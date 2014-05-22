{2 lentelese ismustos skyles ir randu kokioje pozicijoje bendru skyliu
 yra daugiausia ir apskaiciuoju, kiek ju yra}
program programa;
   var skyles1, skyles2: array [1 .. 100, 1 .. 100] of boolean;
       gal_bendras, bendras, atvejas, pasukimas, n,
       s_sk1, S_sk2, ck, x, y :integer;
       apverstas, ap: boolean;
begin

   writeln;
   readln(n, s_sk1, S_sk2);

   for ck := 1 to s_sk1 do
      begin
         readln (x, y);
         skyles1 [x, y] := true;
      end;

   for ck := 1 to s_sk2 do
      begin
         readln (x, y);
         skyles2 [x, y] := true;
      end;

   pasukimas := 1;
   gal_bendras:=0;

   repeat
      {TIKRINIMAS}
      bendras := 0;
      for x := 1 to n do begin
          for y := 1 to n do begin
             if skyles1 [x, y] and skyles2 [x, y]
               then
                  begin
                     bendras := bendras + 1;
                     if bendras > gal_bendras
                        then
                           begin
                             atvejas := pasukimas;
                             if apverstas then ap:= true;
                           end;
                  end;
          end;
      end;

      {PASUKIMAS}
      pasukimas := pasukimas + 1;

      for x := 1 to n do begin
         for y := 1 to n do begin
            if skyles1 [x, y]
               then
                 begin
                    skyles1 [x, y] := false;
                    x := y;
                    y := n + 1 - x;
                    skyles1 [x, y] := true;
                 end;
         end;
      end;


   {APVERTIMAS}
   if pasukimas = 4 then begin
       apverstas := true;
       for x := 1 to n do begin
         for y := 1 to n do begin
            if skyles1 [x, y]
                then
                   begin
                       skyles1 [x, y] := false;
                       x := n - x;
                       y := n - y;
                       skyles1 [x, y] := true;
                   end;
         end;
       end;
   end;


   if bendras > gal_bendras then gal_bendras := bendras;

   until pasukimas = 4;


   write ('Atvejas', atvejas:3,' skyliu sutampa ', gal_bendras :3);
   if ap then writeln (' apverstas')
end.