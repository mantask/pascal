program labirintas;

type
  Tmas = array [1 .. 10, 1 .. 10] of integer;

var
  mas : Tmas;

procedure lisk (x, y : Integer; var mas : Tmas);
begin
  if (y > 1) and (mas [x, y - 1] <> -1) and (mas[x, y] + 1 < mas [x, y - 1])
    then begin
           mas [x, y - 1] := mas [x, y] + 1;
           lisk (x, y - 1, mas)
         end;
  if (x < 10) and (mas [x + 1, y] <> -1) and (mas[x, y] + 1 < mas [x + 1, y])
    then begin
           mas [x + 1, y] := mas [x, y] + 1;
           lisk (x + 1, y, mas)
         end;
  if (y < 10) and (mas [x, y + 1] <> -1) and (mas[x, y] + 1 < mas [x, y + 1])
    then begin
           mas [x, y + 1] := mas [x, y] + 1;
           lisk (x, y + 1, mas)
         end;
  if (x > 1) and (mas [x - 1, y] <> -1) and (mas[x, y] + 1 < mas [x - 1, y])
    then begin
           mas [x - 1, y] := mas [x, y] + 1;
           lisk (x - 1, y, mas)
         end;

end;

procedure grizk (x, y : integer; var mas : Tmas);
begin
  if (x < 10) and (mas[x, y] - 1 = mas [x + 1, y]) then grizk (x + 1, y, mas)
    else if (y < 10) and (mas[x, y] - 1 = mas [x, y + 1]) then grizk (x, y + 1, mas)
    else if (x > 1) and (mas[x, y] - 1 = mas [x - 1, y]) then grizk (x - 1, y, mas)
    else if (y > 1) and (mas[x, y] - 1 = mas [x, y - 1]) then grizk (x, y - 1, mas)
  mas [x, y] := 0 {+}
end;

procedure rask (var ilg : integer; var mas : Tmas);
var
  pg, ck : Integer;
begin                        {Leidziam banga is pirmo stulpelio}
  for ck := 1 to 10 do
  if mas [1, ck] <> -1 then
  begin
    mas [1, ck] := 1;
    lisk (1, ck, mas)
  end;

  pg := -1;
  for ck := 1 to 10 do
  if (mas [10, ck] <> -1) and ((pg = -1) or (mas [10, ck] < mas [10, pg]))
  then pg := ck;
  if pg <> -1 then
  begin
    ilg := mas [10, pg];
    grizk (10, pg, mas)
  end
end;

begin
  nuskaitymas (mas);
end.