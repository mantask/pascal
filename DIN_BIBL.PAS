{ MK 2002 }

program bibliotekininkas;

const
  maxlent = 9;
  maxzm = 3;

type
  Tlent = array [1 .. maxlent] of integer;
  TV = array [1 .. maxzm, 1 .. maxlent] of integer;

var
  lent : Tlent;
  s, ck, ckzm, cklent, kiek, zm : integer;
  suma : array [0 .. maxlent] of integer;
  v : Tv;

Procedure nuskaitymas (var lent : Tlent; Var kiek, zm : integer);
var
  f : Text;
  ck : Integer;
begin
  assign (f, 'lentyn.dat');
  reset (f);
  readln (f, kiek, zm);
  for ck := 1 to kiek do
  read (f, lent [ck]);
  close (f)
end;

Function Max (sk1, sk2 : integer) : integer;
begin
  if sk1 > sk2 then max := sk1
               else max := sk2
end;

begin
  nuskaitymas (lent, kiek, zm);

  { sumos }
  suma [0] := 0;
  for ck := 1 to kiek do
  suma [ck] := suma [ck - 1] + lent [ck];

  { ribiniai atvejai }
  for ck := 1 to kiek do       { jei yra tik vienas zmogus, }
  v [1, ck] := suma [ck];      { tai jis dalins iki ten, kur yra dedamas }
  for ck := 1 to zm do         { jei viena knyga ir daug zmoniu, tai... }
  v [ck, 1] := lent [1];

  { dinaminis skaiciavimas is apacios }
  for cklent := 2 to kiek do
  for ckzm := 2 to zm do
  begin
    v [ckzm, cklent] := maxint;
    for ck := 1 to cklent - 1 do
    begin
      s := max (v [ckzm - 1, ck], suma [cklent] - suma [ck]);
      { jei radome mazesnes sanaudas, tai jas issaugome }
      if s < v [ckzm, cklent] then v [ckzm, cklent] := s
    end
  end;

  { atsakymas }
  writeln ('Maksimalios sanaudos ', V [zm, kiek])
end.