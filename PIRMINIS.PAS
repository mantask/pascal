{MK 2001}

{ Jei pirminis, tai paraso daliklius, jie ne - nieko neraso }
program pirminis;

var
  sk, ck : longint;

begin
  readln (sk);
  writeln ('Skaiciaus ', sk, ' dalikliai:');
  for ck := 2 to sk - 1 do
  if sk mod ck = 0 then writeln (ck);
  writeln ('--------');
end.