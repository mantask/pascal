program Kompiuterija_56;

var
  ck11, ck22, ck33,
  ck1, ck2, ck3, ck4, ck5, ck6, ck7,
  sk1, sk2 : longint;
  f : text;

function patikrink : boolean;
var
  ok : boolean;
  pg : longint;
begin
  pg := sk1 * ck1 div 10;
  if not odd (pg div 10) or odd (pg mod 10) then
  begin
    patikrink := false;
    exit
  end;

  pg := sk1 * ck2 div 100;
  if not odd (pg mod 10) or not odd (pg div 10) then
  begin
    patikrink := false;
    exit
  end;

  pg := sk1 * ck4 div 10;
  if odd (pg mod 10) or odd (pg div 10) then
  begin
    patikrink := false;
    exit
  end;

  pg := sk1 * ck5 div 10;
  if not odd (pg mod 10) or odd (pg div 10) then
  begin
    patikrink := false;
    exit
  end;

  pg := sk1 * ck6 div 100;
  if odd (pg mod 10) or odd (pg div 10) then
  begin
    patikrink := false;
    exit
  end;

  pg := sk1 * ck7 div 10;
  if not odd (pg mod 10) or not odd (pg div 10) then
  begin
    patikrink := false;
    exit
  end;

  patikrink := true
end;

begin
  assign (f, 'komp56.out');
  rewrite (f);
  for ck11 := 1 to 9 do
  begin
   sk1 := ck11;
   for ck22 := 0 to 9 do
   begin
    sk1 := sk1 * 10 + ck22;
    for ck33 := 0 to 9 do
    begin
     sk1 := sk1 * 10 + ck33;
      for ck1 := 0 to 9 do
      if (sk1 * ck1 > 99) and (sk1 * ck1 < 1000) then
      begin
       sk2 := sk2 * 10 + ck1;
       for ck2 := 0 to 9 do
       if (sk1 * ck2 > 999) and (sk1 * ck2 < 10000) then
       begin
        sk2 := sk2 * 100 + ck2 * 10;
        for ck4 := 0 to 9 do
        if (sk1 * ck4 > 99) and (sk1 * ck4 < 1000) then
        begin
         sk2 := sk2 * 10 + ck4;
         for ck5 := 0 to 9 do
         if (sk1 * ck5 > 99) and (sk1 * ck5 < 1000) then
         begin
          sk2 := sk2 * 10 + ck5;
          for ck6 := 0 to 9 do
          if (sk1 * ck6 > 999) and (sk1 * ck6 < 10000) then
          begin
           sk2 := sk2 * 10 + ck6;
           for ck7 := 0 to 9 do
           if (sk1 * ck7 > 99) and (sk1 * ck7 < 1000) then
           begin
             sk2 := sk2 * 10 + ck7;
             if ((sk1 * sk2) div 1000000000 = 1) and patikrink
             then writeln (f, sk1, ' ', sk2, ' ', sk1 * sk2);
             sk2 := sk2 div 10
           end;
           sk2 := sk2 div 10
          end;
          sk2 := sk2 div 10
         end;
         sk2 := sk2 div 10
        end;
        sk2 := sk2 div 100
       end;
       sk2 := sk2 div 10
      end;
     sk1 := sk1 div 10
    end;
    sk1 := sk1 div 10
   end
  end;
  close (f)
end.
