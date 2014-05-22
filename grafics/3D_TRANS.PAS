
program transparency; { 3D_13H.PAS }
{ mode-13h version of polygoned objects, by Bas van Gaalen,
  might be slow on some (or actualy most) computers }
uses u_vga,u_pal,u_3d,u_kb;

const
  fpoly=4;
  nofpoints=8;
  nofplanes=6;
  points:array[1..nofpoints,0..2] of integer=(
    (-40,-40,-40),(-40,-40,40),(40,-40,40),(40,-40,-40),
    (-40, 40,-40),(-40, 40,40),(40, 40,40),(40, 40,-40));
  planes:array[1..nofplanes,0..3] of byte=(
    (1,5,6,2),(1,4,8,5),(1,2,3,4),(5,6,7,8),(8,7,3,4),(2,3,7,6));

var virscr:pointer;

procedure hlin(xb,xe,y:integer; c:byte); assembler;
asm
  mov cx,xb
  jcxz @out
  mov bx,cx
  mov cx,xe
  jcxz @out
  cmp bx,cx
  jb @skip
  xchg bx,cx
 @skip:
  jcxz @out
  inc cx
  sub cx,bx
  les di,destenation
  mov ax,y
  shl ax,6
  add di,ax
  shl ax,2
  add di,ax
  add di,bx
  mov al,c
 @l1:
  add es:[di],al
  inc di
  loop @l1
 @out:
end;

function maxi(a,b:integer):integer; inline(
  $58/        { pop   ax     }
  $5b/        { pop   bx     }
  $3b/$c3/    { cmp   ax,bx  }
  $7f/$01/    { jg    +1     }
  $93);       { xchg  ax,bx  }

function mini(a,b:integer):integer; inline(
  $58/        { pop   ax     }
  $5b/        { pop   bx     }
  $3b/$c3/    { cmp   ax,bx  }
  $7c/$01/    { jl    +1     }
  $93);       { xchg  ax,bx  }

{ inrange? }
function ir(value,min,max:integer):integer; inline(
  $59/        { pop   cx max }
  $5b/        { pop   bx min }
  $58/        { pop   ax val }
  $3b/$c3/    { cmp   ax,bx  }
  $7f/$03/    { jg    +3     }
  $93/        { xchg  ax,bx  }
  $eb/$05/    { jmp   +5     }
  $3b/$c1/    { cmp   ax,cx  }
  $7c/$01/    { jl    +1     }
  $91);       { xchg  ax,cx  }

procedure tpolygon(x1,y1,x2,y2,x3,y3,x4,y4,xo,yo:integer; c:byte);
var pos:array[0..199,0..1] of integer;
  xdiv1,xdiv2,xdiv3,xdiv4,ydiv1,ydiv2,ydiv3,ydiv4,ly,gy,y:integer;
  dir1,dir2,dir3,dir4:byte;
  step:shortint;
begin
  { add offsets }
  inc(x1,xo); inc(x2,xo); inc(x3,xo); inc(x4,xo);
  inc(y1,yo); inc(y2,yo); inc(y3,yo); inc(y4,yo);
  { determine highest and lowest point + vertical window checking }
  ly:=maxi(mini(mini(mini(y1,y2),y3),y4),u_miny);
  gy:=mini(maxi(maxi(maxi(y1,y2),y3),y4),u_maxy);
  if ly>u_maxy then exit;
  if gy<u_miny then exit;
  { calculate constants }
  dir1:=byte(y1<y2); xdiv1:=x2-x1; ydiv1:=y2-y1;
  dir2:=byte(y2<y3); xdiv2:=x3-x2; ydiv2:=y3-y2;
  dir3:=byte(y3<y4); xdiv3:=x4-x3; ydiv3:=y4-y3;
  dir4:=byte(y4<y1); xdiv4:=x1-x4; ydiv4:=y1-y4;
  y:=y1; step:=dir1 shl 1-1;
  if y1<>y2 then repeat
    if ir(y,ly,gy)=y then pos[y,dir1]:=ir(xdiv1*(y-y1) div ydiv1+x1,u_minx,u_maxx);
    inc(y,step);
  until y=y2+step
  else if (y>=ly) and (y<=gy) then pos[y,dir1]:=ir(x1,u_minx,u_maxx);
  y:=y2; step:=dir2 shl 1-1;
  if y2<>y3 then repeat
    if ir(y,ly,gy)=y then pos[y,dir2]:=ir(xdiv2*(y-y2) div ydiv2+x2,u_minx,u_maxx);
    inc(y,step);
  until y=y3+step
  else if (y>=ly) and (y<=gy) then pos[y,dir2]:=ir(x2,u_minx,u_maxx);
  y:=y3; step:=dir3 shl 1-1;
  if y3<>y4 then repeat
    if ir(y,ly,gy)=y then pos[y,dir3]:=ir(xdiv3*(y-y3) div ydiv3+x3,u_minx,u_maxx);
    inc(y,step);
  until y=y4+step
  else if (y>=ly) and (y<=gy) then pos[y,dir3]:=ir(x3,u_minx,u_maxx);
  y:=y4; step:=dir4 shl 1-1;
  if y4<>y1 then repeat
    if ir(y,ly,gy)=y then pos[y,dir4]:=ir(xdiv4*(y-y4) div ydiv4+x4,u_minx,u_maxx);
    inc(y,step);
  until y=y1+step
  else if (y>=ly) and (y<=gy) then pos[y,dir4]:=ir(x4,u_minx,u_maxx);
  for y:=ly to gy do hlin(pos[y,0],pos[y,1],y,c);
end;

procedure rotate_object;
const xst=3; yst=1; zst=-2;
var
  xp,yp,z:array[1..nofpoints] of integer;
  x,y:integer;
  n,phix,phiy,phiz:byte;
begin
  phix:=0; phiy:=128; phiz:=0;
  fillchar(xp,sizeof(xp),0);
  fillchar(yp,sizeof(yp),0);
  fillchar(z,sizeof(z),0);
  destenation:=virscr;
  repeat
    vretrace;
    setborder(200);
    cls(virscr,64000); { clear virtual screen }
    for n:=1 to nofpoints do begin
      x:=points[n,0]; y:=points[n,1]; z[n]:=points[n,2]; { get original object }
      rotate(x,y,z[n],phix,phiy,phiz); { rotate it }
      conv3dto2d(xp[n],yp[n],x,y,z[n]); { convert 3d points to 2d }
    end;
    for n:=1 to nofplanes do begin
      polyz[n]:=(z[planes[n,0]]+z[planes[n,1]]+z[planes[n,2]]+z[planes[n,3]]) div 4;
      pind[n]:=n;
    end;
    quicksort(nofplanes); { depth sort }
    for n:=1 to nofplanes do { draw seperate planes }
      tpolygon(xp[planes[pind[n],0]],yp[planes[pind[n],0]],
              xp[planes[pind[n],1]],yp[planes[pind[n],1]],
              xp[planes[pind[n],2]],yp[planes[pind[n],2]],
              xp[planes[pind[n],3]],yp[planes[pind[n],3]],
              160,100,2*pind[n]);
    inc(phix,xst); inc(phiy,yst); inc(phiz,zst); { increase angles }
    setborder(0);
    flip(virscr,ptr(u_vidseg,0),64000); { display screen }
  until keypressed;
end;

var i,j:word;
begin
  setvideo($13);
  {u_border:=true;}
  getmem(virscr,64000); cls(virscr,64000);
  for i:=0 to 63 do setrgb(i+1,10+i div 3,10+i div 3,30+i div 2);
  rotate_object;
  freemem(virscr,64000);
  setvideo(u_lm);
end.
