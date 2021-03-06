{ MK 2001                    }
{ Mantas Kanaporis           }
{ Vilniaus �emynos gimnazija }
{ -------------------------- }
{ VIII skyrius               }
{ 3 u�davinys                }

program JPM_8_3;

var
  c : char;

function succliet (c : char) : char;
const
  eil : string = 'A�BC�DE��FGHI�YJKLMNOPRS�TU��VZ�';
var
  poz : byte;
  didz : boolean;
begin
  if (c >= 'a') and (c <= 'z') then didz := false;
  case c of
    '�' : begin c := '�'; didz := false end;
    '�' : begin c := '�'; didz := false end;
    '�' : begin c := '�'; didz := false end;
    '�' : begin c := '�'; didz := false end;
    '�' : begin c := '�'; didz := false end;
    '�' : begin c := '�'; didz := false end;
    '�' : begin c := '�'; didz := false end;
    '�' : begin c := '�'; didz := false end;
    '�' : begin c := '�'; didz := false end;
    else c := upcase (c);
  end;
  poz := pos (c, eil);
  if poz <> 0 then c := eil [poz mod 32 + 1];
  if not didz then
  case c of
    '�' : c := '�';
    '�' : c := '�';
    '�' : c := '�';
    '�' : c := '�';
    '�' : c := '�';
    '�' : c := '�';
    '�' : c := '�';
    '�' : c := '�';
    '�' : c := '�';
    else c := chr (ord (c) - 32);
  end;
  succliet := c
end;

function predliet (c : char) : char;
const
  eil : string = 'A�BC�DE��FGHI�YJKLMNOPRS�TU��VZ�';
var
  poz : byte;
  didz : boolean;
begin
  if (c >= 'a') and (c <= 'z') then didz := false;
  case c of
    '�' : begin c := '�'; didz := false end;
    '�' : begin c := '�'; didz := false end;
    '�' : begin c := '�'; didz := false end;
    '�' : begin c := '�'; didz := false end;
    '�' : begin c := '�'; didz := false end;
    '�' : begin c := '�'; didz := false end;
    '�' : begin c := '�'; didz := false end;
    '�' : begin c := '�'; didz := false end;
    '�' : begin c := '�'; didz := false end;
    else c := upcase (c);
  end;
  poz := pos (c, eil);
  if poz <> 0 then c := eil [(poz + 30) mod 32 + 1];
  if not didz then
  case c of
    '�' : c := '�';
    '�' : c := '�';
    '�' : c := '�';
    '�' : c := '�';
    '�' : c := '�';
    '�' : c := '�';
    '�' : c := '�';
    '�' : c := '�';
    '�' : c := '�';
    else c := chr (ord (c) - 32);
  end;
  predliet := c
end;

BEGIN
  c := 'a';
  writeln (predliet (c), ' ',c,' ', succliet (c))
END.