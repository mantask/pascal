program vertimas;

const
  skaic : array [1 .. 19] of string =
   ('vienas', 'du', 'trys', 'keturi', 'penki', 'sesi', 'septyni', 'astuoni',
    'devyni', 'desimt', 'vienuolika', 'dvylika', 'trylika', 'keturiolika',
    'penkiolika', 'sesiolika', 'septyniolika', 'astuoniolika', 'devyniolika');
  des : array [2 .. 9] of string =
    ('dvidesimt', 'trisdesimt', 'keturiasdesimt', 'penkiasdesimt',
     'sesiasdesimt', 'setyniasdesimt', 'astuoniasdesimt', 'devyniasdesimt');
  tukst : array [1 .. 3] of string =
    ('tukstantis', 'tukstanciai', 'tukstanciu');
  simt : array [1 .. 2] of string =
    ('simtas', 'simtai');

var
  zodis, eil : string;
  ck, pg, poz : integer;
  jau, t : boolean;

begin
 eil := 'vienas';
{  assign (f, 'vert.dat');
  reset (f);
  readln (f, eil);
  close (f);
 }
  pg := 0;
  eil := 'keturi simtai vienuolika tukstanciu devyni simtai devyniasdesimt devyni';
  t := false;
  while length (eil) > 0 do
  begin
    poz := pos (' ', eil);
    if poz <> 0 then
    begin
      zodis := copy (eil, 1, poz - 1);
      delete (eil, 1, poz);
    end
    else
    begin
      zodis := eil;
      eil := '';
    end;
    jau := false;

    for ck := 1 to 19 do
    if zodis = skaic [ck] then
    begin
      pg := pg + ck;
      jau := true;
      break;
    end;

    if not jau then
    for ck := 2 to 9 do
    if zodis = des [ck] then
    begin
      pg := pg + ck * 10;
      jau := true;
      break;
    end;

    if not jau then
    for ck := 1 to 2 do
    if zodis = simt [ck] then
    begin
      if ck = 1 then pg := 100
                else pg := pg * 100;
      jau := true;
      break;
    end;

    if not jau then
    for ck := 1 to 3 do
    if zodis = tukst [ck] then
    begin
      if pg = 0 then pg := 1;
      Write (pg);
      pg := 0;
      t := true;
      jau := true;
      break;
    end

  end;

  if t then
  begin
    if pg div 100 < 1 then write (0);
    if pg div 10 < 1 then write (0);
    if pg < 1 then writeln (0)
              else writeln (pg)
  end
  else writeln (pg)
end.