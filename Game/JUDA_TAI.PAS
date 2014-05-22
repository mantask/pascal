uses crt, graph, taik;
 var x, y, sx, sy, gm, gd : integer;
     taikinys : Ttaikinys;
     pg0, pg1 : integer;
     pg : boolean;

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
  initgraph (gd, gm, '');
  taikinys.paruosk;
  setcolor (9);
  moveto (220, 100);
  outtext ('Spausk "Space" buttona');
  repeat until port [$60] = 57;
  cleardevice;
{  setfillstyle (01, 15);
  bar (0, 0, 639, 479);
 } for X := 1 to 649 do with taikinys do
  begin
    x := x + 2;
    valyk;
    y := kelias (x);
    keiskxy (x, y);
    piesk;
    delay (0);
    if port [$60] = 1 then exit;
    if x > 649 then exit;
    delay (1000);
    refresh
  end;
  closegraph;
end.