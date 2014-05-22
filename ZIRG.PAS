{ randa visus galimus baltojo zirgo ejimus taip, kad jo nekirstu juodasis }
program zirgas;

const
  ejimas : array [0 .. 7, 0 .. 1] of integer =
          ((-1,  2), (-2,  1), (-2, -1), (-1, -2),
           ( 1, -2), ( 2, -1), ( 2,  1), ( 1,  2));

var
  bx, by, jx, jy,
  ck, ck1 : byte;
  x, y : integer;
  ejimai : array [0 .. 7, 0 .. 1] of integer;
  f : text;
  c : char;
  yra : boolean;

begin
  assign (f, 'zirg.dat');
  reset (f);
  read (f, c);
  bx := ord (c) - 96;
  readln (f, c);
  by := ord (c) - 48;
  read (f, c);
  jx := ord (c) - 96;
  readln (f, c);
  jy := ord (c) - 48;
  close (f);

  for ck := 0 to 7 do
  begin
    x := bx + ejimas [ck, 0];
    y := by + ejimas [ck, 1];
    if (x >= 1) and (x <= 8) and (y >= 1) and (y <= 8) then
    begin
      ejimai [ck, 0] := x;
      ejimai [ck, 1] := y;
    end
    else begin
      ejimai [ck, 0] := -1;
      ejimai [ck, 1] := -1;
    end;
  end;

  for ck := 0 to 7 do
  begin
    x := jx + ejimas [ck, 0];
    y := jy + ejimas [ck, 1];
    for ck1 := 0 to 7 do
    if (ejimai [ck1, 0] = x) and (ejimai [ck1, 1] = y) then
    begin
      ejimai [ck1, 0] := -1;
      ejimai [ck1, 1] := -1;
    end
  end;

  yra := false;
  assign (f, 'zirg.rez');
  rewrite (f);
  for ck := 0 to 7 do
  begin
    if ejimai [ck, 0] <> -1 then
    begin
      c := chr (96 + ejimai [ck, 0]);
      writeln (f, c, ejimai [ck, 1]);
      yra := true;
    end;
  end;
  if not yra then writeln (f, 'EJIMU NERA');
  close (f);
end.