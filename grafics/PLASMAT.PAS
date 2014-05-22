
program modeq_plasma; { PLASMAT.PAS }
{ Assembler/Mode-q version of Plasma, by Bas van Gaalen }
uses u_mdx,u_vga,u_pal,u_kb;
var stab1,stab2:array[0..255] of byte; i1,j1:byte;

procedure plasma; assembler;
asm
  mov es,u_vidseg
  add i1,254
  add j1,1
  mov di,70*256
  xor cx,cx
  xor bx,bx
 @l0:
  mov bl,cl
  add bl,i1
  mov dl,byte ptr stab1[bx]
  mov bl,j1
  mov dh,byte ptr stab2[bx]
 @l1:
  mov bl,ch
  add bl,dl
  mov al,byte ptr stab1[bx]
  mov bl,cl
  add bl,dh
  add al,byte ptr stab2[bx]
  mov ah,al
  mov [es:di],ax
  add di,256
  mov [es:di],ax
  sub di,254
  add ch,2
  jnz @l1
  add di,256
  add cl,4
  jnz @l0
end;

var x,y:byte;
begin
  mdx_setmodex(mdx_256x256c,256); { set mode-q chained using the mode-x unit }
  for x:=0 to 255 do begin
    setrgb(x,32+trunc(31*sin(x*pi/128)),
             32+trunc(31*sin(x*pi*2/128)),
             32+trunc(31*cos(x*pi*3/128)));
  end;
  for x:=0 to 255 do begin
    stab1[x]:=round(sin(2*pi*x/255)*128)+128;
    stab2[x]:=round(cos(2*pi*x/255)*128)+128;
  end;
  {u_border:=true;}
  repeat
    vretrace;
    setborder(245);
    plasma;
    setborder(0);
  until keypressed;
  setvideo(u_lm);
end.
