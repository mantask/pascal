type
  Tjau = array [2 .. 9] of boolean;

var
  jau : Tjau;
  sk1, sk2 : longint;

procedure lisk (gylis, sk1, sk2 : longint; var jau : Tjau);
var
  ck : INteger;
begin
  if gylis <= 4 then
  begin
    for ck := 2 to 9 do
    if not jau [ck] then
    begin
      jau [ck] := true;
      lisk (gylis + 1, sk1 * 10 + ck, sk2, jau);
      jau [ck] := false
    end
  end
  else
  if gylis <= 8 then
  begin
    for ck := 2 to 9 do
    if not jau [ck] then
    begin
      jau [ck] := true;
      lisk (gylis + 1, sk1, sk2 * 10 + ck, jau);
      jau [ck] := false
    end
  end
  else if sk1 * 2 = sk2 then writeln (sk1, ' * 2 = ', sk2, '    ', sk1 * 3)
end;

begin
  writeln ('-----------------------------------');
  fillchar (jau, sizeof (jau), 0);
  lisk (1, 0, 1, jau)
end.