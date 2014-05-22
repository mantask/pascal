{ mk 2003 }

{ n skaiciu isskaidome i dvi grupes, kad ju sumos lygios }

type
  Tmas = array [1 .. 100] of boolean;

var
  mas : Tmas;
  n, puse : integer;
  ok : boolean;

procedure lisk (nuo, kiek, sum : integer; var mas : Tmas);
var
  ck : Integer;
begin
  if ok then exit;
  if kiek = n div 2 then
  begin
    if sum = puse then
    begin
      write (sum, ': ');
      for ck := 1 to n do
      if mas [ck] then write (ck, ' ');
      writeln;
      ok := true;
    end;
    exit
  end;
  for ck := nuo to n do
  begin
    mas [ck] := true;
    lisk (ck + 1, kiek + 1, sum + ck, mas);
    mas [ck] := false
  end
end;

begin
  writeln ('  ======================');
  n := 50;
  fillchar (mas, sizeof (mas), 0);
  mas [1] := true;
  ok := false;
  puse := (n + 1) * n div 4;
  lisk (2, 1, 1, mas);
end.