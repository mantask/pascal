
program wormhole; { WORMHOL1.PAS}
{ 1st version of wormhole, add movement by changing colors, by Bas van Gaalen }
uses u_vga,u_pal,u_3d,u_kb;
const
  divd=128;
  astep=5;
  xst=4;
  yst=5;
var
  virscr:pointer;
  lstep:byte;

procedure drawpolar(xo,yo,r,a:word; c:byte); assembler;
asm
  les di,virscr
  mov bx,a
  add bx,a
  mov cx,word ptr stab[bx]
  mov ax,word ptr ctab[bx]
  mul r
  mov bx,divd
  xor dx,dx
  cwd
  idiv bx
  add ax,xo
  add ax,160
  cmp ax,319
  ja @out
  mov si,ax
  mov ax,cx
  mul r
  mov bx,divd
  xor dx,dx
  cwd
  idiv bx
  add ax,yo
  add ax,100
  cmp ax,199
  ja @out
  shl ax,6
  mov di,ax
  shl ax,2
  add di,ax
  add di,si
  mov al,c
  mov [es:di],al
 @out:
end;

var x,y,i,j:word; c:byte;
begin
  setvideo($13);
  for i:=1 to 255 do setrgb(i,15+i shr 1,15+i shr 1,20+i shr 1);
  getmem(virscr,64000); cls(virscr,64000);
  x:=30; y:=90;
  repeat
    {retrace;}
    c:=5; lstep:=2; j:=10;
    while j<220 do begin
      i:=0;
      while i<255 do begin
        drawpolar(ctab[(x+(200-j)) mod 255] div 3,stab[(y+(200-j)) mod 255] div 3,j,i,c);
        inc(i,astep);
      end;
      inc(j,lstep);
      if (j mod 5)=0 then begin inc(lstep); inc(c,10); end;
    end;
    x:=xst+x mod 255;
    y:=yst+y mod 255;
    flip(virscr,vidptr,64000);
    cls(virscr,64000);
  until keypressed;
  clearkeybuf;
  freemem(virscr,64000);
  setvideo(u_lm);
end.
