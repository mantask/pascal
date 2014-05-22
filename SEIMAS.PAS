Program SEIMAS;

Type
  Tats = array [1 .. 60] of longint;

var
  kiek, viso : Integer;
  ats : Tats;

procedure nuskaitymas (var viso : integer);
var
  f : Text;
begin
  assign (f, 'seimas.in');
  reset (f);
  readln (f, viso);
  close (f)
end;

procedure rask (viso : Integer; var kiek : Integer; var ats : Tats);
var
  max, pg, ck1, ck2 : longint;
  mas : array [1 .. 60, 1 .. 2] of longint;
begin
  mas [1, 1] := 1;
  mas [1, 2] := 1;
  for ck1 := 2 to viso do
  begin
    max := ck1;
    pg := ck1;
    for ck2 := 2 to ck1 - 1 do
    if (ck2 > mas [ck1 - ck2, 2]) and (ck2 * mas [ck1 - ck2, 1] > max) then
    begin
      max := ck2 * mas [ck1 - ck2, 1];
      pg := ck2
    end;
    mas [ck1, 1] := max;
    mas [ck1, 2] := pg
  end;

  kiek := 0;
  while mas [viso, 2] <> mas [viso, 1] do
  begin
    inc (kiek);
    ats [kiek] := mas [viso, 2];
    viso := viso - mas [viso, 2]
  end;
  inc (kiek);
  ats [kiek] := mas [viso, 1]
end;

procedure rasymas (kiek : Integer; var ats : Tats);
var
  f : Text;
  ck : Integer;
begin
  assign (f, 'seimas.out');
  rewrite (f);
  writeln (f, kiek);
  for ck := kiek downto 1 do
  writeln (f, ats [ck]);
  close (F)
end;

begin
  nuskaitymas (viso);
  rask (viso, kiek, ats);
  rasymas (kiek, ats)
end.