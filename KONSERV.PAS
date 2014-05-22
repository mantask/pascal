{ MK 2002 }
{ ======= }
{ Duotas produktu sarasas, kuriame pateiktas kiekvieno produkto svoris ir
  kaloringumas, ir mase, kuria gali panesti turistas. Rasti optimaliausia
  produktu komplekta. }

program konservai;

type
  Tprod = record
    sv, v : integer;
  end;
  Trinkinys = array [1 .. 100] of Tprod;
  TV = array [0 .. 100, 0 .. 100] of record
    v : integer;
    imta : boolean
  end;

var
  V : TV;
  prod : Trinkinys;
  m, viso : integer;

procedure nuskaitymas (var prod : Trinkinys; var m, viso : integer);
var
  f : text;
  ck : Integer;
begin
  assign (f, 'konserv.dat');
  reset (f);
  readln (f, m, viso);
  for ck := 1 to viso do
  readln (f, prod [ck].sv, prod [ck].v);
  close (f)
end;

function verte (sv, sk : integer; var v : TV) : Integer;
var
  pg, V1, V2 : integer;
begin
  if sk = 0 then
  begin
    verte := 0;
    exit
  end;
  if v [sv, sk].v <> -1 then
  begin
    verte := V [sv, sk].v;
    exit
  end;
  if sv >= prod [sk].sv then V1 := verte (sv - prod [sk].sv, sk - 1, V) + prod [sk].v
                        else V1 := -1;
  V2 := verte (sv, sk - 1, V);
  if V1 >= V2 then pg := V1
              else pg := V2;
  verte := pg;
  V [sv, sk].v := pg;
  V [sv, sk].imta := pg = V1
end;

procedure paruosk (var V : TV);
var
  ckx, cky : integer;
begin
  for ckx := 0 to m do
  for cky := 0 to viso do
  begin
    V [ckx, cky].v := -1;
    V [ckx, cky].imta := false
  end;
  for ckx := 1 to m do
  V [ckx, 0].v := 0;
  for cky := 0 to viso do
  V [0, cky].v := 0;
end;

procedure Imti (sk, m : Integer; imta : boolean);
begin
  if sk = 1 then
  begin
    if imta then write (sk, ' ')
  end
  else
  begin
    if imta then
    begin
      imti (sk - 1, m - prod [sk - 1].sv, V [m - prod [sk - 1].sv, sk - 1].imta);
      write (sk, ' ')
    end
    else imti (sk - 1, m, V [m, sk - 1].imta)
  end
end;

begin
  nuskaitymas (prod, m, viso);
  paruosk (V);
  verte (m, viso, V);
  writeln (V [m, viso].v);
  imti (viso, m, V [m, viso].imta);
  writeln
end.