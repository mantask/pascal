{ MK 2001                    }
{ Mantas Kanaporis           }
{ Vilniaus œemynos gimnazija }
{ -------------------------- }
{ VIII skyrius               }
{ 5 uÿdavinys                }

program JPM_8_5;

var
  fdat, frez : text;     { pagalbiniai fail÷ kintamieji }
  pg : char;             { pagalbinis simbolis, reikalingas sukeitimui }
  eil : string;          { nagrin”jama eilut” }
  ck : byte;             { pagalbinis ciklo kintamasis }

begin
  { paruo’iami failai }
  assign (fdat, 'duom.txt');
  assign (frez, 'rez.txt');
  reset (fdat);
  rewrite (frez);

  while not eof (fdat) do
  begin
    readln (fdat, eil);                  { nuskaitom eilut“ }
    for ck := 1 to length (eil) div 2 do { sukei—iam simbolius }
    begin
      pg := eil [2 * ck - 1];
      eil [2 * ck - 1] := eil [2 * ck];
      eil [2 * ck] := pg
    end;
    writeln (frez, eil)                  { ira’om uÿ’ifruot– eilut“ }
  end;

  { ‘rasomi ir uÿdaromi failai }
  close (fdat);
  close (frez)
end.