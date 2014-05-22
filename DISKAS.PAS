program diskas;

var
  mas : array [1 .. 6, 1 .. 100] of boolean;
  pg,
  ckx, cky : integer;
  b1, b2 : boolean;
  f : text;

begin
  mas [1, 1] := false;
  mas [2, 1] := true;
  mas [3, 1] := false;
  mas [4, 1] := false;
  mas [5, 1] := false;
  mas [6, 1] := true;
  for cky := 2 to 100 do
  for ckx := 1 to 6 do
  begin
    pg := ckx mod 6 + 1;
    if cky = pg then b1 := true
    else if cky > pg then b1 := not mas [pg, cky - pg]
                     else b1 := false;
    pg := (ckx + 4) mod 6 + 1;
    if cky = pg then b2 := true
    else if cky > pg then b2 := not mas [pg, cky - pg]
                     else b2 := false;
    mas [ckx, cky] := b1 or b2
  end;
  assign (f, 'diskas.rez');
  rewrite (f);
  for cky := 1 to 100 do
  begin
    write (f, cky :3, ' ');
    for ckx := 1 to 6 do
    if mas [ckx, cky] then write (f, '+')
                      else write (f, '-');
    writeln (f)
  end;
  close (F)
end.