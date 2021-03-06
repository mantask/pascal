{ MK 2002                    }
{ Mantas Kanaporis           }
{ Vilniaus �emynos gimnazija }
{ -------------------------- }
{ XI skyrius                 }
{ 4 u�davinys                }

{ ID�JA yra i� karto nuskaityt� simbol� koduoti ir �ra�yti � rezultat� fail� }

program kanap114;

const
  eil : string = 'A�BC�DE��FGHI�YJKLMNOPRS�TU��VZ�'; { koduotini simboliai }
  ilg = 32;      { koduotin� simboli� s�ra�o ilgis }

var
  Fin, Fout : text;
  c : char;

function Cez (c : char) : char;
var
  poz : integer;
begin
  c := upcase (c);
  poz := pos (c, eil);             { jei nuskaitytas simbolis yra koduotinis }
  if poz <> 0 then cez := eil [(poz + 1) mod ilg + 1] { tai jis perstumiamas }
              else cez := c                           { per 2 pozicijas }
end;

begin
  assign (fin, 'duom.txt');
  reset (fin);
  assign (fout, 'rez.txt');
  rewrite (fout);

  while not eof (fin) do
  begin
    while not eoln (fin) do
    begin
      read (fin, c);              { nuskaitome po simbol� ir j� i� karto }
      write (fout, cez (c))       { u�kodav� �ra�ome � rezultat� fail� }
    end;
    readln (fin);
    writeln (fout)
  end;

  close (fin);
  close (fout)
end.