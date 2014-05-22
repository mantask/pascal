{ MK 2001 }
{ y = sin x + cos x }
program grafikas;

uses
  graph;

var
  gd, gm,
  x, y : integer;
  alfa : real;

begin
  initgraph (gd, gm, '');
  setcolor (8);
  OutTextXY (580, 470, 'MK 2001');
  line (  0, 160, 360, 160);
  line (  0, 200, 360, 200);
  line (  0, 240, 360, 240);
  line (  0, 160,   0, 240);
  line ( 90, 160,  90, 240);
  line (180, 160, 180, 240);
  line (270, 160, 270, 240);
  line (360, 160, 360, 240);
  setcolor (12);
  outtextxy (10, 270, 'y = sin x');
  setcolor (9);
  outtextxy (10, 280, 'y = cos x');
  setcolor (7);
  outtextxy (10, 290, 'y = sin x + cos x');
  setcolor (8);
  outtextxy (  0, 250,  '0');
  outtextxy ( 85, 250,  '90');
  outtextxy (170, 250, '180');
  outtextxy (260, 250, '270');
  outtextxy (350, 250, '360');
  outtextxy (365, 158, ' 1');
  outtextxy (365, 198, ' 0');
  outtextxy (365, 238, '-1');
  for x := 0 to 360 do
  begin
    alfa := x * pi / 180;
    y := 200 - trunc ((sin (alfa) + cos (alfa)) * 40);
    putpixel (x, y, 7);
    y := 200 - trunc (sin (alfa) * 40);
    putpixel (x, y, 12);
    y := 200 - trunc (cos (alfa) * 40);
    putpixel (x, y, 9);
  end;
  repeat until port [$60] = 1;
  closegraph;
end.