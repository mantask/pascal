Program kas2;

type
  Taib = set of 1 .. 20;

var
  ck : Integer;
  aib : Taib;

procedure lisk (sum : integer; var aib : Taib);
begin
  if sum = 105 then
  begin
    for ck := 1 to 20 do
    if not (ck in aib) then write (ck, ' ');
    writeln;
  end
  else
  for ck := 1 to 20 do
  if (ck in aib) and (sum + ck <= 105) then
  begin
    aib := aib - [ck];
    lisk (sum + ck, aib);
    aib := aib + [ck]
  end
end;

begin
  writeln ('--------------------------------------------');
  aib := [1 .. 20];
  lisk (0, aib)
end.