program parinktys;

var
  sk1, sk2, sk3, sk4 : 0 .. 9;
  aib : set of 0 .. 9;
  ck : byte;
  f : text;

{------------ZIUREK--------------}
procedure ziurek;
type
  Tmas4 = array [1 .. 4] of -1 .. 9;
  Tmas2 = array [1 .. 2] of -1 .. 9;
  Tm = array [1 .. 9] of byte;
var
  mas : Tmas4;
  mm : Tm;
  m : tmas2;
  ck : word;
  sk : integer;

  procedure tikrink (gyl : byte; m : Tmas2; var mm : tm);
  var
    suma : integer;
    ck : byte;
  begin
    if gyl > 2 then
    begin
      suma := m [1] * 10 + m [2] + sk;
      if (suma <= 2009) and (suma >= 2001) then
      writeln (f, m [1], m [2], ' + ', sk, ' = ', suma);
      inc (mm [suma - 2000])
    end
    else
    begin
      for ck := 1 to 4 do
      if mas [ck] <> m [1] then
      begin
        m [gyl] := mas [ck];
        tikrink (gyl + 1, m, mm);
        m [gyl] := -1;
      end
    end
  end;

begin
  for ck := 1 to 2 do
  m [ck] := -1;
  for ck := 1 to 9 do
  mm [ck] := 0;
  mas [1] := sk1;
  mas [2] := sk2;
  mas [3] := sk3;
  mas [4] := sk4;
  sk := 1000 * sk1 + 100 * sk2 + 10 * sk3 + sk4;
  tikrink (1, m, mm);
  for ck := 1 to 9 do
  write ('200', ck, ' - ', mm [ck], '  ');
end;
{-------------ZIUREK-------------}

begin
  assign (f, 'parink.txt');
  rewrite (F);
  for sk1 := 1 to 9 do
  begin
    aib := aib + [sk1];
    for sk2 := 0 to 9 do
    if not (sk2 in aib) then
    begin
      aib := aib + [sk2];
      for sk3 := 0 to 9 do
      if not (sk3 in aib) then
      begin
        aib := aib + [sk3];
        for sk4 := 0 to 9 do
        if not (sk4 in aib) then
        begin
          aib := aib + [sk4];
          ziurek;
          aib := aib - [sk4];
        end;
        aib := aib - [sk3];
      end;
      aib := aib - [sk2];
    end;
    aib := aib - [sk1];
  end;
  close (F)
end.