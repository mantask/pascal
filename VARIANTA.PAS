{ MK 2002 }
{ DUOTA: skaiciu masyvas, masyvo ilgis }
{ RASTI: visus galimus skaiciu derinius }

program variantai;

type
  Tmas = array [1 .. 10] of -1 .. 9;

var
 m, mas : Tmas;
 ilg, ck : byte;
 ok : boolean;

procedure variant (gyl, ilg : byte; m : Tmas; var OKAY : boolean);
var
  ck : byte;
  sk : real;

  function nebuvo (sk : byte) : boolean;
  var
    ok : boolean;
    ck : byte;
  begin
    ok := true;
    for ck := 1 to gyl do
    if sk = m [ck] then ok := false;
    nebuvo := ok
  end;

begin
  if gyl = ilg + 1 then
  begin
    sk := 0;
    for ck := 1 to ilg do
    sk := sk * 10 + m [ck];
    if frac (sk / ilg) = 0 then OKAY := true
  end
  else
  begin
    for ck := 1 to ilg do
    if nebuvo (mas [ck]) then
    begin
      m [gyl] := mas [ck];
      variant (gyl + 1, ilg, m, okay);
      m [gyl] := -1;
    end
  end
end;

begin
  mas [1] := 4;
  mas [2] := 4;
  mas [3] := 4;
  mas [4] := 4;
  ilg := 4;
  for ck := 1 to ilg do
  m [ck] := -1;
  ok := false;
  variant (1, ilg, m, ok);
  writeln (ok);
end.
