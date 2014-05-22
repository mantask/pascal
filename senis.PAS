program senis;

   uses graph, crt;

                              { senio besmegenio spalvos }
   const senio_spalva = 15;
         nosies_spalva = 12;
         akiu_spalva = 0;
         burnos_spalva = 6;
         kibiro_spalva = 8;
         kibiro_virsaus_spalva = 7;
         sluotgalio_spalva = 6;
         sluotos_spalva = 14;

   var gd, gm,                         { kintamieji grafikai }
       anim,                           { animacijos numeris }
       i,                              { snaig”s numeris }
       k,                              { kintamasis snaig”ms }
       pixel,                          { optimizacijos kintamasis }
       timer: integer;                 { uÿdelsimo kintamasis }
       snai,                           { snaigi÷ y masyvas }
       x : array [1..200] of integer;  { snaigi÷ x masyvas }


    { procedura pie’ia ’luota }
 procedure sluota(x, y, x1, y1: integer; sp, sp2: byte);

    var x2, y2, i: integer;
   begin
     setcolor(sp);
     setlinestyle(0, 0, thickwidth);
     line(x, y, x1, y1);
     setlinestyle(0, 0, normwidth);
     setcolor(sp2);
     x2 := x + ((x - x1) div ((y1 - y) div 50));
     y2 := y - 50;
     for i := 1 to 10 do
       line((x + i - 5), y, x2 + (i * 4) - 20, y2);

   end;



 begin
        { Atidarom grafikos reÿim– }
   gd := detect;
   initgraph(gd, gm, '');

         { pie’iam sen‘ }
   setcolor(senio_spalva);
   setfillstyle(1, senio_spalva);
   ellipse(320, 400, 0, 360, 90, 79);
   floodfill(320, 400, senio_spalva);
   circle(320, 290, 70);
   floodfill(320, 290, senio_spalva);
   circle(320, 200, 45);
   floodfill(320, 200, senio_spalva);

         { nosis }
   setcolor(nosies_spalva);
   setfillstyle(1, nosies_spalva);
   for i := 1 to 7 do
     pieslice(321 - (i * 3), 201 + (i * 2), 0, 360, 8 - i);

         { akys }
   setcolor(akiu_spalva);
   setfillstyle(1, akiu_spalva);
   pieslice(300, 180, 0, 360, 4);
   pieslice(340, 185, 0, 360, 3);

         { burna }
   setfillstyle(1, burnos_spalva);
   setcolor(burnos_spalva);
   pieslice(300, 220, 0, 360, 3);
   pieslice(310, 225, 0, 360, 3);
   pieslice(320, 226, 0, 360, 3);
   pieslice(330, 225, 0, 360, 3);
   pieslice(340, 220, 0, 360, 2);

         { kibiras }
   setcolor(kibiro_spalva);
   setfillstyle(1, kibiro_spalva);
   ellipse(320, 160, 180, 360, 40, 10);
   line(280, 160, 300, 100);
   line(360, 160, 340, 100);
   ellipse(320, 100, 0, 360, 20, 5);
   floodfill(300, 110, kibiro_spalva);
   setfillstyle(1, kibiro_virsaus_spalva);
   floodfill(320, 100, kibiro_spalva);

         { kair” ranka }
   setfillstyle(1, senio_spalva);
   setcolor(senio_spalva);
   pieslice(400, 270, 0, 360, 20);
   pieslice(430, 270, 0, 360, 20);

          { kintam÷j÷ nustatymas }
   anim := 1;
   k := 0;
   for i := 1 to 200 do
     begin
       repeat
         x[i] := random(639)+1;
         snai[i] := random(478)+1;
       until getpixel(x[i], snai[i]) = 0;
     end;

          { animacija }
   repeat
     if timer <= 0 then        { jei jau laikas }
       begin
         case anim of          { tai pie’iam senio rank– ir ’luot– }
           1: begin            { duomenys priklauso nuo animacijos numerio }
                setfillstyle(1, 0);
                setcolor(0);
                pieslice(210, 260, 0, 360, 20);
                sluota(210, 100, 210, 350, 0, 0);
                setfillstyle(1, senio_spalva);
                setcolor(senio_spalva);
                pieslice(210, 270, 0, 360, 20);
                pieslice(240, 270, 0, 360, 20);
                sluota(190, 115, 210, 355, sluotgalio_spalva, sluotos_spalva);
              end;
           2: begin
                setfillstyle(1, 0);
                setcolor(0);
                pieslice(210, 270, 0, 360, 20);
                sluota(190, 115, 210, 355, 0, 0);
                setfillstyle(1, senio_spalva);
                setcolor(senio_spalva);
                pieslice(210, 260, 0, 360, 20);
                pieslice(240, 270, 0, 360, 20);
                sluota(210, 100, 210, 350, sluotgalio_spalva, sluotos_spalva);
              end;
           3: begin
                setfillstyle(1, 0);
                setcolor(0);
                pieslice(210, 260, 0, 360, 20);
                sluota(210, 100, 210, 350, 0, 0);
                setfillstyle(1, senio_spalva);
                setcolor(senio_spalva);
                pieslice(210, 250, 0, 360, 20);
                pieslice(240, 270, 0, 360, 20);
                sluota(220, 100, 200, 340, sluotgalio_spalva, sluotos_spalva);
              end;
           4: begin
                setfillstyle(1, 0);
                setcolor(0);
                pieslice(210, 250, 0, 360, 20);
                sluota(220, 100, 200, 340, 0, 0);
                setfillstyle(1, senio_spalva);
                setcolor(senio_spalva);
                pieslice(210, 260, 0, 360, 20);
                pieslice(240, 270, 0, 360, 20);
                sluota(210, 100, 210, 350, sluotgalio_spalva, sluotos_spalva);
              end;

         end;
         timer := 9000;              { nustatomas uÿdelsimas }
         if anim < 4 then inc(anim)  { kie—iasi animacija }
                     else anim := 1;
       end
     else dec(timer);                { laikas tiksi }

    if i < 200 - 1 then inc(i)       { kei—iasi snaig”s }
                   else i := 1;
    k := random(3); dec(k);          { snaig”s skraido ‘ ’onus }

    pixel := getpixel(x[i] + k, snai[i] + 1);  { —ia d”l optimizacijos }

        { snaig”s gali ir ried”ti }
    if (pixel > 0) then
      if (getpixel(x[i] + k + 1, snai[i] + 1) = 0) then
        begin
          putpixel(x[i], snai[i], 0);
          inc(x[i]);
          pixel := getpixel(x[i] + k, snai[i] + 1);
        end
      else if (getpixel(x[i] + k - 1, snai[i] + 1) = 0) then
        begin
          putpixel(x[i], snai[i], 0);
          dec(x[i]);
          pixel := getpixel(x[i] + k, snai[i] + 1);
        end;


       { ir kristi tiesiai }
    if (pixel > 0) then
      begin
        k := 0;
        pixel := getpixel(x[i] + k, snai[i] + 1);
      end;

       { snaig”s gali ir nut◊pti }
    if (snai[i] < 477) and (pixel = 0)
       then
         begin
           putpixel(x[i], snai[i], 0);
           snai[i] := snai[i] + 1;
         end
       else
         begin
           snai[i] := 1;
           x[i] := random(639) + 1;
         end;
    x[i] := x[i] + k;
    putpixel(x[i], snai[i], 15);

   until keypressed;     { ciklas kol paspaudÿiamas klavi’as }

   closegraph;           { uÿdarom grafik– }
 end.