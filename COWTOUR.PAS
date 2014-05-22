uses graph;

type
  Tkoord = array [1 .. 150, 1 .. 2] of integer;
  Tg = array [1 .. 150, 1 .. 150] of boolean;
  Tkuris = array [1 .. 150] of integer;
  Tats = array [1 .. 150] of real;
  Tis = array [1 .. 150] of integer;

const
  v1 = 1;
  v2 = 105;

var
  koord : Tkoord;
  g : Tg;
  gd, gm, ckx, cky, viso : Integer;
  kuris : Tkuris;
  is : Tis;

function atst (v1, v2 : integer) : real;
var
  pg, pg1, pg2 : real;
begin
  pg2 := koord [v2, 2] - koord [v1, 2];
  pg1 := koord [v2, 1] - koord [v1, 1];
  pg := pg1 * pg1 + pg2 * pg2;
  atst := sqrt (pg)
end;

procedure nuskaitymas (var viso : Integer; var koord : Tkoord; var g : tg; var kuris : Tkuris);
var
  f : Text;
  lyg, gal, uod, ck, ck1, ckx, cky : Integer;
  eil : Tkuris;
  pg : Char;
begin
  assign (f, 'cowtour.in');
  reset (f);
  readln (f, viso);
  for ck := 1 to viso do
  begin
    readln (f, koord [ck, 1], koord [ck, 2]);
    koord [ck, 1] := koord [ck, 1] div 30;
    koord [ck, 2] := koord [ck, 2] div 30
  end;
  for cky := 1 to viso do
  begin
    for ckx := 1 to viso do
    begin
      read (f, pg);
      g [ckx, cky] := pg = '1';
      g [cky, ckx] := pg = '1'
    end;
   readln (f)
  end;
  close (f);

  lyg := 0;
  for ck1 := 1 to viso do
  if kuris [ck1] = 0 then
  begin
    inc (lyg);
    kuris [ck1] := lyg;
    eil [1] := ck1;
    gal := 1;
    uod := 2;
    while gal < uod do
    begin
      for ck := 1 to viso do
      if g [eil [gal], ck] and (kuris [ck] = 0) then
      begin
        kuris [ck] := lyg;
        eil [uod] := ck;
        inc (uod)
      end;
      inc (gal)
    end
  end
end;

procedure ish (v : Integer; var is : Tis);
var
  ats : array [1 .. 150] of real;
  min, ck : Integer;
  jau : array [1 .. 150] of boolean;
begin
  fillchar (is, sizeof (is), 0);
  for ck := 1 to viso do
  ats [ck] := -1;
  fillchar (jau, sizeof (jau), 0);
  ats [v] := 0;

  while true do
  begin
    min := 0;
    for ck := 1 to viso do
    if not jau [ck] and (ats [ck] <> -1) and ((min = 0) or (ats [ck] < ats [min]))
    then min := ck;
    if min = 0 then break;

    for ck := 1 to viso do
    if g [min, ck] and ((ats [ck] = -1) or (ats [ck] > ats [min] + atst (min, ck))) then
    begin
      ats [ck] := ats [min] + atst (min, ck);
      is [ck] := min
    end;

    jau [min] := true
  end
end;


begin
  nuskaitymas (viso, koord, g, kuris);
  ish (v1, is);
  initgraph (gd, gm, '');

  for ckx := 1 to viso do
  for cky := ckx + 1 to viso do
  if g [ckx, cky] then
  begin
    setcolor (kuris [ckx]);
    line (koord [ckx, 1], koord [ckx, 2], koord [cky, 1], koord [cky, 2]);
  end;

  setcolor (14);
  for ckx := 1 to 150 do
  if is [ckx] <> 0
  then line (koord [ckx, 1], koord [ckx, 2], koord [is [ckx], 1], koord [is [ckx], 2]);

  for ckx := 1 to viso do
  putpixel (koord [ckx, 1], koord [ckx, 2], kuris [ckx] + 10);

  setcolor (15);
  circle (koord [v1, 1], koord [v1, 2], 3);
  circle (koord [v1, 1], koord [v1, 2], 5);
  circle (koord [v1, 1], koord [v1, 2], 8);
  circle (koord [v2, 1], koord [v2, 2], 3);
  circle (koord [v2, 1], koord [v2, 2], 5);
  circle (koord [v2, 1], koord [v2, 2], 8);
  line (koord [v1, 1], koord [v1, 2], koord [v2, 1], koord [v2, 2]);
  writeln (atst (v1, v2):0:6);
  asm
    mov  ax, 1h
    int  33h
  end;
  repeat until port [$60] =1;
  asm
    mov  ax, 2h
    int  33h
  end;
  closegraph
end.