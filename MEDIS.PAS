{ MK 2002 }
{ Minimalaus jungiamojo medzio paieska. Veikia puikiai }
program Medis;

const
  max = 10;

type
  Telem = array [1 .. 3] of integer;
  Tg = array [1 .. max] of Telem;
  Taib = set of 1 .. max;
  Tm = array [1 .. max] of Taib;

var
  virs, viso : integer;
  g : Tg;

procedure nuskaitymas (var virs, viso : integer; var G : TG);
var
  ck, pg, v1, v2, sv : integer;
  f : Text;
begin
  assign (f, 'medis.dat');
  reset (f);
  readln (f, virs, viso);
  for ck := 1 to viso do
  begin
    readln (f, v1, v2, sv);
    g [ck, 1] := v1;
    g [ck, 2] := v2;
    g [ck, 3] := sv
  end;
  close (f)
end;

procedure rikiuok (k1, k2 : integer; var G : TG);
var
  pg : Telem;
  v1, v2, vid : integer;
begin
  v1 := k1;
  v2 := k2;
  vid := g [(v1 + v2) div 2, 3];
  repeat
    while g [v1, 3] > vid do inc (v1);
    while g [v2, 3] < vid do dec (v2);
    if v1 <= v2 then
    begin
      pg := g [v1];
      g [v1] := g [v2];
      g [v2] := pg;
      inc (v1);
      dec (v2)
    end
  until v1 > v2;
  if k1 < v2 then rikiuok (k1, v2, g);
  if v1 < k2 then rikiuok (v1, k2, g)
end;

function sakos : integer;
var
  aib : Taib; { panaudotu briaunu indeksai masyve }
  sv, br, ck : integer;
  m : Tm;

function galima (v1, v2 : integer; aib : Taib) : boolean;
var
  ck : Integer;
  ok : boolean;
begin
  ok := true;
  for ck := 1 to viso do
  if (ck in aib) and (v1 in m [g [ck, 1]]) and (v2 in m [g [ck, 1]]) then
  begin
    ok := false;
    break
  end;
  galima := ok
end;

procedure prijunk (br : Integer; var m : TM);
var
  ck : integer;
  aib : taib;
begin
  aib := m [g [br, 1]] + m [g [br, 2]];
  for ck := 1 to viso do
  if (ck in m [g [br, 1]]) or (ck in m [g [br, 2]])
  then m [ck] := aib
end;

begin
  for ck := 1 to virs do
  m [ck] := [ck];
  aib := [1];
  m [g [1, 1]] := [g [1, 1]] + [g [1, 2]];
  m [g [1, 2]] := [g [1, 1]] + [g [1, 2]];
  br := 1;
  ck := 2;
  sv := g [1, 3];
  while br + 1 <> virs do
  begin
    if galima (g [ck, 1], g [ck, 2], aib) then
    begin
      aib := aib + [ck];
      prijunk (ck, m);
      sv := sv + g [ck, 3];
      inc (br)
    end;
    inc (ck)
  end;
  sakos := sv
end;

begin
  nuskaitymas (virs, viso, g);
  rikiuok (1, viso, g);
  writeln (sakos)
end.