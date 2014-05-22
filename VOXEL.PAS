{MK 2001}
{volume pixel}

{reiketu paletes gerai nusistatyti ir viskas OK}

{$M 16384,0,655360}
program VOXEL;

Uses
  crt, graph;
Const
  ilg = 100;  {dydis}
  plius = 2;  {kiek prideti prie soniniu krastiniu vidurio}
  centras = 1;{kiek prideti prie centrinio tasko}
  sp =  8;    {saplvu skaicius}
  px = 250;    {virsunes koordinate}
  py = 170;    {virsunes koordinate}
  Xeye = ilg; {trimaciui vaizdui}
  Yeye = ilg; {trimaciui vaizdui}
  Zeye = ilg; {trimaciui vaidzui}
  kryptis : array [0 .. 3, 0 .. 1] of shortint =
            ((0, -1), (1, 0), (0, 1), (-1, 0));
Type
  Tmatrix = array [1 .. ilg, 1 .. ilg] of 0 .. sp - 1;
Var
  matrix : Tmatrix;
  gm, gd : integer;
  palette : paletteType;

Procedure Refresh; Assembler;
asm
   mov dx,3DAh
@@1:
   in al,dx
   and al,08h
   jnz @@1
@@2:
   in al,dx
   and al,08h
   jz  @@2
end;

Procedure Pix3d (var outx, outy : integer; x, y, z : real);
  var a : integer;
begin
  a := round (z - Zeye);
  if a = 0 then a := 1;
  outx := round (256 * x / a) + Xeye;
  outy := round (256 * y / a) + Yeye;
end;

procedure piesimas3D (const Matrix : Tmatrix);
  var ckx, cky : byte;
      x, Y : integer;
begin
  for cky := 1 to ilg do
  for ckx := 1 to ilg do
  begin
    pix3D (x, y, ckx, cky, matrix [ckx, cky] * plius);
    setcolor (matrix [ckx, cky]);
    rectangle (x + px, y + py, x + px + plius, y + py + plius);
{    putpixel (x, y, matrix [ckx, cky]);}
  end;
end;

procedure judejimas (var matrix : Tmatrix; const kr : byte);
  var ckx, cky, x, y : byte;
      pg : Tmatrix;
begin
  for ckx := 1 to ilg do
  for cky := 1 to ilg do
  begin
    if (ckx + kryptis [kr, 0]) >= 1 then
    begin
      if (ckx + kryptis [kr, 0]) > ilg then x := 1
                                       else x := ckx + kryptis [kr, 0]
    end
    else x := ilg;
    if (cky + kryptis [kr, 1]) >= 1 then
    begin
      if (cky + kryptis [kr, 1]) > ilg then y := 1
                                       else y := cky + kryptis [kr, 1]
    end
    else y := ilg;
    pg [ckx, cky] := matrix [x, y];
  end;
  matrix := pg;
end;

procedure palete;
begin
  SetRGBPalette ( 0,   0,   0,   0);
  SetRGBPalette ( 1,   0,   7, 102);
  SetRGBPalette ( 2,  12,  85,  48);
  SetRGBPalette ( 3,   0,  80,  75);
  SetRGBPalette ( 4,   0, 100,  90);
  SetRGBPalette ( 5,  10, 100,  71);
  SetRGBPalette ( 6,  30, 120,  91);
  SetRGBPalette ( 7,  50, 140, 110);
  SetRGBPalette ( 8, 255, 255, 255);
{  SetRGBPalette ( 9,   0,   0, 255);
  SetRGBPalette (10,   0,   0, 255);
  SetRGBPalette (11,   0,   0, 255);
  SetRGBPalette (12,   0,   0, 255);
  SetRGBPalette (13,   0,   0, 255);
  SetRGBPalette (14,   0,   0, 255);
  SetRGBPalette (15, 255, 255, 255);}
end;

procedure valymas (var matrix : Tmatrix);
  var ckx, ckY : byte;
begin
  for ckx := 1 to ilg do
  for cky := 1 to ilg do
  matrix [ckx, cky] := 0
end;

procedure generavimas (var matrix : Tmatrix; x1, y1, x2, y2 : byte);
  var vx, vy : byte; {krastiniu vidurio taskas}
