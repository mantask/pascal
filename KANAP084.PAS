{ MK 2001                    }
{ Mantas Kanaporis           }
{ Vilniaus œemynos gimnazija }
{ -------------------------- }
{ VIII skyrius               }
{ 4 uÿdavinys                }

program JPM_8_4;

type
  Teil = string [80];               { eilut”s tipas }

var
  fdat, frez : text;                { pagalbiniai fail÷ kintamieji }
  eil : Teil;                       { nagrin”jama eilut” }
  ck, ckpoz,                        { pagalbiniai ciklo kintamieji }
  sk : byte;                        { eilu—i÷ skaicius }
  kab : boolean;                    { ar pirmos kabut”s jau yra }

{ Proced◊ra i’valo tarpus (' ') prie’ nurodyt– simbol‘ }
procedure valPries (var poz : byte; var eil : Teil);
begin
  while (poz > 1) and (eil [poz - 1] = ' ') do
  begin
    delete (eil, poz - 1, 1);
    dec (poz)
  end
end;

{ Proced◊ra i’valo tarpus (' ') po nurodyto simbolio }
procedure valPo (poz : byte; var eil : Teil);
begin
  while (poz < length (eil)) and (eil [poz + 1] = ' ') do
  delete (eil, poz + 1, 1)
end;

{ Proced◊ra ‘terpia tarp– (' ') po nurodyto simbolio }
procedure trpPo (poz : byte; var eil : Teil);
begin
  if (poz < length (eil)) and (eil [poz + 1] <> ' ') then
  insert (' ', eil, poz + 1);
end;

{ Proced◊ra iterpia tarp– (' ') prie’ nurodyt– simbol‘ }
procedure trpPries (var poz : byte; var eil : Teil);
begin
  if (poz > 1) and (eil [poz - 1] <> ' ') then
  insert (' ', eil, poz - 1);
  inc (poz)
end;

begin
  { Paruo’iami failai }
  assign (fdat, 'duom.txt');
  assign (frez, 'rez.txt');
  reset (fdat);
  rewrite (frez);

  readln (fdat, sk);                     { kiek bus eilu—i÷ }
  for ck := 1 to sk do                   { nuskaitin”sim po eilut“ }
  begin
    readln (fdat, eil);                  { nuskaitom eilut“ }
    kab := false;                        { kabu—i÷ dar nebuvo }
    ckpoz := 0;                          { nagrin”sim eilut“ nuo 1 simbolio }
    while ckpoz < length (eil) do        { eilut”s nagrinejimo ciklas }
    begin
      inc (ckpoz);
      case eil [ckpoz] of
        ',', '.', ';', ':', ')' : begin  { jei vienas i’ ’i÷ simboli÷, tai }
                                    valPries (ckpoz, eil);
                                    trpPo (ckpoz, eil)
                                  end;
        ' ' : valPo (ckPoz, eil);        { jei tarpas, tai }
        '(' : begin                      { jei skliaustelis, tai }
                valPo (ckpoz, eil);
                trpPries (ckpoz, eil)
              end;
        '"' : begin                      { jei kabut”s, tai }
                if kab then              { jei kabut”s atsidaro, tai }
                begin
                   trpPo (ckpoz, eil);
                   valPries (ckpoz, eil)
                end
                else                     { jei kabut”s uÿsidaro, tai }
                begin
                  valPo (ckpoz, eil);
                  trpPries (ckpoz, eil);
                end;
                kab := not kab
              end
      end;
    end;
    writeln (frez, eil);                 { ira’om istaidyt– eilut“ }
  end;

  { Ira’omi ir uÿdaromi failai }
  close (fdat);
  close (frez);
end.