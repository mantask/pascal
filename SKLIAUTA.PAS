{ MK 2001 }
{ Skliautas }

program skliautas;

uses
  graph;

const
  ilg = 10;
  deep = 3;
  cx = 319;
  cy = 239;

type
  Tsky = array [0 .. ilg - 1, 1 .. 3] of integer;

var
  sky : Tsky;
  gd, gm : integer;

procedure generate (var sky : Tsky);
var
  ck : byte;
begin
  randomize;
  for ck := 0 to ilg - 1 do
  begin
    sky [ck, 1] := random (100) + 3;
    sky [ck, 2] := random (100) + 3;
    sky [ck, 3] := random (100) + 3
  end
end;

procedure turnOne (var x, y, z : integer; xx, yy, zz : integer);
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

procedure turnAll (var sky : Tsky; degx, degy, degz : word);
var
  ck : INteger;
begin
  for ck := 0 to ilg - 1 do
  turnOne (sky [ck, 1], sky [ck, 2], sky [ck, 3], degx, degy, degZ)
end;

procedure draw (const sky : Tsky; col : byte);
var
  x, y,
  ck : Integer;
begin
  for ck := 0 to ilg - 1 do
  begin
    if sky [ck, 3] = 0 then
    begin
      x := (sky [ck, 1] * deep);
      y := (sky [ck, 1] * deep);
    end
    else
    begin
      x := round ((sky [ck, 1] * deep) / sky [ck, 3]);
      y := round ((sky [ck, 2] * deep) / sky [ck, 3])
    end;
    putpixel (cx + x, cy + y, col);
  end
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

  generate (sky);

  repeat
    draw (sky, 0);
    turnall (sky, 10, 5, 1);
    draw (sky, 7);
    delay (100)
  until port [$60] = 1;

  closegraph
end.