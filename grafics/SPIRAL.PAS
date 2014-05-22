{
  I was going to use Modex, but I couldn't find any way to draw a line from
point x to point y, and save the point with a putpixel etc, so I just
used BGI (plus I didn't want to take too much time on an Apple Basic program
that may or may not work!

  Okay, what is this? It's is a hexagon that is repeated, but put off on a
spiral, it produces quite a cool effect, and I through in a couple ways to
speed it up, I'm using all reals just for simplicity not for speed.

I don't know if any one has ever posted something like this, but here goes.
Converted to Pascal v7.0 from Apple BASIC by John Stephenson Mon 8/8/94
}

uses graph, crt;
var
  cs, co, sn, si, cx, cy, x, y, ad, sf, xo: real;
  j, i: byte;
  grDriver, grMode: Integer;
  xp, yp, color: word;
begin
  grDriver := Detect;
  InitGraph(grDriver, grMode, 'C:\TP\BGI');
  if GraphResult <> grOk then begin
    writeln('It would be a good idea to configure the line with Initgraph on it!');
    readln;
    halt(1);
  end;

  cs := Cos(pi / 3);
  co := Cos(pi / 36);
  sn := Sin(pi / 3);
  si := Sin(pi / 36);
  cx := 140;
  cy := 96;
  ad := 1.16;
  sf := 1.06;
  color := 1;
  repeat
    x := 12;
    y := 0;
    setcolor(color);
    inc(color);
    For j := 0 to 70 do begin
      For i := 0 to 6 do begin
        xp := trunc(cx + x * ad);
        yp := trunc(cy + y);
        If (i = 0) Then PutPixel(xp, yp, color);
        lineto(xp, yp);
        xo := x * cs - y * sn;
        y := x * sn + y * cs;
        x := xo;
      End;
      xo := sf * (x * co - y * si);
      y := sf * (x * si + y * co);
      x := xo;
    End;
  until keypressed;
  CloseGraph;
End.
