program taskas;
{ $ DEFINE tarpas}

uses
  crt;

const
  ms = 150000;            { delay                          }
  Q = 15;             { vienas taskas : metrai = 1 : Q }
  alfa : real = 85;   { kampas                         }
  s0 : integer = 0;   { pradine sx koordinate          }
  v0 : word = 63;     { pradinis greitis               }
  g = 10;             { laisvojo kritimo pagreitis     }

var
  x, y,
  xx0, yy0,
  xx1, yy1,
  xx2, yy2,
  xx3, yy3,
  xx, yy : integer;
  ckt : word;

procedure putpixel (x, y : word; sp : byte);
begin
  mem [$A000 : 320 * y + x] := sp
end;

function sy (t : word) : integer;
var
  pgt : real;
begin
  pgt := t / Q;
  sy := round (sin (alfa) * v0 * pgt - g * sqr (pgt) / 2)
end;

function sx (t : word) : integer;
var
  pgt : real;
begin
  pgt := t / Q;
  sx := round (s0 + cos (alfa) * v0 * pgt)
end;

procedure DELAY (ms : Word); Assembler;
asm
  mov ax, 1000;
  mul ms;
  mov cx, dx;
  mov dx, ax;
  mov ah, $86;
  Int $15;
end;

begin
  asm
    mov  ax, 13h
    int  10h
  end;

  port [$3C8] := 1;
  port [$3C9] := 63;
  port [$3C9] := 63;
  port [$3C9] := 0;

  port [$3C8] := 2;
  port [$3C9] := 53;
  port [$3C9] := 53;
  port [$3C9] := 0;

  port [$3C8] := 3;
  port [$3C9] := 43;
  port [$3C9] := 43;
  port [$3C9] := 0;

  port [$3C8] := 4;
  port [$3C9] := 33;
  port [$3C9] := 33;
  port [$3C9] := 0;

{$IFDEF tarpas}
  for xx := 5 to 204 do
  begin
    port [$3C8] := xx;
    port [$3C9] := xx div 2;
    port [$3C9] := xx div 2;
    port [$3C9] := 0;
  end;

  repeat until port [$60] = 57;

  xx := 0;
  yy := 0;
  v0 := 0;
  while (port [$60] <> 185) or (yy < 198) do
  begin
    inc (v0, 2);
    inc (yy);
    for xx := 310 to 319 do
    putpixel (xx, yy, yy + 5);
    delay (1000)
  end;
{$ENDIF}

  alfa := (alfa * pi) / 180;
  ckT := 0;
  xx0 := 0; xx1 := 0; xx2 := 0; xx3 := 0;
  yy0 := 0; yy1 := 0; yy2 := 0; yy3 := 0;
  sound (100);
  delay (ms);
  nosound;

  while (v0 > 1) and (port [$60] <> 1) do
  begin
    putpixel (xx3, yy3, 0);

    inc (ckT);
    x := sx (ckt);
    y := sy (ckt);
    if x > 319 then
    begin
      if x div 320 mod 2 = 0 then xx := x mod 320
                             else xx := 319 - x mod 320
    end
    else xx := x;
    if Y >= 200 then
    begin
{      ckT := ckt + round (2 * (v0 * sin (alfa) / g + ckt));
      s0 := s0 - round (2 * (v0 * sin (alfa) / g + ckt) * v0 * cos (alfa));}
      yy := 0
    end
    else yy := 200 - y;
    if y < 0 then
    begin
      v0 := round (v0 / 1.5);
      s0 := x;
      ckt := 0;
      sound (100);
      delay (ms);
      nosound;
      continue
    end;
    xx3 := xx2; xx2 := xx1; xx1 := xx0; xx0 := xx;
    yy3 := yy2; yy2 := yy1; yy1 := yy0; yy0 := yy;
    putpixel (xx3, yy3, 4);
    putpixel (xx2, yy2, 3);
    putpixel (xx1, yy1, 2);
    putpixel (xx, yy, 1);
    delay (ms);
  end;

  asm
    mov  ax, 3h
    int  10h
  end
end.