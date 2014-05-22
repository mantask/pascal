program laivas;
   uses graph, crt;
   var c, x, y, gm, gd : integer;
       keys : array [1 .. 128] of boolean;
       myg : char;
       t, t1, t2 : string [10];
begin
   gm := detect;
   initgraph (gm, gd, '');
   x := 100; y := 100;
   putpixel (x, y, c);
   c := 15;
   repeat
      myg := readkey;
      if ord (myg) = 117 then dec (y);
      if ord (myg) = 104 then dec (x);
      if ord (myg) = 107 then inc (x);
      if ord (myg) = 106 then inc (y);
      if ord (myg) =  13 then c := random (16) + 1;
      putpixel (x, y, c);
    until ord (myg) = 27;

   if keypressed then readkey;
   closegraph;
end.
