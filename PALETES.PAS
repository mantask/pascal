program spalvos;

const
  cx = 100;
  cy = 100;

var
  r1, g1, b1,
  R, G, B,
  ck : byte;
  ckx, cky : word;
  pgx, pgy : longint;

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
  asm
    mov ax, 13h
    int 10h
  end;

  { setpal }
  for ck := 0 to 63 do
  begin
    port [$3C8] := ck;
    port [$3C9] := 0;
    port [$3C9] := 0;
    port [$3C9] := ck;
  end;
  for ck := 64 to 127 do
  begin
    port [$3C8] := ck;
    port [$3C9] := 0;
    port [$3C9] := 0;
    port [$3C9] := 127 - ck
  end;
  for ck := 128 to 191 do
  begin
    port [$3C8] := ck;
    port [$3C9] := ck - 128;
    port [$3C9] := 0;
    port [$3C9] := 0
  end;
  for ck := 192 to 255 do
  begin
    port [$3C8] := ck;
    port [$3C9] := 255 - ck;
    port [$3C9] := 0;
    port [$3C9] := 0
  end;



  for cky := 0 to 199 do
  for ckx := 0 to 319 do
  begin
    if ckx > 159 then pgx := ckx - 159
                 else pgx := 159 - ckx;
    if cky > 100 then pgy := cky - 100
                 else pgy := 100 - cky;
    mem [$A000 : 320 * cky + ckx] :=
    round (sqrt (sqr (pgx) + sqr (pgy))) mod 256;
  end;

  repeat
    port [$3C7] := 0;
    r1 := port [$3C9];
    g1 := port [$3C9];
    b1 := port [$3C9];
    for ck := 0 to 254 do
    begin
      port [$3C7] := ck + 1;
      r := port [$3C9];
      g := port [$3C9];
      b := port [$3C9];
      port [$3C8] := ck;
      port [$3C9] := R;
      port [$3C9] := G;
      port [$3C9] := B;
    end;
      port [$3C8] := 255;
      port [$3C9] := R1;
      port [$3C9] := G1;
      port [$3C9] := B1;
    delay (30)
  until port [$60] = 1;

  asm
    mov ax, 3h
    int 10h
  end;
end.