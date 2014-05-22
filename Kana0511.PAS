program JPM1_5_11;
   type rac = record
                s, v: integer
              end;
   var sk1, sk2, { pradiniai duomenys }
       sk: rac; { atsakymas }

   procedure sum (sk1, sk2: rac; var sk: rac);
   { procedura sumai skaiciuoti }
   var ck: integer;
   begin
      if sk1.v = sk2.v then
         begin
            sk.v := sk1.v;
            sk.s := sk1.s + sk2.s
         end
      else
        begin
           sk.v := sk1.v * sk2.v;
           sk.s := sk1.s * sk2.v + sk2.s * sk1.v
        end;
      for ck := sk.v downto 2 do
        if (sk.v mod ck = 0) and (sk.s mod ck = 0) then
            begin
               sk.v := sk.v div ck;
               sk.s := sk.s div ck;
               break  { rastas dbd, galima nutraukti cikla }
            end
   end;
   procedure sand (sk1, sk2: rac; var sk: rac);
   { procedura sandaugai skaiciuoti }
      var ck: integer;
   begin
      sk.s := sk1.s * sk2.s;
      sk.v := sk1.v * sk2.v;
      for ck := sk.v downto 2 do
        if (sk.v mod ck = 0) and (sk.s mod ck = 0) then
            begin
               sk.v := sk.v div ck;
               sk.s := sk.s div ck;
               break { rastas dbd }
            end
   end;

begin
  sk1.s := 3; sk1.v := 2;
  sk2.s := 2; sk2.v := 3;
  sand (sk1, sk2, sk);
  sum (sk1, sk2, sk);
  writeln (sk.s, ' ', sk.v)
end.