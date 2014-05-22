program sumavimas;
   const kiekis = 5;
   type mas = array [1..kiekis] of boolean;
   var skaiciai: array [1..kiekis] of integer;
       ck, gal_suma: integer;
       dem: mas;

   procedure sum (sk, ats: integer; var dem: mas);
     var ck: integer;
   begin
      if ats = gal_suma then writeln (ats)
      else if sk <= kiekis then
          BEGIN
            sum (sk + 1, ats + skaiciai [sk], dem);
            sum (sk + 1, ats, dem);
          END
   end;


begin
   gal_suma := 13;
   for ck := 1 to kiekis do skaiciai[ck] := random (9) + 1;
   sum (1,0, dem);
   for ck := 1 to kiekis do if dem [ck] then writeln (skaiciai[ck])

end.