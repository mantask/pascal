program Mandelbrot;
USES Crt, Graph;
Const
  minx = -2;
  maxx =  1.25;
  miny = -1.25;
  maxy =  1.25;

var dx,dy:real;
    x,y:integer;
    color:integer;
    screen_x,screen_y:integer;
    grDriver:integer;
    grMode:integer;
    ErrCode:integer;

Function calc_pixel(CA,CB:real):integer;
const max_iteration=64;
var
   old_a:real;
   iteration:integer;
   a,b:real;
   length_z:real;
begin
    a:=0;b:=0;
    iteration:=0;
    repeat
         old_a:=a;
         a:=a*a-b*b+ca;
         b:=2*old_a*b+cb;
         iteration:=iteration+1;
         length_z:=a*a+b*b;
     until (length_z>4) or (iteration>max_iteration);
     Calc_Pixel:=iteration;
End;

Begin
    grdriver:=Detect;
    InitGraph(grDriver,grMode,'');
    ErrCode:=GraphResult;
    if ErrCode<>grOk then
      begin
        writeln('could not');
        Writeln('do you have correct..??');
        halt;
      end;

    for x := 0 to 63 do
    setRGBpalette (x, x, x, x * 4);

    screen_x:=getmaxx;
    screen_y:=getmaxy;
    dx:=(MaxX-MinX)/screen_x;
    dy:=(MaxY-MinY)/screen_y;
    for y:=0 to screen_y-1 do
      for x:=0 to screen_x-1 do
         begin
          color:=calc_pixel(MinX+x*dx,MinY+y*dy);
          putpixel(x,y,color);
        end;
     repeat until keypressed;
End.

