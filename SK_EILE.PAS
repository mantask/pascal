{is duotos skaiciu eiles, skaicius sumuojant, atimant ir dauginant gaunamas
atsakymas}
program skaiciai;
   uses crt;
   const gs = 10;
   var sk: array [1..5] of integer;

   procedure zz(zenklai: string; skaicius,suma: integer);
   begin
      if (suma = gs) and (skaicius = 6) then writeln (zenklai)
         else if skaicius < 6 then
         begin
           zz (zenklai + '+', skaicius+1, suma + sk [skaicius]);
           zz (zenklai + '-', skaicius+1, suma - sk [skaicius]);
           zz (zenklai + '*', skaicius+1, suma * sk [skaicius])
         end
   end;

begin
   clrscr;
   sk[1] := 3;
   sk[2] := 3;
   sk[3] := 6;
   sk[4] := 7;
   sk[5] := 3;
   zz('', 2, sk[1])
end.