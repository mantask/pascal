program pirm;

var
  mas : array [1 .. 10000] of longint;
  ck, ck1, viso : longint;
  ok : boolean;

begin
  mas [1] := 2;
  viso := 1;
  for ck := 3 to 100000 do
  begin
    ok := true;
    for ck1 := 1 to viso do
    if ck mod mas [ck1] = 0 then
    begin
      ok := false;
      break
    end;
    if ok then
    begin
      inc (viso);
      mas [viso] := ck
    end
  end
end.