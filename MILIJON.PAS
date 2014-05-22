{ MK 2002 }
{ daryti perrinkima is viraus }
program Kaip_Panesti_Milijona;

type
  Tduom = array [1 .. 200] of
  record
    sv, ver : integer
  end;
  Tv = array [0 .. 100, 0 .. 200] of integer;

var
  viso, sv : Integer;
  duom : Tduom;

procedure nuskaitymas (var viso, sv : integer; var duom : Tduom);
var
  f : text;
  ck : integer;
begin
  assign (f, 'milijon.dat');
  reset (f);
  readln (f, viso, sv);
  for ck := 1 to viso do
  readln (f, duom [ck].sv, duom [ck].ver);
  close (f)
end;

{procedure skaiciuoti;
var
  sum : array [0 .. 10] of integer;
  ck : Integer;

  function max (sk1, sk2 : integer) : integer;
  begin
    if sk1 > sk2 then max := sk1
                 else max := sk2
  end

  function v (svoris, gylis : Integer) : integer;
  var
    pg, ck : integer;
  begin
    if gylis = 0 then
    begin
      svoris := 0;
      exit
    end
    else
    begin
      for ck := 1 to gylis - 1 do
      if duom [ck]
      pg := max (v (sv - , )
    end
  end;

begin
  sum [0] := 0;
  for ck := 1 to viso do
  sum [ck] := sum [ck - 1] + duom [ck].ver;
end;
}

procedure skaiciuoti;
var
  cksv, ckn : integer;
  svoris : array [0 .. 200, 0 .. 100] of integer;
begin
  for cksv := 1 to sv do
  for ckn := 1 to viso do
  svoris [ckn, cksv] := -1;
  { ribiniai atvejai }
  for cksv := 0 to sv do
  svoris [0, cksv] := 0;
  for ckn := 0 to viso do
  svoris [ckn, 0] := 0;

  {  }
  for ckn := 1 to viso do
  for cksv := 1 to sv do

end;

begin
  nuskaitymas (viso, sv, duom);

end.