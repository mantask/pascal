{ MK 2001 }
{ ar visi nı + n + 17 pirminiai }
program indukcija;
var
  ck : integer;
  sk : integer;

function pirminis (sk : integer) : boolean;
var
  ck : integer;
  pg : boolean;
begin
  pg := false;
  for ck := 2 to sk div 2 do
  if sk mod ck = 0 then
  begin
    pg := true;
    exit
  end;
  pirminis := pg;
end;

begin
  for ck := 1 to 16 do
  begin
    sk := sqr (ck) + ck + 17;
    if pirminis (sk) then writeln ('+', sk :3, ' - pirminis')
                     else writeln ('-', sk :3, ' - nepirminis');
  end;
  readln
end.
