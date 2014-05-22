
program cannonball; { CANNON.PAS }
{ Cannonball simulation, with the REAL formula's.
  Draws the track of a launched cannonball - assuming no air-friction.
  By Bas van Gaalen. }
uses u_vga,u_kb;
const
  g=-9.81;    { acceleration due to gravity on Earth at 52øNB (Holland) }
  x0=0;       { x-pos of ball at t=0 }
  y0=100;     { y-pos of ball at t=0 }
  v0=50;      { speed of ball at t=0 }
  phi=50;     { angle to the horizontal at which ball is launched (degrees) }
  dt=0.01;    { interpolation step-size }
var
  t:real;     { time }
  xt,         { x-pos at time t }
  yt,         { y-pos at time t }
  v:integer;  { speed }

function rad(alpha:integer):real; begin
  rad:=(alpha/180)*pi; end;

begin
  setvideo($13);
  t:=0; v:=v0; yt:=1;
  while (not keypressed) and (yt>0) do begin
    xt:=x0+round(v0*cos(rad(phi))*t);
    yt:=y0+round(v*sin(rad(phi))*t+0.5*g*t*t);
    putpixel(xt,199-yt,15);
    t:=t+dt;
  end;
  waitkey(0);
  setvideo(u_lm);
end.
