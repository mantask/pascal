program sfera;

var



procedure pasukimas (var x, y, z : integer; xx, yy, zz : integer);
var
  pg : record
         x, y, z : integer;
       end;
  sinn, coss : real;
begin
  if xx > 0 then
  begin
    sinn := sin (xx * pi / 180);
    coss := cos (xx * pi / 180);
    pg.y := trunc (y * coss - z * sinn);
    pg.z := trunc (y * sinn + z * coss);
    y := pg.y;
    z := pg.z;
  end;
  if yy > 0 then
  begin
    sinn := sin (yy * pi / 180);
    coss := cos (yy * pi / 180);
    pg.x := trunc (x * coss + z * sinn);
    pg.z := trunc (z * coss - x * sinn);
    x := pg.x;
    z := pg.z;
  end;
  if zz > 0 then
  begin
    sinn := sin (zz * pi / 180);
    coss := cos (zz * pi / 180);
    pg.x := trunc (x * coss - y * sinn);
    pg.y := trunc (x * sinn + y * coss);
    x := pg.x;
    y := pg.y;
  end;
end;


begin

end.