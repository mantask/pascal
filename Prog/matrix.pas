{ 15.2 in Introduction to Algorithms }

Program Matrix_chain_order;

type
  Tmas = array [0 .. 100] of integer;

var
  ats : longint;
  viso : Integer;
  mas : TMas;

procedure nuskaitymas (var viso : integer; var mas : Tmas);
var
  f : Text;
  ck : Integer;
begin
  assign (f, 'matrix.in');
  reset (f);
  readln (f, viso);
  for ck := 0 to viso do
  read (f, mas [ck]);
  close (f)
end;

function rask (viso : Integer; var mas : TMas) : longint;
var
  a : array [1 .. 100, 1 .. 100] of longint;
  pg : longint;
  ckILG, pr, pb, vid : Integer;
begin
  for pr := 1 to viso do { ckILG := 1 }
  a [pr, pr] := 0;

  for ckILG := 2 to viso do
  for pr := 1 to viso - ckILG + 1 do
  begin
    pb := pr + ckILG - 1;
    a [pr, pb] := maxint;
    for vid := pr to pb - 1 do
    begin
      pg := a [pr, vid] + a [vid + 1, pb] + mas [pr - 1] * mas [vid] * mas [pb];
      if pg < a [pr, pb] then a [pr, pb] := pg
    end
  end;

  rask := a [1, viso]
end;

procedure rasymas (ats : longint);
var
  f : text;
begin
  assign (f, 'matrix.out');
  rewrite (f);
  writeln (f, ats);
  close (f)
end;

begin
  nuskaitymas (viso, mas);
  ats := rask (viso, mas);
  rasymas (ats)
end.

