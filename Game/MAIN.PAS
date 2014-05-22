program main;
  uses crt, graph, peliukas, taik;
  var gm, gd,
      x, y, m,
      xx, yy, mm : integer;
      taikinys : Ttaikinys;
      taikiklis : Ttaikiklis;
      timer : integer absolute $0000:$046c;

  Procedure Refresh; Assembler;
  asm
     mov dx,3DAh
  @@1:
     in al,dx
     and al,08h
     jnz @@1
  @@2:
     in al,dx
     and al,08h
     jz  @@2
  end;

begin
  initgraph (gm, gd, '');
  taikinys.paruosk;
  initmouse;
  hidepointer;
  timer := 0;
  while not keypressed do
   begin
     getxy (x, y, m);
     if (x <> xx) and (y <> yy) then with taikiklis do
      begin
        valyk;
        keiskXY (x, y);
        piesk;
      end;
{     if (m and 1) = 1}
     xx := x; yy := y; mm := m;
     refresh
   end;

  closegraph;
end.