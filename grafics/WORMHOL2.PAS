
{$define fast} { 'uncomment' for fast computers, 'comment' for slow comps. }

program wormhole; { WORMHOL2.PAS }
{ Another way to do the Wormhole.
  Realy only for fast computers.
  This one is REAL 3D (and has the
  'moving' effect in it)...
  By Bas van Gaalen }
uses u_vga,u_pal,u_3d,u_kb;
const
  nofcircles=70;
  zstep=5;
  radius=50;
  vidbuf=ptr($a000,0);
{$ifdef fast}
  astep=8;
{$else}
  astep=15;
{$endif}

procedure hole;
var
  circle:array[0..255 div astep] of record x,y:word; end;
  zpos:array[1..nofcircles] of integer;
  virscr:pointer;
  si,i,j,angle:word;
  xo,yo,xp,yp,x,y,z:integer;

procedure sort(l,r:integer);
var i,j,x,y:integer;
begin
  i:=l; j:=r; x:=zpos[(l+r) div 2];
  repeat
    while zpos[i]<x do inc(i);
    while x<zpos[j] do dec(j);
    if i<=j then begin
      y:=zpos[i]; zpos[i]:=zpos[j]; zpos[j]:=y;
      inc(i); dec(j);
    end;
  until i>j;
  if l<j then sort(l,j);
  if i<r then sort(i,r);
end;

begin
  for i:=0 to 255 div astep do begin
    circle[i].x:=radius*ctab[i*astep] div (divd-20);
    circle[i].y:=radius*stab[i*astep] div divd;
  end;
  z:=-200;
  for i:=1 to nofcircles do begin zpos[i]:=z; inc(z,zstep); end;
  getmem(virscr,64000);
  si:=0;
  repeat
    cls(virscr,64000);
    sort(1,nofcircles);
    vretrace;
    for j:=1 to nofcircles do begin
      angle:=0; i:=0;
      xo:=ctab[(si+2*j) mod 255] div 3+stab[(2*si+3*j) mod 255] div 4;
      yo:=stab[(si+2*j) mod 255] div 3+stab[(3*si+2*j) mod 255] div 5;
      while angle<255 do begin
        conv3dto2d(xp,yp,circle[i].x,circle[i].y,zpos[j]);
        inc(xp,xo+160); inc(yp,yo+100);
        asm
          mov dx,xp
          cmp dx,0
          jl @out
          cmp dx,319
          jg @out
          mov ax,yp
          cmp ax,0
          jl @out
          cmp ax,199
          jg @out
          les di,virscr
          shl ax,6
          add di,ax
          shl ax,2
          add di,ax
          add di,dx
          mov ax,j
          mov es:[di],al
         @out:
        end;
        inc(angle,astep); inc(i);
      end;
      inc(zpos[j]); if zpos[j]>(-200+nofcircles*zstep) then zpos[j]:=-200;
    end;
    flip(virscr,vidbuf,64000); inc(si,2);
  until keypressed;
  freemem(virscr,64000);
end;

var i:byte;
begin
  setvideo($13);
  for i:=1 to nofcircles do setrgb(i,15+i shr 2,15+i shr 2,20+i shr 2);
  hole;
  setvideo(u_lm);
end.
