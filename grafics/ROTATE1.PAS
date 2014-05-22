
program _rotate; { ROTATE1.PAS }
{ Bumping-and-rotating sphere in mode 13h, by Bas van Gaalen }
uses u_vga,u_pal,u_3d,u_kb;
const
  radius=40; { sphere radius }
  maxpoints=1000; { maximum number of points }
  ptab:array[0..255] of byte=(
    123,121,119,117,115,114,112,110,108,106,104,103,101,99,97,96,94,92,91,
    89,87,86,84,82,81,79,78,76,75,73,72,70,69,67,66,64,63,62,60,59,58,56,
    55,54,52,51,50,49,48,46,45,44,43,42,41,39,38,37,36,35,34,33,32,31,30,
    29,28,27,26,26,25,24,23,22,21,21,20,19,18,17,17,16,15,15,14,13,13,12,
    12,11,10,10,9,9,8,8,7,7,6,6,5,5,5,4,4,4,3,3,3,2,2,2,2,1,1,1,1,1,1,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,5,5,6,6,
    7,7,7,8,8,9,9,10,11,11,12,12,13,14,14,15,16,16,17,18,19,19,20,21,22,
    23,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,
    46,47,48,49,51,52,53,54,56,57,58,60,61,62,64,65,67,68,69,71,72,74,75,
    77,78,80,82,83,85,86,88,90,91,93,95,96,98,100,102,103,105,107,109,111,
    113,114,116,118,120,122,124,126);

var
  points:array[1..maxpoints,0..2] of integer;
  nofpoints:word;

{----------------------------------------------------------------------------}

procedure initialize;
const
  step=0.3;
var
  alpha,beta:real;
  i:word;
  r,x,y,z:integer;
begin
  writeln('calculating sphere-data...');
  i:=1;
  alpha:=2*pi;
  while alpha>0 do begin
    beta:=pi;
    while beta>0 do begin
      { torus }
      {r:=round(radius*sin(beta));
      x:=round(r*cos(alpha)*sin(beta));
      y:=-round(0.8333*r*cos(beta));
      z:=-round(r*sin(alpha)*sin(beta));}
      { sphere }
      x:=round(radius*cos(alpha)*sin(beta));
      y:=round(radius*cos(beta));
      z:=round(radius*sin(alpha)*sin(beta));
      points[i,0]:=x; points[i,1]:=y; points[i,2]:=z;
      beta:=beta-step;
      inc(i);
      if i>maxpoints then begin
        writeln('to many points, change step...'); halt; end;
    end;
    alpha:=alpha-step;
  end;
  nofpoints:=pred(i);
  setvideo($13);
  for i:=1 to 128 do setrgb(i,10+i shr 2,10+i shr 2,15+i shr 1);
end;

procedure bump_n_rotate;
const xst=1; yst=1; zst=1; xdiv:shortint=1;
var
  xp,yp:array[0..maxpoints] of integer;
  objx,n:word;
  x,y,z:integer;
  pc,phix,phiy,phiz:byte;
begin
  objx:=radius; pc:=128; phix:=0; phiy:=0; phiz:=0;
  repeat
    vretrace;
    for n:=1 to nofpoints do begin
      if (xp[n]>=0) and (xp[n]<=319) and (yp[n]>=0) and (yp[n]<=199) then
        putpixel(xp[n],yp[n],0);
      x:=points[n,0]; y:=points[n,1]; z:=points[n,2];
      rotate(x,y,z,phix,phiy,phiz);
      conv3dto2d(xp[n],yp[n],x,y,z);
      xp[n]:=xp[n]+objx;
      yp[n]:=yp[n]+ptab[pc]+radius;
      if (xp[n]>=0) and (xp[n]<=319) and (yp[n]>=0) and (yp[n]<=199) then
        putpixel(xp[n],yp[n],z shr 1+radius);
    end;
    inc(objx,xdiv); if (objx<radius) or (objx>(320-radius)) then xdiv:=-xdiv;
    inc(pc,2); inc(phix,xst); inc(phiy,yst); inc(phiz,zst);
  until keypressed;
end;

begin
  initialize;
  bump_n_rotate;
  setvideo(u_lm);
end.
