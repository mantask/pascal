program automat;

Const
  myg : array [1 .. 10, 1 .. 10] of integer =
  ((0, 0, 0, 1, 1, 0, 0, 1, 1, 1),
   (0, 0, 0, 0, 0, 0, 0, 0, 1, 1),
   (0, 0, 0, 0, 0, 0, 0, 1, 0, 1),
   (0, 0, 1, 0, 1, 0, 0, 0, 1, 1),
   (0, 0, 0, 0, 0, 1, 0, 1, 1, 0),
   (0, 1, 1, 1, 1, 0, 0, 1, 0, 1),
   (1, 1, 0, 1, 0, 1, 0, 1, 1, 1),
   (0, 0, 0, 0, 0, 0, 0, 0, 0, 1),
   (0, 0, 0, 0, 0, 0, 1, 1, 0, 1),
   (0, 0, 0, 0, 1, 0, 1, 0, 1, 1));


Type
  Tlent = array [1 .. 10] of integer;
  Taib = set of 1 .. 10;

var
  spausta, ats, lent : Tlent;
  kart : integer;

procedure nuskaitymas (var lent : tlent);
var
  f : text;
  ck : integer;
begin
  assign (f, 'automat.dat');
  reset (f);
  for ck := 1 to 10 do
  read (f, lent [ck]);
  close (f)
end;

procedure apdirbimas (var lenta : Tlent);
var
  min, max,
  ck : integer;
  yra : boolean;
begin
  max := lenta [1];
  min := lenta [1];
  if lenta [1] = 0 then yra := true
                   else yra := false;
  for ck := 2 to 10 do
  if lenta [ck] = 0 then yra := true
  else
  begin
    if lenta [ck] > max then max := lenta [ck];
    if lenta [ck] < min then min := lenta [ck]
  end;
  if yra and (10 > min + max)
  then for ck := 1 to 10 do
  lenta [ck] := (10 - lenta [ck]) mod 10
  else for ck := 1 to 10 do
  lenta [ck] := max - lenta [ck];
end;

procedure lisk (lent : Tlent; ne : Taib; spausta : Tlent;
                var kart : integer; var ats : Tlent);
var
  ck1, ck2 : byte;
  viso : integer;
begin
  viso := 0;
  for ck1 := 1 to 10 do
  viso := viso + lent [ck1];
  if viso = 0 then
  begin
    for ck1 := 1 to 10 do
    viso := viso + spausta [ck1];
    if (kart = 0) or (viso < kart) then
    begin
      ats := spausta;
      kart := viso
    end;
    exit
  end;
  for ck1 := 1 to 10 do
  if not (ck1 in ne) then
  for ck2 := 1 to 10 do
  if (lent [ck2] = 0) and (myg [ck1, ck2] = 1) then
  begin
    ne := ne + [ck1];
    break
  end;

  if ne <> [1 .. 10] then
  for ck1 := 1 to 10 do
  if not (ck1 in ne) then
  begin
    for ck2 := 1 to 10 do
    lent [ck2] := lent [ck2] - myg [ck1, ck2];
    inc (spausta [ck1]);
    lisk (lent, ne, spausta, kart, ats);
    dec (spausta [ck1]);
    for ck2 := 1 to 10 do
    lent [ck2] := lent [ck2] + myg [ck1, ck2]
  end
end;

procedure rasyk (viso : integer; ats : Tlent);
var
  ck : integer;
  f : text;
begin
  assign (f, 'automat.rez');
  rewrite (f);
  if viso <> 0 then
  begin
    writeln (f, 'GALIMA');
    writeln (f, viso);
    for ck := 1 to 10 do
    writeln (f, ats [ck]);
  end
  else writeln (f, 'NEGALIMA');
  close (f)
end;

procedure valyk (var spausta : Tlent);
var
  ck : integer;
begin
  for ck1 := 1 to 10 do
  viso := viso + spausta [ck1];
  if viso < kart then
  begin
    ats := spausta;
    kart := viso
  end
end;
  for ck := 1 to 10 do
  spausta [ck] := 0
end;

begin
  nuskaitymas (lent);
  apdirbimas (lent);
  lisk (lent, [], spausta, kart, ats);
  rasyk (kart, ats)
end.
