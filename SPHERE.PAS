program sphere;

uses
  graph;

var
  gd, gm : integer;
  alfa, beta : integer;
  x, y, z : real;
  a, b : real;
  R,
  xx, yy : integer;
  taskai : Array [0 .. 1710, 1 .. 3] of integer;

Procedure Pix3d (x, y, z : real; var xx, yy : integer);
begin
  if z = 0 then z := 1;
  xx := round (10 * x / z);
  yy := round (10 * y / z)
end;

procedure pasukimas (var x, y, z : integer; xx, yy, zz : word);
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

procedure delay (ms : Word); Assembler;
asm
  mov ax, 1000;
  mul ms;
  mov cx, dx;
  mov dx, ax;
  mov ah, $86;
  Int $15;
end;

begin
  initgraph (gd, gm, '');

  r := 10;
  for alfa := 0 to 28 do
  begin
    a := alfa * pi / 30;
    for beta := 0 to 58 do
    begin
      b := beta * pi / 30;
      x := R * cos (b) * cos (a);
      y := R * cos (b) * sin (a);
      z := R * sin (b);
      taskai [alfa * 59 + beta, 1] := round (x);
      taskai [alfa * 59 + beta, 2] := round (y);
      taskai [alfa * 59 + beta, 3] := round (z);
    end;
  end;

  alfa := 0;

  repeat
    alfa := (alfa + 30) mod 360;
    for beta := 0 to 1710 do
    begin
      pix3d (taskai [beta, 1], taskai [beta, 2], taskai [beta, 3], xx, yy);
      putpixel (320 - xx, 240 - yy, 15);
      pasukimas (taskai [beta, 1], taskai [beta, 2], taskai [beta, 3], alfa, alfa, alfa);
      pix3d (taskai [beta, 1], taskai [beta, 2], taskai [beta, 3], xx, yy);
      putpixel (320 - xx, 240 - yy, 15)
    end;
    delay (10);
  until port [$60] = 1;

  closegraph
end.
