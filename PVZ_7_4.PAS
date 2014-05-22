program pavyzdys_7_4;
   uses crt, graph;
   const l = 100;
         r = 10; greitis = 150;
         zspalva = white;
         Nspalva = cyan;

   var x, y, tx, ty, mx, my, gm, gd : integer;

   procedure Ekranas;
   begin
      gd := detect;
      initgraph (gd, gm, '');
      if graphresult <> grOK then
         begin
            writeln ('Perjungimo klaida');
            halt (1);
         end;
      mx := getmaxx;
      my := getmaxy;
      randomize
   end;

   procedure Zuikis (x, y : integer; spalva : byte);
   begin
      setfillstyle (1, spalva);
      setcolor (spalva);
      fillellipse (x, y, R, R)
   end;

   procedure Langas (var x, y : integer);
   begin
      setcolor (Zspalva);
      rectangle (L, L, mx - l, my - l);
      setfillstyle (1, Nspalva);
      bar (l + 2, l + 2, mx - l - 2, my - l - 2);
      x := l + (mx - l) div 2;
      y := l + (mx - l) div 2;
      zuikis (x, y, Zspalva)
   end;

   procedure Kitas (var x, y : integer);
     var kampas : integer;
   begin
      kampas := random (360);
      x := trunc (cos (kampas / 180 * pi) * 10);
      x := trunc (sin (kampas / 180 * pi) * 10);
   end;

   function Galima (x, y, tx, ty : integer) : boolean;
     var k : integer;
   begin
      galima := true;
      if Tx > 0 then k := x + tx + r
                else k := x + tx - r;
      if getpixel (k, y) <> Nspalva then galima := false;
      if Ty > 0 then k := y + ty + r
                else k := y + ty - r;
      if getpixel (x, k) <> Nspalva then galima := false
   end;

begin
   ekranas;
   settextstyle (Gothicfont, 0, 4);
   outtextxy (mx div 3, l div 3, 'Zuikutis');
   settextstyle (0,0,2);
   outtextxy (mx div 3, my - l div 3, 'Pabaiga - Enter');
   langas (x, y);
   repeat
      kitas (tx, ty);
      while galima (x, y, tx, ty) do
        begin
           delay (greitis);
           zuikis (x, y, Nspalva);
           x := x + tx;
           y := y + ty;
           zuikis (x, y, Zspalva)
        end;
      until keypressed;
   while keypressed do readkey;
   closegraph;
end.