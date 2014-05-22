program STAT;

Type
  Tmas = array [1 .. 3, 1 .. 70] of integer;
  Tdaz = array [1 .. 3, 1 .. 100] of integer;

var
  mas : Tmas;
  daz : Tdaz;

procedure nuskaitymas (var mas : TMas; var daz : Tdaz);
var
  f : Text;
  ck : Integer;
begin
  fillchar (daz, sizeof (daz), 0);
  assign (f, 'stat.dat');
  reset (f);
  for ck := 1 to 70 do
  begin
    readln (f, mas [1, ck], mas [2, ck], mas [3, ck]);
    inc (daz [1, mas [1, ck]]);
    inc (daz [2, mas [2, ck]]);
    inc (daz [3, mas [3, ck]])
  end;
  close (f)
end;

procedure rikiuok (r1, r2, ind : Integer; var mas : TMas);
var
  v1, v2, v, pg : integer;
begin
  v1 := r1;
  v2 := r2;
  v := mas [ind, (v1 + v2) div 2];
  repeat
    while mas [ind, v1] < v do inc (v1);
    while mas [ind, v2] > v do dec (v2);
    if v1 <= v2 then
    begin
      pg := mas [ind, v1];
      mas [ind, v1] := mas [ind, v2];
      mas [ind, v2] := pg;
      inc (v1);
      dec (v2)
    end
  until v1 > v2;
  if r1 < v2 then rikiuok (r1, v2, ind, mas);
  if v1 < r2 then rikiuok (v1, r2, ind, mas)
end;

procedure rasymas (var mas : Tmas; var daz : Tdaz);
var
  f : text;
  sum, ck : integer;
  pg, v1, v2, v3 : real;
begin
  assign (f, 'stat.txt');
  rewrite (f);
  sum := 0;
  for ck := 1 to 70 do
  begin
    writeln (f, mas [1, ck]);
    inc (sum, mas [1, ck])
  end;
  v1 := sum / 70;
  writeln (f, 'vid ', v1 :1 :2);
  pg := 0;
  for ck := 1 to 70 do
  pg := pg + sqr (v1 - mas [1, ck]);
  writeln (f, 'disp ', pg / 70 :1 :2);
  writeln (f);
  sum := 0;
  for ck := 1 to 70 do
  begin
    writeln (f, mas [2, ck]);
    inc (sum, mas [2, ck])
  end;
  v2 := sum / 70;
  writeln (f, 'vid ', v2 :1 :2);
  pg := 0;
  for ck := 1 to 70 do
  pg := pg + sqr (v2 - mas [2, ck]);
  writeln (f, 'disp ', pg / 70 :1 :2);
  writeln (f);
  sum := 0;
  for ck := 1 to 70 do
  begin
    writeln (f, mas [3, ck]);
    inc (sum, mas [3, ck])
  end;
  v3 := sum / 70;
  writeln (f, 'vid ', v3 :1 :2);
  pg := 0;
  for ck := 1 to 70 do
  pg := pg + sqr (v3 - mas [3, ck]);
  writeln (f, 'disp ', pg / 70 :1 :2);
  writeln (f);
  sum := 0;
  for ck := 1 to 100 do
  if ck mod 5 = 0 then
  begin
    inc (sum, daz [1, ck]);
    writeln (f, ck - 4, '..', ck, ' ', sum);
    sum := 0;
  end
  else inc (sum, daz [1, ck]);
  writeln (f);
  sum := 0;
  for ck := 1 to 100 do
  if ck mod 5 = 0 then
  begin
    inc (sum, daz [2, ck]);
    writeln (f, ck - 4, '..', ck, ' ', sum);
    sum := 0;
  end
  else inc (sum, daz [2, ck]);
  writeln (f);
  sum := 0;
  for ck := 1 to 100 do
  if ck mod 5 = 0 then
  begin
    inc (sum, daz [3, ck]);
    writeln (f, ck - 4, '..', ck, ' ', sum);
    sum := 0;
  end
  else inc (sum, daz [3, ck]);
  writeln (f);
  close (f)
end;

begin
  nuskaitymas (mas, daz);
  rikiuok (1, 70, 1, mas);
  rikiuok (1, 70, 2, mas);
  rikiuok (1, 70, 3, mas);
  rasymas (mas, daz)
end.