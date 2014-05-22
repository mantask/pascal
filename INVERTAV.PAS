{ panasiai i drakona formuoja skaiciu seka is 0 arba 1, kai pirmas nulis,
  antras plius pirmas invertuotas ir tt.
  pvz.: 0110100110010110 }
program invertavimas;

var
  pg,
  sk, ck : longint;
  n : integer;

function laipsn (sk : longint) : longint;
var
  pg : longint;
  n : integer;
begin
  n := 0;
  pg := 1;
  while (sk div pg) > 1 do
  begin
    pg := pg shl 1;
    inc (n);
  end;
  if sk mod pg = 0 then dec (n);
  laipsn := n;
end;

begin
  sk := 100;
  for ck := 1 to sk do
  begin
    n := 0;
    pg := ck;
    while pg > 1 do
    begin
      pg := pg - (1 shl laipsn (pg));
      inc (n);
    end;
    write (n mod 2);
  end;
  writeln;
end.

