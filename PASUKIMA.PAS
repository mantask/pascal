program trimate;

uses
  crt, graph;

const
  ms = 20;
  cx = 319;
  cy = 239;
  cz = 120;
  kubas3D : array [1 .. 8, 1 .. 3] of integer =
          ((0, ms,  0), (ms, ms,  0), (0, ms, ms), (ms, ms, ms),
           (0,  0,  0), (ms,  0,  0), (0,  0, ms), (ms,  0, ms));

var
  ck : byte;
  gd, gm,
  alfax, alfay, alfaZ,
  x, y, z : integer;
  kubas2D : array [1 .. 8, 1 .. 2] of integer;
  pg : string;
  myg : char;

Procedure Pix3d (var xx, yy : integer; x, y, z : integer);
var
  zz : integer;
begin
  zz := round (z - cz);
  if zz = 0 then zz := 1;
  xx := round (256 * x / zz) + cx;
  yy := round (256 * y / zz) + cy;
{  xx := x + cx;
  yy := y + cy;}
end;

procedure piesimas (sp : byte);
begin
  setcolor (sp);
  line (kubas2D [1, 1], kubas2D [1, 2], kubas2D [2, 1], kubas2D [2, 2]);
  line (kubas2D [1, 1], kubas2D [1, 2], kubas2D [3, 1], kubas2D [3, 2]);
  line (kubas2D [1, 1], kubas2D [1, 2], kubas2D [5, 1], kubas2D [5, 2]);
  line (kubas2D [4, 1], kubas2D [4, 2], kubas2D [2, 1], kubas2D [2, 2]);
  line (kubas2D [4, 1], kubas2D [4, 2], kubas2D [3, 1], kubas2D [3, 2]);
  line (kubas2D [4, 1], kubas2D [4, 2], kubas2D [8, 1], kubas2D [8, 2]);
  line (kubas2D [6, 1], kubas2D [6, 2], kubas2D [2, 1], kubas2D [2, 2]);
  line (kubas2D [6, 1], kubas2D [6, 2], kubas2D [5, 1], kubas2D [5, 2]);
  line (kubas2D [6, 1], kubas2D [6, 2], kubas2D [8, 1], kubas2D [8, 2]);
  line (kubas2D [7, 1], kubas2D [7, 2], kubas2D [3, 1], kubas2D [3, 2]);
  line (kubas2D [7, 1], kubas2D [7, 2], kubas2D [5, 1], kubas2D [5, 2]);
  line (kubas2D [7, 1], kubas2D [7, 2], kubas2D [8, 1], kubas2D [8, 2]);
end;

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
  initgraph (gd, gm, '');
  repeat
    if keypressed then
    begin

      myg := readkey;
      case myg of
        'x' : alfaX := (alfaX + 10) mod 360;
        'z' : alfaZ := (alfaZ + 10) mod 360;
        'y' : alfaY := (alfaY + 10) mod 360;

      end;

      piesimas (0);
{      for ck := 1 to 4 do
      begin
        str (ck, pg);
        outtextxy (kubas2d [ck, 1], kubas2d [ck, 2], pg);
        circle (kubas2d [ck, 1], kubas2d [ck, 2], 3);
      end;
      for ck := 5 to 8 do
      begin
        str (ck, pg);
        outtextxy (kubas2d [ck, 1], kubas2d [ck, 2], pg);
        circle (kubas2d [ck, 1], kubas2d [ck, 2], 3);
      end;
}
      for ck := 1 to 8 do
      begin
        x := kubas3D [ck, 1];
        y := kubas3D [ck, 2];
        z := kubas3D [ck, 3];
        pasukimas (x, y, z, alfaX, alfaY, alfaZ);
        pix3D (x, y, x, y, z);
        kubas2D [ck, 1] := x;
        kubas2D [ck, 2] := y;
      end;

      piesimas (7);
{
      for ck := 1 to 4 do
      begin
        str (ck, pg);
        outtextxy (kubas2d [ck, 1], kubas2d [ck, 2], pg);
        circle (kubas2d [ck, 1], kubas2d [ck, 2], 3);
      end;
      setcolor (8);
      for ck := 5 to 8 do
      begin
        str (ck, pg);
        outtextxy (kubas2d [ck, 1], kubas2d [ck, 2], pg);
        circle (kubas2d [ck, 1], kubas2d [ck, 2], 3);
      end;
}
      delay (1000);

    end
  until port [$60] = 1;
  closegraph;
end.