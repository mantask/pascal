program vertimai;
  var lab: array [1..100, 1..100] of boolean;
      ck, x, y, X1, Y1, dydis, sukSK, suk: integer;
      laik: boolean;
      LB_in: text;
      kr: array [1..500] of boolean;
      simb: char;
begin
   assign (lb_in, 'labir.in');
   reset (lb_in);
   readln (lb_in, dydis, x1, y1);
   ck := 0;
   repeat
      inc (ck);
      read (lb_in, simb);
      if simb = 'K' then kr [ck] := false else kr [ck] := true;
   until eoln (lb_in);
   sukSk := ck;
   readln (lb_in);
   for y := 1 to dydis do
    begin
      for x := 1 to dydis do
        begin
          read (lb_in, simb);
          if simb = '1' then lab [x, y] := false else lab [x, y] := true
        end;
      readln (lb_in)
    end;
   ck := 0;
   suk := 2;
   repeat
     inc (CK);
     if kr [ck] then suk := suk mod 4 + 1 else suk := (suk + 3) mod 4 + 1;
     case suk of
       1: while lab [x1 + 1, y1] = true do if (x1 + 1) <= dydis then inc (x1);
       2: while lab [x1, y1 + 1] = true do if (y1 + 1) <= dydis then inc (y1);
       3: while lab [x1 - 1, y1] = true do if (x1 - 1) >= 1 then dec (x1);
       4: while lab [x1, y1 - 1] = true do if (y1 - 1) >= 1 then dec (y1);
     end;
   until ck = sukSK;
   writeln (x1,' ',  y1);
{false kaire, true desine}
end.

