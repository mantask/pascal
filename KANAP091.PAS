{ MK 2001                    }
{ Mantas Kanaporis           }
{ Vilniaus Ïemynos gimnazija }
{ -------------------------- }
{ IX skyrius                 }
{ 1 uØdavinys                }

program Kanap091;
{$DEFINE II}

Const
  n = 10;

Type
  Tmas = array [1 .. n] of integer;

Const
  mas : Tmas = (2, 2, 5, 5, 5, 5, 7, 7, 7, 7);

{$IFDEF I}
function a (mas : Tmas) : integer;
var
  s, k, kmax, j : integer;
begin
  s := mas [1];
  k := 1;
  kmax := 1;
  for j := 2 to n do
  if mas [j] = mas [j - 1] then
  begin
    inc (k);
    if k > kmax then
    begin
      s := mas [j];
      kmax := k
    end
  end
  else k := 1;
  a := s
end;
{$ENDIF}

{$IFDEF II}
function a (mas : Tmas) : integer;
var
  s, k, j : Integer;
begin
  s := mas [1];
  K := 1;
  for j := 2 to n do
  if mas [j] = mas [j - k] then
  begin
    s := mas [j];
    inc (K)
  end;
  a := s
end;
{$ENDIF}

{$IFDEF III}
function a (mas : Tmas) : Integer;
var
  s, k, j : integer;
begin
  s := mas [1];
  k := 1;
  j := 1;
  while j + k <= n do
  if mas [j] = mas [j + k] then
  begin
    a := mas [j];
    inc (k)
  end
  else J := j + k
end;
{$ENDIF}

begin
  writeln (a (mas))
end.