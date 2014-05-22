program didelis_masyvas;
  {gaunasi 715x715 boolean masyvas, cia jau atrodo riba}
  type Tmas = array [1 .. 715, 0 .. 4] of set of 0 .. 142;
  var mas : Tmas;

procedure valyk (mas : Tmas);
  var ck, ck1 : word;
begin
  for ck := 1 to 715 do
  for ck1 := 0 to 4 do
  mas [ck, ck1] := [];
end;

{jei elementas masyve - jis atitinka true reiksme ir atv}
function tiesa (x, Y : integer) : boolean;
  var ind, elem : integer;
begin
  ind := y div 143;
  elem := y mod 143;
  if ind = 5 then ind := 0;
  if elem in mas [x, ind] then tiesa := true
                          else tiesa := false
end;

procedure itrauk (x, Y : integer; var mas : Tmas);
  var ind, elem : integer;
begin
  ind := y div 143;
  elem := y mod 143;
  if ind = 5 then ind := 0;
  mas [x, ind] := mas [x, ind] + [elem];
end;

procedure istrauk (x, Y : integer; var mas : Tmas);
  var ind, elem : integer;
begin
  ind := y div 143;
  elem := y mod 143;
  if ind = 5 then ind := 0;
  mas [x, ind] := mas [x, ind] - [elem];
end;

begin
   valyk (mas);

 {tarkim reikia suzymeti matricos MAS taskus (1,1),(715,1),(1,715),(715,715)}
  itrauk (  1,   1, mas);
  itrauk (715, 715, mas);
  itrauk (  1, 715, mas);
  itrauk (715,   1, mas);

  if tiesa (715, 715) then writeln ('tiesa') else writeln ('netiesa');
  if tiesa (  1,   1) then writeln ('tiesa') else writeln ('netiesa');
  if tiesa (715,   1) then writeln ('tiesa') else writeln ('netiesa');
  if tiesa (  1, 715) then writeln ('tiesa') else writeln ('netiesa');

  istrauk (715, 715, mas);
  istrauk (  1, 715, mas);
  istrauk (715,   1, mas);
  istrauk (  1,   1, mas);

  if tiesa (715, 715) then writeln ('tiesa') else writeln ('netiesa');
  if tiesa (  1,   1) then writeln ('tiesa') else writeln ('netiesa');
  if tiesa (715,   1) then writeln ('tiesa') else writeln ('netiesa');
  if tiesa (  1, 715) then writeln ('tiesa') else writeln ('netiesa');

  writeln;
end.