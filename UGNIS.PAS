{MK 2001}
{nieko kol kas nera, anskciau kai paleidinedavau man visa sistema numusdavo}
program ugnis;

uses
  graph;

var
  ck : byte;

procedure palete;
var ck, r, g, b : byte;
begin
  for ck := 0 to 255 do
  setRGBpal (ck, ck, ck, ck)
end;

begin
  initgraf;
  for ck := 1 to 255 do
  hline (0, 100, ck, ck, 0);
  repeat until port [$60] = 1;
  inittext;
end.