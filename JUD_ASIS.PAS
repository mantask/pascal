program parabole;
  uses crt, graph;
  const xx = 639;
        yy = 479;
        j = 0;
        b = 4;
        greitis = 1000;
  var gm, gd, x, y : integer;
      D : boolean;
begin
   initgraph (gm, gd, '');
   x := 0; y := 0;
   setcolor (1);
   moveto (0, 0); lineto (xx, yy);
   D := true;
   while not keypressed do
    begin
      setcolor (j);
      moveto (x, 0); lineto (x, yy);
      moveto (0, y); lineto (xx, y);
      if D then
        begin
           if (y + 3) >= 479 then D := false
            else begin inc (x, 4); inc (y, 3); end;
        end
      else
        begin
           if (y - 3) <= 0 then D := true
            else begin dec (x, 4); dec (y, 3); end;
        end;
      setcolor (b);
      moveto (x, 0); lineto (x, yy);
      moveto (0, y); lineto (xx, y);
      delay (greitis);
    end;
  closegraph;
end.