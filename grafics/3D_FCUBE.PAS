
program fired_cube; { 3D_FCUBE.PAS }
{ 3D-rotating cube on fire, by Bas van Gaalen,
  slow on a 386, terrible on a 286, great on a 486+ }
uses u_vga,u_pal,u_3d,u_kb;
const
  fpoly=1;
  nofpoints=8;
  nofplanes=6;
  points:array[1..nofpoints,0..2] of integer=(
    (-20,-20,-20),(-20,-20,20),(20,-20,20),(20,-20,-20),
    (-20, 20,-20),(-20, 20,20),(20, 20,20),(20, 20,-20));
  planes:array[1..nofplanes,0..3] of byte=(
    (1,5,6,2),(1,4,8,5),(1,2,3,4),(5,6,7,8),(8,7,3,4),(2,3,7,6));
var virscr:pointer;

procedure fadeout; assembler;
asm
  les di,virscr
  xor cx,cx
 @yloop:
  mov ax,320
  mul cx
  mov bx,65
 @xloop:
  push ax
  add ax,bx
  mov di,ax
  mov si,ax
  xor ah,ah
  xor dx,dx
  mov al,es:[si]
  add dx,ax
  mov al,es:[si+318]
  add dx,ax
  mov al,es:[si+640]
  add dx,ax
  mov al,es:[si+321]
  add dx,ax
  shr dx,2
  jz @skip
  dec dl
 @skip:
  mov [es:di],dl
  pop ax
  inc bx
  cmp bx,270
  jne @xloop
  inc cx
  cmp cx,175
  jne @yloop
end;

procedure rotate_cube;
const xst=2; yst=3; zst=-2;
var
  xp,yp,z:array[1..nofpoints] of integer;
  x,y:integer;
  n,phix,phiy,phiz:byte;
begin
  phix:=0; phiy:=0; phiz:=0;
  fillchar(xp,sizeof(xp),0);
  fillchar(yp,sizeof(yp),0);
  fillchar(z,sizeof(z),0);
  destenation:=virscr;
  repeat
    {vretrace;}
    setborder(250);
    for n:=1 to nofpoints do begin
      x:=points[n,0]; y:=points[n,1]; z[n]:=points[n,2];
      rotate(x,y,z[n],phix,phiy,phiz);
      conv3dto2d(xp[n],yp[n],x,y,z[n]);
      inc(xp[n],160); inc(yp[n],100);
    end;
    for n:=1 to nofplanes do begin
      polyz[n]:=(z[planes[n,0]]+z[planes[n,1]]+z[planes[n,2]]+z[planes[n,3]]) div 4;
      pind[n]:=n;
    end;
    quicksort(nofplanes);
    for n:=fpoly to nofplanes do
      polygon(xp[planes[pind[n],0]],yp[planes[pind[n],0]],
              xp[planes[pind[n],1]],yp[planes[pind[n],1]],
              xp[planes[pind[n],2]],yp[planes[pind[n],2]],
              xp[planes[pind[n],3]],yp[planes[pind[n],3]],
              ctab[phix] div 2,stab[phix] div 3,2*polyz[n]+200);
    inc(phix,xst); inc(phiy,yst); inc(phiz,zst);
    fadeout;
    flip(virscr,ptr(u_vidseg,0),320*200);
    setborder(0);
  until keypressed;
end;

var i:word;
begin
  setvideo($13);
  getmem(virscr,320*203); cls(virscr,320*200);

  for i:=0 to 63 do setrgb(i,0,0,0);
  for i:=0 to 63 do setrgb(64+i,0,0,i shr 1);
  for i:=0 to 63 do setrgb(128+i,i,i shr 1,31-i shr 1);
  for i:=0 to 63 do setrgb(192+i,63,32+i shr 1,0);

  rotate_cube;
  freemem(virscr,320*203);
  setvideo(u_lm);
end.
