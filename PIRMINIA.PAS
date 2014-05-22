program pirminiai;
var
  sk, ck : longint;
  pirm : boolean;
begin
  for sk := 10000 to 11000 do
   begin
      pirm := true;
      for ck := 2 to (sk div 2) do
       if (sk mod ck) = 0 then
        begin
          if pirm then pirm := false;
          break
        end;
      if pirm then writeln (sk)
   end
end.