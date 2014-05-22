program Mandelbroto_kreive;
{$DEFINE al}
const
  maxsp : byte = 255;
  minx = -2   {  -0.2100050};
  maxx = 1.25  { -0.2100055};
  miny = -1.25 { -0.8200050};
  maxy = 1.25  { -0.8200055};

var
  ckx, cky : word;
  sp : byte;
  pgx, pgy : real;

procedure putpixel (x, y : word; sp : byte);
begin
  mem [$a000 : 320 * y + x] := sp
end;

procedure setpal;
var
  ck : byte;
begin
  for ck := 1 to maxsp do
  begin
    port [$3C8] := ck;
    port [$3C9] := 0;
    port [$3C9] := (maxsp - ck) div 12;
    port [$3C9] := (maxsp - ck) div 4
  end
end;

function mand (x, y : real) : byte;
var
  ck : byte;
  sa, a, b,
  z : real;
begin
  ck := 0; a := 0; b := 0;
  repeat
    sa := a;
    a := sqr (a) - sqr (b) + x;
    b := 2 * sa * b + y;
    z := sqr (a) + sqr (b);
    inc (ck)
  until (z > 4) or (ck >= maxsp);
  mand := ck
end;

begin
  asm
    mov  ax, 13h
    int  10h
  end;

  setpal;
{$IFNDEF pal}
  pgx := (maxx - minx) / 320;
  pgy := (maxy - miny) / 200;
  for ckY := 0 to 199 do
  for ckx := 0 to 319 do
  putpixel (ckx, cky, mand (minx + pgx * ckx, miny + pgy * cky));
{$ELSE}
  for ckx := 0 to 255 do for cky := 0 to 20 do putpixel (ckx, cky, ckx);
{$ENDIF}

  repeat until port [$60] = 1;
  asm
    mov  ax, 3h
    int  10h
  end
end.