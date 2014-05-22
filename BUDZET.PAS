program Capital_Budgeting_problems;

type
  Tpas = record
    viso : Integer;
    p : array [1 .. 10] of integer
  end;

var
  viso : integer; { viso gamyklu }
  pas : Tpas;

procedure nuskaitymas (var pas : Tpas; viso : integer);
var
  f : Text;
  ck, ck1 : integer;
begin
  assign (f, 'budzet.dat');
  reset (f);
  readln (f, viso);
  for ck := 1 to viso do
  begin
    readln (pas )
  end;
  close (f)
end;

begin
end.