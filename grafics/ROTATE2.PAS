
program _rotate; { ROTATE2.PAS }
{ Rotating stars in mode 13h, by Bas van Gaalen }
uses u_vga,u_pal,u_3d,u_kb;
const
  radius:word=200; { space rectangular radius }
  maxpoints=100; { maximum number of points }

var
  points:array[1..maxpoints,0..2] of integer;
  maxdepth:word;
  colordiv:byte;

{----------------------------------------------------------------------------}

procedure initialize;
var
  i:word; j:byte;
begin
  randomize;
  for i:=1 to maxpoints do
    for j:=0 to 2 do
      points[i,j]:=random(2*radius)-radius;
  setvideo($13);
  for j:=1 to 63 do setrgb(j,10+j shr 1,10+j shr 1,j);
  maxdepth:=round(sqrt(3*sqr(radius)));
  colordiv:=succ(2*maxdepth div 64);
  dist:=succ(maxdepth div 50)*50;
end;

procedure bump_n_rotate;
const xst=1; yst=1; zst=-1;
var
  xp,yp:array[0..maxpoints] of integer;
  n:word;
  x,y,z:integer;
  phix,phiy,phiz:byte;
begin
  phix:=0; phiy:=0; phiz:=0;
  repeat
    vretrace;
    for n:=1 to maxpoints do begin
      if (xp[n]>=0) and (xp[n]<=319) and (yp[n]>=0) and (yp[n]<=199) then
        putpixel(xp[n],yp[n],0);
      x:=points[n,0]; y:=points[n,1]; z:=points[n,2];
      rotate(x,y,z,phix,phiy,phiz);
      conv3dto2d(xp[n],yp[n],x,y,z);
      inc(xp[n],160); inc(yp[n],100);
      if (xp[n]>=0) and (xp[n]<=319) and (yp[n]>=0) and (yp[n]<=199) then
        putpixel(xp[n],yp[n],(z+maxdepth) div colordiv);
    end;
    inc(phix,xst); inc(phiy,yst); inc(phiz,zst);
  until keypressed;
end;

begin
  initialize;
  bump_n_rotate;
  setvideo(u_lm);
end.
