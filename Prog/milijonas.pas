{ Kaip panesti milijona. 112 uzd is olimp }

program milijonas;

type
  Tmas = array [1 .. 200, 1 .. 2] of integer;

var
  ats, viso, kiek : Integer;
  mas : Tmas;

procedure nuskaitymas (var kiek, viso : Integer; var mas : Tmas);
var
  f : text;
  ck : Integer;
begin
  assign (f, 'mil.in');
  reset (f);
  readln (f, kiek, viso);
  for ck := 1 to kiek do
  readln (f, mas [ck, 1], mas [ck, 2]);
  close (f)
end;

function rask (kiek, viso : Integer; var mas : TMas) : Integer;
var
  verte : array [0 .. 100] of integer;
  ind, ck1, ck2 : Integer;
begin
  fillchar (verte, sizeof (verte), $FF);
  verte [0] := 0;
  for ck1 := 0 to viso do
  if verte [ck1] <> -1 then
  for ck2 := 1 to kiek do
  begin
    ind := ck1 + mas [ck2, 1];
    if (ind <= viso) and ((verte [ind] = -1) or (verte [ind] > verte [ck1] + mas [ck2, 2]))
    then verte [ind] := verte [ck1] + mas [ck2, 2]
  end;
  ck1 := viso;
  while verte [ck1] = -1 do dec (ck1);
  rask := verte [ck1]
end;

procedure rasymas (ats : integer);
var
  f : Text;
begin
  assign (f, 'mil.out');
  rewrite (f);
  writeln (f, ats);
  close (f)
end;

begin
  nuskaitymas (kiek, viso, mas);
  ats := rask (kiek, viso, mas);
  rasymas (ats)
end.

