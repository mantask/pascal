program grafitis;
  uses crt;
  var
    f : text;
    grafas : array [1 .. 5, 1 .. 5] of integer;
    atstumai, aplankyti : array [1 .. 10] of integer;
    virsunes, keliai, g1, g2, ats, ck : integer;
begin
   clrscr;
   assign (f, 'grafas.dat');
   reset (f);
   readln (f, virsunes, keliai);
   repeat
      readln (f, g1, g2, ats);
      grafas [g1, g2] := ats;
      grafas [g2, g1] := ats;
   until eof (f);
   for ck := 2 to 8 do atstumai [ck] := -1;
   g1 := 1; aplankyti [1] := 1;
   g2 := 2; ats := 0;
   repeat
      inc (ats);
      for ck := 2 to virsunes do if (grafas [aplankyti [g1], ck] <> 0) and (atstumai [ck] < 0)
      then begin
         atstumai [ck] := atstumai[aplankyti[g1]]+1;
         aplankyti [g2] := ck;
         inc (g2);
      end;
      inc (g1);
   until g1 = g2;

   write ('Atstumai  ');
   for ck := 1 to 6 do write (atstumai [ck] :3);
   writeln;
   write ('Aplankyta ');
   for ck := 1 to 6 do write (aplankyti [ck] :3);
end.



