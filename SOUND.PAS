uses crt, graph;

  var gd, gm : integer;
      x, y, z, zz : real;
      cx : integer;
      a : byte;
      f : file of byte;
begin
  {gd := 0;
  initgraph (gd, gm, '');


  for cx := 0 to 639 do
  begin
    x := 20*sin(2*pi*0.05*cx);
    y := 20*sin(2*pi*0.06*cx);
    z := x+y;
    if z > 0 then zz := 20 else zz := -20;
    putpixel (cx, round(x)+100, 15);
    putpixel (cx, round(y)+200, 15);
    putpixel (cx, round(z)+300, 15);
    putpixel (cx, round(zz)+300, 3);
  end;}
{  readkey;}
  assign (f, 'aaa.wav'); reset (f);
  while not eof(f) do
  begin
    read (f, a);
    if a > 127 then port[$61] := $FE
               else port[$61] := $FC;
  end;
  port[$61] := $FC;
  close (f);
{  repeat
    port[$61] := $FE;
    delay (1);
    port[$61] := $FC;
    delay (1);

  until keypressed;}

end.