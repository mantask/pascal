{ mk2002 }
{ Statistikos darbas mokyklai }

Program STAT2;

Type
  Tmas = array [1 .. 1000] of integer;
  Thist = array [1 .. 20] of integer;

var
  centras, vid, disp, nuokr, k1, k2, k3 : real;
  Turis, plotis : integer;
  hist : Thist;
  mas1, mas2 : Tmas;

procedure generavimas (var mas : TMas);
var
  ck : Integer;
begin
  randomize;
  for ck := 1 to 1000 do
  mas [ck] := 1000 + random (1000)
end;

procedure rikiuok (r1, r2 : Integer; var mas : Tmas);
var
  v1, v2, v, pg : Integer;
begin
  v1 := r1;
  v2 := r2;
  v := mas [(v1 + v2) div 2];
  repeat
    while mas [v1] < v do inc (v1);
    while mas [v2] > v do dec (v2);
    if v1 <= v2 then
    begin
      pg := mas [v1];
      mas [v1] := mas [v2];
      mas [v2] := pg;
      inc (v1);
      dec (v2)
    end
  until v1 > v2;
  if v1 < r2 then rikiuok (v1, r2, mas);
  if r1 < v2 then rikiuok (r1, v2, mas)
end;

procedure rask (var k1, k2, k3 : real; var Turis, plotis : integer;
                var centras : real; var hist : Thist;
                var vid, disp, nuokr : real);
var
  ck : Integer;
  sum : longint;
begin
  k1 := (mas2 [250] + mas2 [251]) / 2;
  k2 := (mas2 [500] + mas2 [501]) / 2;
  k3 := (mas2 [750] + mas2 [751]) / 2;
  Turis := 1000;
  plotis := mas2 [1000] - mas2 [1];
  centras := (mas2 [1] + mas2 [1000]) / 2;

  fillchar (hist, sizeof (hist), 0);
  for ck := 1 to 1000 do
  inc (hist [(mas2 [ck] - 1000) div 50 + 1]);

  sum := 0;
  for ck := 1 to 1000 do
  inc (sum, mas2 [ck]);
  vid := sum / 1000;

  sum := 0;
  for ck := 1 to 1000 do
  inc (sum, round (sqr (vid - mas2 [ck])));
  disp := sum / 1000;
  nuokr := sqrt (disp)
end;

procedure rasymas;
var
  f : Text;
  ck : Integer;
begin
  assign (f, 'stat2.txt');
  rewrite (f);
  writeln (f, '======================================');
  writeln (f, '    Statistikos darbas XII klasei');
  writeln (f, '======================================');
  writeln (f);
  writeln (f, ' I. IMTIS');
  writeln (f, '----------');
  for ck := 1 to 1000 do
  write (f, mas1 [ck] :5);
  writeln (f);
  writeln (f, ' II. VARIACINE EILE');
  writeln (f, '--------------------');
  for ck := 1 to 1000 do
  write (f, mas2 [ck] :5);
  writeln (f);
  writeln (f, ' III. IMTIES CHARAKTERISTIKOS');
  writeln (f, '------------------------------');
  writeln (f);
  writeln (f, 'Imties turis ', turis);
  writeln (f, 'Imties plotis ', plotis);
  writeln (f, 'Imties centras ', centras :1 :2);
  writeln (f, 'I kvartilis ', k1 :1 :2);
  writeln (f, 'II kvartilis (mediana) ', k2 :1 :2);
  writeln (f, 'III kvartilis ', k3 :1 :2);
  writeln (f, 'Imties matematine viltis ', vid :1 :2);
  writeln (f, 'Imties dispersija ', disp :1 :2);
  writeln (f, 'Imties vidutinis kvadratinis nuokrypis ', nuokr :1 :2);
  writeln (f);
  writeln (f, ' IV. IMTIES DAZNIU LENTELE');
  writeln (f, '---------------------------');
  writeln (f);
  for ck := 1 to 20 do
  write (f, '[', (ck - 1) * 50 + 1000, ';', ck * 50 + 999, ') ');
  writeln (f);
  for ck := 1 to 20 do
  write (f, hist [ck] :8, '    ');
  close (f)
end;

begin
  generavimas (mas1);
  mas2 := mas1;
  rikiuok (1, 1000, mas2);
  rask (k1, k2, k3, Turis, plotis, centras, hist, vid, disp, nuokr);
  rasymas
end.