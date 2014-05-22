program pavyzdys_7_3;
  uses graph, crt;
  var a, e, i, r, xc, yc, tvark, mode : integer;
      pal : paletteType;
begin
   tvark := detect;
   initgraph (tvark, mode, '');
   if graphresult <> grOk then Halt(1);
   xc := getmaxx div 2;
   yc := getmaxy div 2;
   getdefaultpalette (pal);
   for i := 2 to maxcolors do
      begin
         r := 130 - 8 * i;
         setfillstyle (1, pal.colors [i]);
         pieslice (xc, yc, 0, 360, r);
      end;
   repeat
      a := pal.colors [2];
      for i := 3 to maxcolors do pal.colors [i - 1] := pal.colors [i];
      pal.colors [maxcolors] := a;
      setallpalette (pal);
      delay (1000);
   until keypressed;
   if keypressed then readkey;
end.