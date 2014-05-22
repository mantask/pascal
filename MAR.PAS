{ MK 2001 }
{ BOI2001 Mars }
program mars;

var
  f : text;
  viso, ck,
  pgx1, pgx2, pgy1, pgy2, { pagalbiniai, skaitymui is failo }
  x1, y1, x2, y2 : Word; { bendro ploto koord }

begin
  assign (f, 'mar0.in');
  reset (f);
  readln (f, viso);
  readln (f, x1, y1, x2, y2);
  for ck := 1 to viso - 1 do
  begin
    readln (f, pgx1, pgy1, pgx2, pgy2);
    if (pgx1 >= x1) and (pgx1 < x2) then x1 := pgx1
    else if pgx1 >= x2 then
    begin
      x1 := 0;
      x2 := 0;
      break
    end;
    if (pgx2 > x1) and (pgx2 <= x2) then x2 := pgx2
    else if pgx2 <= x1 then
    begin
      x1 := 0;
      x2 := 0;
      break
    end;
    if (pgy1 >= y1) and (pgy1 < y2) then y1 := pgy1
    else if pgy1 >= y2 then
    begin
      x1 := 0;
      x2 := 0;
      break
    end;
    if (pgy2 > y1) and (pgy2 <= y2) then y2 := pgy2
    else if pgy2 <= y1 then
    begin
      x1 := 0;
      x2 := 0;
      break
    end;
  end;
  close (f);

  assign (f, 'mar.out');
  rewrite (f);
  writeln (f, (y2 - y1) * (x2 - x1));
  close (f);
end.
