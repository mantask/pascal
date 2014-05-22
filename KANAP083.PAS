{ MK 2001                    }
{ Mantas Kanaporis           }
{ Vilniaus Ïemynos gimnazija }
{ -------------------------- }
{ VIII skyrius               }
{ 3 uØdavinys                }

program JPM_8_3;

var
  c : char;

function succliet (c : char) : char;
const
  eil : string = 'AµBC¶DE·¸FGHI½YJKLMNOPRS¾TUÆÇVZÏ';
var
  poz : byte;
  didz : boolean;
begin
  if (c >= 'a') and (c <= 'z') then didz := false;
  case c of
    'Ð' : begin c := 'µ'; didz := false end;
    'Ñ' : begin c := '¶'; didz := false end;
    'Ò' : begin c := '·'; didz := false end;
    'Ó' : begin c := '¸'; didz := false end;
    'Ô' : begin c := '½'; didz := false end;
    'Õ' : begin c := '¾'; didz := false end;
    'Ö' : begin c := 'Æ'; didz := false end;
    '×' : begin c := 'Ç'; didz := false end;
    'Ø' : begin c := 'Ï'; didz := false end;
    else c := upcase (c);
  end;
  poz := pos (c, eil);
  if poz <> 0 then c := eil [poz mod 32 + 1];
  if not didz then
  case c of
    'µ' : c := 'Ð';
    '¶' : c := 'Ñ';
    '·' : c := 'Ò';
    '¸' : c := 'Ó';
    '½' : c := 'Ô';
    '¾' : c := 'Õ';
    'Æ' : c := 'Ö';
    'Ç' : c := '×';
    'Ï' : c := 'Ø';
    else c := chr (ord (c) - 32);
  end;
  succliet := c
end;

function predliet (c : char) : char;
const
  eil : string = 'AµBC¶DE·¸FGHI½YJKLMNOPRS¾TUÆÇVZÏ';
var
  poz : byte;
  didz : boolean;
begin
  if (c >= 'a') and (c <= 'z') then didz := false;
  case c of
    'Ð' : begin c := 'µ'; didz := false end;
    'Ñ' : begin c := '¶'; didz := false end;
    'Ò' : begin c := '·'; didz := false end;
    'Ó' : begin c := '¸'; didz := false end;
    'Ô' : begin c := '½'; didz := false end;
    'Õ' : begin c := '¾'; didz := false end;
    'Ö' : begin c := 'Æ'; didz := false end;
    '×' : begin c := 'Ç'; didz := false end;
    'Ø' : begin c := 'Ï'; didz := false end;
    else c := upcase (c);
  end;
  poz := pos (c, eil);
  if poz <> 0 then c := eil [(poz + 30) mod 32 + 1];
  if not didz then
  case c of
    'µ' : c := 'Ð';
    '¶' : c := 'Ñ';
    '·' : c := 'Ò';
    '¸' : c := 'Ó';
    '½' : c := 'Ô';
    '¾' : c := 'Õ';
    'Æ' : c := 'Ö';
    'Ç' : c := '×';
    'Ï' : c := 'Ø';
    else c := chr (ord (c) - 32);
  end;
  predliet := c
end;

BEGIN
  c := 'a';
  writeln (predliet (c), ' ',c,' ', succliet (c))
END.