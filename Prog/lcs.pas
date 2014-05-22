{ Longest common subsequence }

Program LCS;

type
  TMas = array [1 .. 100] of char;

var
  mas1, mas2 : Tmas;
  ilg1, ilg2, ats : Integer;

procedure nuskaitymas (var ilg1, ilg2 : integer; var mas1, mas2 : Tmas);
var
  f : text;
  ck : Integer;
begin
  assign (f, 'lcs.in');
  reset (f);
  readln (f, ilg1, ilg2);
  for ck := 1 to ilg1 do
  read (f, mas1 [ck]);
  readln (f);
  for ck := 1 to ilg2 do
  read (f, mas2 [ck]);
  close (f)
end;

function max (sk1, sk2 : integer) : Integer;
begin
  if sk1 > sk2 then max := sk1
               else max := sk2
end;

function rask : integer;
var
  mas : array [0 .. 100, 0 .. 100] of integer;
  ckx, cky : Integer;
begin
  for ckx := 1 to ilg1 do
  mas [ckx, 0] := 0;
  for cky := 1 to ilg2 do
  mas [0, cky] := 0;

  for cky := 1 to ilg2 do
  for ckx := 1 to ilg1 do
  if mas1 [ckx] = mas2 [cky]
  then mas [ckx, cky] := mas [ckx - 1, cky - 1] + 1
  else mas [ckx, cky] := max (mas [ckx - 1, cky], mas [ckx, cky - 1]);


  rask := mas [ilg1, ilg2]
end;

procedure rasymas (ats : integer);
var
  f : text;
begin
  assign (f, 'lcs.out');
  rewrite (f);
  writeln (f, ats);
  close (f)
end;

begin
  nuskaitymas (ilg1, ilg2, mas1, mas2);
  ats := rask;
  rasymas (ats)
end.
