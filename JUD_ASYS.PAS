program parabole;
  uses crt, graph;
  const xx = 639;
        yy = 479;
        b = 4;
        j = 0;
  var gm, gd, x, y : integer;
      a : char;
begin
   initgraph (gm, gd, '');
   a := ' ';
   x := 10; y := 10;
   setcolor (b);
   moveto (x, 0); lineto (x, yy);
   moveto (0, y); lineto (xx, y);
   while ord (a) <> 27 do
    begin
      a := readkey;
      if ord (a) in [13, 72, 75, 77, 80] then
       begin
         setcolor (j);
         moveto (x, 0); lineto (x, yy);
         moveto (0, y); lineto (xx, y);
         case ord (a) of
           72 : if (y - 3) >= 0 then dec (y, 3);
           75 : if (x - 4) >= 0 then dec (x, 4);
           77 : if (x + 4) < 640 then inc (x, 4);
           80 : if (y + 3) < 480 then inc (y, 3);
           13 : begin setcolor (6); rectangle (x - 4, y - 3, x + 4, y + 3); setcolor (5); end;
         end;
         setcolor (b);
         moveto (x, 0); lineto (x, yy);
         moveto (0, y); lineto (xx, y);
       end;
    end;
   closegraph;
end.