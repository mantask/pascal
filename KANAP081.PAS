{ MK 2001                    }
{ Mantas Kanaporis           }
{ Vilniaus œemynos gimnazija }
{ -------------------------- }
{ VIII skyrius               }
{ 1 uÿdavinys                }

program JPM_8_1;

const
  n = 8;

var
  s : array [1 .. n] of char;
  j, k : integer;
  c : char;

begin
  s [1] := 'R';
  s [2] := 'a';
  s [3] := 'm';
  s [4] := 'u';
  s [5] := 'n';
  s [6] := 'e';
  s [7] := ' ';
  s [8] := ' ';


  for k := 1 to n div 2 do
  begin
    c := s [k];
    s [k] := s [n - k + 1];
    s [n - k + 1] := c
  end;

  for k := 1 to n do
  write (s [k]);
  writeln
end.