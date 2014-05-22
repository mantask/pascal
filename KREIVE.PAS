program lauzte;
   uses graph, crt;
   var gd, gm, x1, y1, x2, y2, n : integer;

   procedure kreiveV (x1, y1, x2, y2, n: integer); forward;

   procedure kreiveH (x1, y1, x2, y2, n: integer);
      var il : integer;
   begin
      if n = 1 then line (x1, y1, x2, y2)
      else
        begin
           il := (x2 - x1) div 4;
           kreiveH (x1, y1, x1 + il, y1, n - 1);
           kreiveV (x1 + il, y1, x1 + il, y1 - il, n - 1);
           kreiveH (x1 + il, y1 - il, x1 + 2 * il, y1 - il, n - 1);
           kreiveV (x1 + 2 * il, y1 - il, x1 + 2 * il, y1 + il, n - 1);
           kreiveH (x1 + 2 * il, y1 + il, x1 + 3 * il, y1 + il, n - 1);
           kreiveV (x1 + 3 * il, y1 + il, x1 + 3 * il, y1, n - 1);
           kreiveH (x1 + 3 * il, y1, x1 + 4 * il, y1, n - 1);
        end;
   end;

   procedure kreiveV (x1, y1, x2, y2, n: integer);
      var il : integer;
   begin
      if n = 1 then line (x1, y1, x2, y2)
      else
        begin
           il := (y2 - y1) div 4;
           kreiveV (x1, y1, x1, y1 + il, n - 1);
           kreiveH (x1, y1 + il, x1 + il, y1 + il, n - 1);
           kreiveV (x1 + il, y1 + il, x1 + il, y1 + 2 * il, n - 1);
           kreiveH (x1 + il, y1 + 2 * il, x1 - il, y1 + 2 * il, n - 1);
           kreiveV (x1 - il, y1 + 2 * il, x1 - il, y1 + 3 * il, n - 1);
           kreiveH (x1 - il, y1 + 3 * il, x1, y1 + 3 * il, n - 1);
           kreiveV (x1, y1 + 3 * il, x1, y1 + 4 * il, n - 1);
        end;
   end;

begin
   clrscr;
   write (' Ivesk laipsni ');
   readln (n);
{   write ('Ivesk virsunes koordinates ');
   readln (x1, y1);
   write ('Ivesk apacios koordinates ');
   readln (x2, y2);
 } x1 := 100; y1 := 100; x2 := 400; y2 := 400;
   clrscr;
   gd := detect;
   initgraph (gd, gm, '');
   setcolor(red);
   kreiveH (x1, y1, x2, y1, n);
   kreiveV (x2, y1, x2, y2, n);
   kreiveH (x1, y2, x2, y2, n);
   kreiveV (x1, y1, x1, y2, n);
   readkey;
   if keypressed then readkey;
end.
