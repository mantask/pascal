program didele_aibe;
  {gaunasi [0 .. 256256] dydzio aibe}
  type Taibe = array [0 .. 1001] of set of 0 .. 255;
  var aibe : Taibe;
      ck : word;

procedure iterpti (sk : longint; var Aibe : Taibe);
  var ind, elem : integer;
begin
  ind := sk div 256;
  elem := sk mod 256;
  aibe [ind] := aibe [ind] + [elem];
end;

procedure spausdinti (const Aibe : Taibe);
  var ck : longint;
      ind, elem : integer;
begin
  for ck := 0 to 200000 do
  begin
    ind := ck div 256;
    elem := ck mod 256;
    if elem in aibe [ind] then writeln (ck);
  end
end;

begin
  for ck := 0 to 1001 do
  aibe [ck] := [];
  writeln;
  iterpti (1056, aibe);
  iterpti (200000, aibe);
  spausdinti (aibe);
end.
