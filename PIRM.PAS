program as;

var
  pask, viso, sk, ck : longint;
  mas : array [1 .. 10000] of longint;
  ok : boolean;

function pirm (sk, nuo : longint) : boolean;
var
  ck : longint;
begin
  for ck := nuo to trunc (sqrt (sk)) do
  if sk mod ck = 0 then
  begin
    pirm := false;
    exit
  end;
  pirm := true
end;

begin
  pask := 1;
  mas [pask] := 2;
  for sk := 2 to 1000000 do
  begin
    ok := true;
    for ck := 1 to pask do
    if sk mod mas [ck] = 0 then
    begin
      ok := false;
      break
    end;
    if ok and pirm (sk, mas [pask]) then
    begin
      inc (pask);
      mas [pask] := sk;
      writeln (sk)
    end;
    if pask = 10000 then break
  end
end.