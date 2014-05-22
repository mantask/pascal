program sferos_taskai;

const
  q = 10;
  cx = 199;
  cy = 100;

var
  x, y : word;
  alfa, beta : real;
  nr, r, cka, ckb, ck : integer;
  task : array [0 .. 71, 1 .. 3] of integer;

procedure pix3d (x, y, z : integer; var xx, yy : word);
begin
  if z = 0 then z := 1;
  xx := cx + round (x * Q / z);
  yy := cy + round (y * Q / z)
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
   r := 30;

   for cka := 0 to 11 do
   begin
     alfa := cka * pi / 30;
     for ckb := 0 to 5 do
     begin
       beta := ckb * pi / 30;
       nr := cka * 6 + ckb;
       task [nr, 1] := round (r * cos (alfa) * cos (beta));
       task [nr, 2] := round (r * sin (alfa) * cos (beta));
       task [nr, 3] := round (r * sin (beta))
     end
   end;

   asm
     mov  ax, 13h
     int  10h
   end;

   repeat
     for ck := 0 to 71 do
     begin
       pix3d (task [ck, 1], task [ck, 2], task [ck, 3], x, y);
       mem [$A000 : y * 320 + x] := 0;
       pasukimas (task [ck, 1], task [ck, 2], task [ck, 3], 10, 10, 0);
     end;

     for ck := 0 to 71 do
     begin
       pix3d (task [ck, 1], task [ck, 2], task [ck, 3], x, y);
       mem [$A000 : y * 320 + x] := 15;
     end;

     delay (1000);

   until port [$60] = 1;

   asm
     mov  ax, 3h
     int  10h
   end
end.