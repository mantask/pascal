program shachmatai;

const
  n = 8;
  cx : array [1 .. 8] of integer =
       (2, 1, -1, -2, -2, -1, 1, 2);
  cy : array [1 .. 8] of integer =
       (1, 2, 2, 1, -1, -2, -2, -1);

type
  koord = 1 .. n;
  lenta = array [koord, koord] of integer;

var
  len : lenta;

procedure eiti (i : integer;
                x, y : koord;
                var len : lenta;
                var viskas : boolean);
const
  nn = 64;
var
  k : 0 .. 8;
  u, v : integer;
begin { eiti }
  k := 0;
  repeat
    k := k + 1;
    u := x + cx [k];
    v := y + cy [k];
    if (u >= 1) and (u <= n) and (v >= 1) and (v <= n) then
    if len [u, v] = 0 then
    begin
      len [u, v] := i;
      if i < nn then
      begin
        eiti (i + 1, u, v, len, viskas);
        if not viskas then len [u, v] := 0
      end
      else viskas := true
    end
  until viskas or (k = n)
end;  { eiti }

{procedure zirgas (var len : lenta);}
function zirgas (var len : lenta) : boolean;
var
  i, j : koord;
  viskas : boolean;
begin { zirgas }
  viskas := false;
  for i := 1 to n do
  for j := 1 to n do
  len [i, j] := 0;
  len [1, 1] := 1;
  eiti (2, 1, 1, len, viskas);

  zirgas := viskas
end;  { zirgas }

procedure rasymas (len : lenta);
var
  ckx, cky : integer;
begin
  for cky := 1 to n do
  begin
    for ckx := 1 to n do
    write (len [ckx, cky] : 3);
    writeln
  end
end;

begin
  if zirgas (len) then rasymas (len)
                  else writeln ('NE VISKAS')
end.