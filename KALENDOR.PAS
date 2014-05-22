program kalendorius;

type
  Tdata = record
             m : integer;
             men, d : byte;
          end;

var
  data1, data2 : Tdata;
  sk : longint;
  f : text;

function suma (nr : byte; K : boolean) : integer;
var
  pg : integer;
begin
  case nr of
     1 : pg := 0;
     2 : pg := 31;
     3 : pg := 59;
     4 : pg := 90;
     5 : pg := 120;
     6 : pg := 151;
     7 : pg := 181;
     8 : pg := 212;
     9 : pg := 243;
    10 : pg := 273;
    11 : pg := 304;
    12 : pg := 334;
  end;
  if k then inc (pg);
  suma := pg;
end;

begin
  assign (f, 'data.dat');
  reset (F);
  readln (f, data1.m, data1.men, data1.d);
  readln (f, data2.m, data2.men, data2.d);
  close (F);
  sk := (data2.m - data1.m - 1) * 365;
  {klaida}
  if data1.m mod 4 = 0 then inc (sk);
  sk := sk + (data2.m - data1.m) div 4);
  {klaida}
  if (data2.m - data1.m - 1 = 0) and (data1.m mod 4 = 0) and ((data1.men < 2) or ((data1.men = 2) and (data2.d < 29)))
  then inc (sk);
  sk := sk + suma (data2.men, (data2.m mod 4 = 0)) + data2.d;
  if (data2.m - data1.m - 1 = 0) and (data2.m mod 4 = 0) and ((data2.men > 2) or ((data1.men = 2) and (data2.d > 28)))
  then inc (sk);
  sk := sk + 365 - suma (data1.men, (data1.m mod 4 = 0)) - data1.d;
  writeln (sk)
end.