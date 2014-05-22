{ MK 2002 }

{ Kompiuterija Nr60, Kasubos skiltis }
Program Kopustu_dalybos;

Const
  sv : array [1 .. 5] of integer = (100, 200, 210, 300, 310);
  viso = 5;

TYpe
  Taib = set of 1 .. 5;
  Tmas = array [1 .. 5, 1 .. 2] of integer;

var
  mas : Tmas;
  aib : Taib;
  sum1, sum2, uod : integer;
  f : text;

procedure IMK (var SUM1, SUM2 : integer; var aib : Taib;
               var uod : Integer; var mas : Tmas; var F : text);
var
  sk, ck : Integer;
  pg : boolean;
begin
  if aib <> [] then
  begin
    for ck := 1 to viso do
    if ck in aib then
    begin
      aib := aib - [ck];
      mas [uod, 1] := sv [ck];
      if sum1 <= sum2 then
      begin
        pg := true;
        inc (sum1, sv [ck]);
        mas [uod, 2] := 1
      end
      else
      begin
        pg := false;
        inc (sum2, sv [ck]);
        mas [uod, 2] := 2
      end;
      inc (uod);
      IMK (sum1, sum2, aib, uod, mas, f);
      if pg then dec (sum1, sv [ck])
                      else dec (sum2, sv [ck]);
      dec (uod);
      aib := aib + [ck]
    end
  end
  else
  begin
    write (f, ' I : ');
    for ck := 1 to uod - 1 do
    if mas [ck, 2] = 1 then
    write (f, mas [ck, 1], ' ');
    writeln (f, '/ ', sum1);
    write (f, 'II : ');
    for ck := 1 to uod - 1 do
    if mas [ck, 2] = 2 then
    write (f, mas [ck, 1], ' ');
    writeln (f, '/ ', sum2);
    writeln (f, '--------------------------------------')
  end
end;

begin
  aib := [1 .. viso];
  sum1 := 0;
  sum2 := 0;
  uod := 1;

  assign (f, 'kasuba.txt');
  rewrite (F);
  writeln (f, '---------------[ mk2002 ]-------------');
  IMK (sum1, sum2, aib, uod, mas, f);
  close (f)
end.