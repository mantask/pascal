{is ivestos eilutes istrina zodzius, kurie prasideda nurodyta raide}
program eilute;
  uses crt;
  var eil : string;
      raid : char;
      pr, ilg : integer;
begin
   write ('Ivesk eilute: ');
   readln (eil);
   write ('Kokia raide trinsi? ');
   readln (raid);
   pr := 1;
   while pr <= length (eil) do
    begin
      while eil [pr] = ' ' do inc (pr);
      if eil [pr] = raid then
       begin
         ilg := 1;
         while eil [pr + ilg - 1] <> ' ' do inc (ilg);
         delete (eil, pr, ilg);
       end
      else while (eil [pr] <> ' ') and (pr < length (eil)) do inc (pr);
    end;
   writeln (eil);
end.