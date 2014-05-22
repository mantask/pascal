program asdf;
   uses graph;
   var a : byte absolute $a000:0000;
       gm, gd, b, ck : integer;
begin

   gm := a;
   writeln (a);
   readln;
   initgraph (gm, gd, '');
   b := getmaxcolor;
   for ck := 1 to 250 do putpixel (ck, 100, ck);

   readln;
   closegraph;
end.