begin
  if ((x1 + 1) < x2) and ((y1 + 1) < Y2) then
  begin
    vx := (x1 + x2) div 2;
    vy := (y1 + y2) div 2;

    if matrix [vx, vy] = 0 then {centras}
    matrix [vx, vy] := ((matrix [x1, y1] + matrix [x2, y2] + matrix [x1, y2] + matrix [x2, y1]) div 4 + centras) mod sp;

    if matrix [x1, vy] = 0 then {kaire}
    matrix [x1, vy] := ((matrix [x1, y1] + matrix [x1, y2]) div 2 + random (plius)) mod sp;

    if matrix [vx, y2] = 0 then {apacia}
    matrix [vx, y2] := ((matrix [x1, y2] + matrix [x2, y2]) div 2 + random (plius)) mod sp;

    if matrix [x2, vy] = 0 then {desine}
    matrix [x2, vy] := ((matrix [x2, y1] + matrix [x2, y2]) div 2 + random (plius)) mod sp;

    if matrix [vx, y1] = 0 then {virsus}
    matrix [vx, y1] := ((matrix [x1, y1] + matrix [x1, y2]) div 2 + random (plius)) mod sp;

    generavimas (matrix, x1, y1, vx, vy);
    generavimas (matrix, vx, y1, x2, vy);
    generavimas (matrix, vx, vy, x2, y2);
    generavimas (matrix, x1, vy, vx, y2);
  end;
end;

procedure piesimas (const matrix : Tmatrix);
  var ckx, ckY : byte;
begin
  for ckx := 1 to ilg do
  for ckY := 1 to ilg do
  putpixel (ckx + px, cky + py, matrix [ckx, cky]);
end;

procedure Blur (var Matrix : Tmatrix);
  var pg : tmatrix;
      ckx, cky : byte;
      suma : word;
      dal : 0 .. 8;
begin
  for ckx := 1 to ilg do
  for ckY := 1 to ilg do
  begin
    suma := 0;
    dal := 0;
    if (ckY - 1) > 0 then {virsuj}
    begin
      inc (dal);
      suma := suma + matrix [ckx, cky - 1]; {vidurys}
      if (ckx - 1) > 0 then {kaire}
      begin
        inc (dal);
        suma := suma + matrix [ckx - 1, cky - 1];
      end;
      if (ckx + 1) <= ilg then {desine}
      begin
        inc (dal);
        suma := suma + matrix [ckx + 1, cky - 1];
      end;
    end;
    if (ckY + 1) <= ilg then {apacioj}
    begin
      inc (dal);
      suma := suma + matrix [ckx, cky + 1]; {vidurys}
      if (ckx - 1) > 0 then {kaire}
      begin
        inc (dal);
        suma := suma + matrix [ckx - 1, cky + 1];
      end;
      if (ckx + 1) <= ilg then {desine}
      begin
        inc (dal);
        suma := suma + matrix [ckx + 1, cky + 1];
      end;
    end;
    if (ckx - 1) > 0 then {kaire}
    begin
      inc (dal);
      suma := suma + matrix [ckx - 1, cky];
    end;
    if (ckx + 1) <= ilg then {desine}
    begin
      inc (dal);
      suma := suma + matrix [ckx + 1, cky];
    end;
    if dal <> 0 then pg [ckx, cky] := suma div dal;
  end;
  matrix := pg;
end;
                  var x, y : integer;
begin
  valymas (matrix);
  randomize;
  matrix [  1,   1] := random (sp);
  matrix [  1, ilg] := random (sp);
  matrix [ilg,   1] := random (sp);
  matrix [ilg, ilg] := random (sp);
  generavimas (matrix, 1, 1, ilg, ilg);
  blur (matrix);
  blur (matrix);
  initgraph (gm, gd, '');
  palete;
{  piesimas (matrix);}
{  piesimas3D (matrix);}
  setcolor (8);
  outtextxy (px, py - 10, 'Voxel efektas');
  rectangle (px - 1, py - 1, px + ilg + 2, py + ilg + 2);
  outtextxy (px + 23, py + ilg + 4, 'MK 2001');
  outtextxy (px + 23, py + ilg + 14, '100x100');
  rectangle (px - 3, py - 13, px + ilg + 4, py + ilg + 24);
  repeat
    delay (100);
    piesimas (matrix);
    refresh;
    judejimas (matrix, 0);
    judejimas (matrix, 1);
  until port [$60] = 1;
  closegraph;
  valymas (matrix);
end.