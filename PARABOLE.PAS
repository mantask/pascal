program parabole;
  uses crt, graph;
  const xx = 319;
        yy = 0;
  var gm, gd, x, y : integer;
      a : boolean;
begin
   initgraph (gm, gd, '');
   setcolor (8);
   Outtextxy (580, 470, 'MK 2001');
   setcolor (4);
   line ( 1, yy, 639, yy);
   line (xx, 0, xx, 479);
   setcolor (5);
   a := true;
   for x := -170 to 170 do
    begin
       y := trunc (x * x / 50);
       if a then a := false else lineto (xx + x, y + yy);
       moveto (xx + x, yy + y);
    end;
   readkey;
   closegraph;
end.