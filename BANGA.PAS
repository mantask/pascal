{ MK 2001 }
{ bangos algoritmo demostracija }
program banga;

type
  Tlab = array [1 .. 100, 1 .. 100] of shortint;
  Tkelias = array [1 .. 10000, 1 .. 2] of shortint;

var
  f : text;
  c : char;
  x1, y1,
  x2, y2,
  n, { labirinto dydis }
  z,
  ck,
  ckx, cky : integer;
  lab : Tlab;
  kelias : Tkelias;
  ats : array [1 .. 100, 1 .. 100] of 0 .. 1;

procedure zenk (zings : integer; var lab : Tlab; x, y : shortint);
begin
  if (lab [x, y] = -1) or ((lab [x, y] < zings) and not (lab [x, y] = 0)) then exit
  else begin
    lab [x, y] := zings;
    if x + 1 <= n then zenk (zings + 1, lab, x + 1, y);
    if y + 1 <= n then zenk (zings + 1, lab, x, y + 1);
    if x - 1 > 0 then zenk (zings + 1, lab, x - 1, y);
    if y - 1 > 0 then zenk (zings + 1, lab, x, y - 1);
  end;
end;

procedure atgal (zings : integer; const lab : Tlab; x, y : integer; var kelias : Tkelias);
begin
  if (lab [x, y] >= zings) and (z <> zings) or (lab [x, y] = -1) or (zings = 0) then exit
  else begin
    kelias [zings, 1] := x;
    kelias [zings, 2] := y;
    if x + 1 <= n then atgal (zings - 1, lab, x + 1, y, kelias);
    if y + 1 <= n then atgal (zings - 1, lab, x, y + 1, kelias);
    if x - 1 > 0 then atgal (zings - 1, lab, x - 1, y, kelias);
    if y - 1 > 0 then atgal (zings - 1, lab, x, y - 1, kelias);
  end;
end;

begin
  assign (f, 'bang.dat');
  reset (f);
  readln (f, n);
  readln (f, x1, y1);
  readln (f, x2, y2);
  for cky := 1 to n do
  begin
    for ckx := 1 to n do
    begin
      read (f, c);
      if c = '0' then lab [ckx, cky] := 0
                 else lab [ckx, cky] := -1
    end;
    readln (f);
  end;
  close (f);
  zenk (0, lab, x1, y1);

  z := lab [x2, y2];
  atgal (z + 1, lab, x2, y2, kelias);

  for ck := 2 to z + 1 do
  ats [kelias [ck, 1], kelias [ck, 2]] := 1;

  assign (f, 'bang.rez');
  rewrite (f);
  for cky := 1 to n do
  begin
    for ckx := 1 to n do
    write (f, ats [ckx, cky] :2);
    writeln (f);
  end;
  close (f);
end.