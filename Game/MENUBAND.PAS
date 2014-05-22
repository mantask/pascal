program as;
  uses meniu, graph;
  var gm, gd : integer;
      menu : Tpagrmeniu;
begin
  initgraph (gm, gd, '');
  menu.paruosk;
  menu.klavisas (88);
  repeat until port [$60] = 1;
  closegraph;
end.