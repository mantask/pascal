program Hanojaus_Bokstai;
   uses crt;
   var zied : integer;

   procedure han (zied : integer; pr, t, gal : char);
   begin
      if zied > 0 then
       begin
         han (zied - 1, pr, gal, t);
         writeln ('Zieda ', zied, ' is ', pr,' i ', gal);
         han (zied - 1, t, pr, gal);
       end
   end;

begin
  clrscr;
  write ('Kiek turite ziedu? ');
  readln (zied);
  han (zied, '1', '2', '3');
  readkey;
end.