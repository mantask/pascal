{ MK 2001                    }
{ Mantas Kanaporis           }
{ Vilniaus Ïemynos gimnazija }
{ -------------------------- }
{ VIII skyrius               }
{ 2 uØdavinys                }

program JPM_8_2;

var
  eil : string;

function pol (eil : string) : boolean;
var
  poz : byte;
  pgC : char;
  ats,
  por : boolean; { ar gali 1 skaicius netureti poros }
begin
  ats := true;
  por := (length (eil) mod 2) = 1;

  while length (eil) > 0 do
  begin
    pgc := eil [1];
    eil := copy (eil, 2, length (eil) - 1);
    poz := pos (pgc, eil);
    if poz <> 0
    then eil := copy (eil, 1, poz - 1) + copy (eil, poz + 1, length (eil) - poz)
    else if por then
    begin
      eil := copy (eil, 1, poz) + copy (eil, poz, length (eil));
      por := false;
    end
    else
    begin
      ats := false;
      break
    end
  end;

  pol := ats;
end;

begin
  writeln (pol ('45545445'));
end.