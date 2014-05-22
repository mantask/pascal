{MK 2001}
{volume pixel}

{reiketu paletes gerai nusistatyti ir viskas OK}

{$M 16384,0,655360}
program VOXEL;

Const
  ilg = 100;  {dydis}
  plius = 2;  {kiek prideti prie soniniu krastiniu vidurio}
  centras = 1;{kiek prideti prie centrinio tasko}
  sp = 64;    {spalvu skaicius}
  px = 10;    {virsunes koordinate}
  py = 10;    {virsunes koordinate}
  kryptis : array [0 .. 3, 0 .. 1] of shortint =
            ((0, -1), (1, 0), (0, 1), (-1, 0));
Type
  Tmatrix = array [1 .. ilg, 1 .. ilg] of 0 .. sp - 1;
Var
  matrix : Tmatrix;

procedure putpixel (x, y, sp : byte);
begin
  mem [$A000 : 320 * y + x] := sp;
end;

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

procedure palete;
var
  ck : byte;
begin
  for ck := 1 to 20 do
  begin
    port [$3C8] := ck;
    port [$3C9] := ck;
    port [$3C9] := ck;
    port [$3C9] := 2 * ck + 23;
  end;
  for ck := 21 to 43 do
  begin
    port [$3C8] := ck;
    port [$3C9] := 0;
    port [$3C9] := 255 - ck;
    port [$3C9] := 43 - ck;
  end;
  for ck := 44 to 63 do
  begin
    port [$3C8] := ck;
    port [$3C9] := 0;
    port [$3C9] := 255 - ck;
    port [$3C9] := (63 - ck) mod 5
  end;
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
      dal : 0 .. sp - 1;
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

  asm
    mov  ax, 13h
    int  10h
  end;

  palete;
  piesimas (matrix);
  repeat until port [$60] = 1;
  valymas (matrix);

  { textinis rezimas }
  asm
    mov  ax, 3h
    int  10h
  end;
end.