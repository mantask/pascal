{ Formuoja seka tokia tvarka: }
{ * **  ***   ****    *... }
program laipnis;

var
  ck,
  n, pg, sk : word;

begin
  readln (sk);
  pg := 0;
  n := 0;
  while pg < sk do
  begin
    pg := n * n + n;
    inc (n)
  end;
  if (pg - sk + 1) > (n - 1) then writeln ('Zvaigzde')
                             else writeln ('Tarpas')
end.