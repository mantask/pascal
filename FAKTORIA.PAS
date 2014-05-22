program faktorialas;

var
  n : integer;

function fakt (n : integer) : integer;
begin
  if n = 1 then fakt := 1
  else fakt := n * fakt (n - 1)
end;

begin
  n := 3;
  writeln (fakt (n));
end.