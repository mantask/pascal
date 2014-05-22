{ 15.1 in Introduction to Algorithms }

Program Assembly_line_shceduling;

type
  Tlaik = array [1 .. 2, 1 .. 101] of integer;
  Tbaz = array [1 .. 2, 1 .. 100] of integer;

var
  laik : Tlaik;
  baz : Tbaz;
  ats, viso : Integer;

procedure nuskaitymas (var viso : Integer; var laik : Tlaik; var baz : Tbaz);
var
  f : Text;
  ck : Integer;
begin
  assign (f, 'ass.in');
  reset (f);
  readln (f, viso);
  for ck := 1 to viso + 1 do
  read (f, laik [1, ck]);
  readln (f);
  for ck := 1 to viso + 1 do
  read (f, laik [2, ck]);
  readln (f);
  for ck := 1 to viso do
  read (f, baz [1, ck]);
  readln (f);
  for ck := 1 to viso do
  read (f, baz [2, ck]);
  readln (f);
  close (f)
end;

function rask (viso : Integer; var laik : Tlaik; var baz : Tbaz) : integer;
var
  atst : array [1 .. 2, 1 .. 100] of integer;
  ck : integer;
begin
  atst [1, 1] := laik [1, 1] + baz [1, 1];
  atst [2, 1] := laik [2, 1] + baz [2, 1];
  for ck := 2 to viso do
  begin
    if atst [1, ck - 1] <= atst [2, ck - 1] + laik [2, ck]
    then atst [1, ck] := atst [1, ck - 1] + baz [1, ck]
    else atst [1, ck] := atst [2, ck - 1] + laik [2, ck] + baz [1, ck];
    if atst [2, ck - 1] <= atst [1, ck - 1] + laik [1, ck]
    then atst [2, ck] := atst [2, ck - 1] + baz [2, ck]
    else atst [2, ck] := atst [1, ck - 1] + laik [1, ck] + baz [2, ck]
  end;
  if atst [1, viso] + laik [1, viso + 1] <= atst [2, viso] + laik [2, viso + 1]
  then rask := atst [1, viso] + laik [1, viso + 1]
  else rask := atst [2, viso] + laik [2, viso + 1]
end;

procedure rasymas (ats : integer);
var
  f : Text;
begin
  assign (f, 'ass.out');
  rewrite (f);
  writeln (f, ats);
  close (f)
end;

begin
  nuskaitymas (viso, laik, baz);
  ats := rask (viso, laik, baz);
  rasymas (ats)
end.
