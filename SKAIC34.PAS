program skaic34;

var
  mas : Array [1 .. 20000, 1 .. 3] of byte;
  sk1, sk2, sk3 : byte;
  viso : integer;
  f : text;

function nebuvo (sk1, sk2, sk3 : integer; viso : integer) : boolean;
var
  ok : boolean;
  ck : Integer;
begin
  for ck := 1 to viso do
  begin
    if (sk1=mas [ck,1])and(sk2=mas [ck,2])and(sk3=mas [ck,3])then ok := false;
    if (sk1=mas [ck,1])and(sk3=mas [ck,2])and(sk2=mas [ck,3])then ok := false;
    if (sk2=mas [ck,1])and(sk1=mas [ck,2])and(sk3=mas [ck,3])then ok := false;
    if (sk2=mas [ck,1])and(sk3=mas [ck,2])and(sk1=mas [ck,3])then ok := false;
    if (sk3=mas [ck,1])and(sk1=mas [ck,2])and(sk2=mas [ck,3])then ok := false;
    if (sk3=mas [ck,1])and(sk2=mas [ck,2])and(sk1=mas [ck,3])then ok := false;
    if not OK then break
  end;
  nebuvo := ok
end;

begin
  assign (f, 'skaic34.txt');
  rewrite (f);
  for sk1 := 1 to 34 do
  for sk2 := 1 to 34 do
  for sk3 := 1 to 34 do
  if (sk1 <> sk2)
    and (sk2 <> sk3)
    and (sk1 <> sk3)
    and ((sk1 + sk2 + sk3) mod 3 = 0)
    and nebuvo (sk1, sk2, sk3, viso) then
  begin
    inc (viso);
    mas [viso, 1] := sk1;
    mas [viso, 2] := sk2;
    mas [viso, 3] := sk3;
    writeln (f, sk1, ' ', sk2, ' ', sk3)
  end;
  writeln (viso);
  close (f)
end.